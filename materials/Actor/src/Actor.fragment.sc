$input v_color0, v_fog, v_light, v_texcoord0, v_lightmapUV, v_colors, v_skyMie, v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <MinecraftRenderer.Materials/ActorUtil.dragonh>
#include <MinecraftRenderer.Materials/FogUtil.dragonh>

uniform vec4 ColorBased;
uniform vec4 ChangeColor;
uniform vec4 UseAlphaRewrite;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 MatColor;
uniform vec4 OverlayColor;
uniform vec4 TileLightColor;
uniform vec4 MultiplicativeTintColor;
uniform vec4 FogColor;
uniform vec4 FogControl;
uniform vec4 ActorFPEpsilon;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 FogAndDistanceControl;
uniform vec4 HudOpacity;
uniform vec4 UVAnimation;
uniform mat4 Bones[8];

SAMPLER2D(s_MatTexture, 0);
SAMPLER2D(s_MatTexture1, 1);

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
#if DEPTH_ONLY
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    return;
#elif DEPTH_ONLY_OPAQUE
    gl_FragColor = vec4(applyFog(vec3(1.0, 1.0, 1.0), v_fog.rgb, v_fog.a), 1.0);
    return;
#else

    vec4 albedo = getActorAlbedoNoColorChange(v_texcoord0, s_MatTexture, s_MatTexture1, MatColor);

#if ALPHA_TEST
    float alpha = mix(albedo.a, (albedo.a * OverlayColor.a), TintedAlphaTestEnabled.x);
    if(shouldDiscard(albedo.rgb, alpha, ActorFPEpsilon.x)) {
        discard;
    }
#endif // ALPHA_TEST

#if CHANGE_COLOR_MULTI
    albedo = applyMultiColorChange(albedo, ChangeColor.rgb, MultiplicativeTintColor.rgb);
#elif CHANGE_COLOR
    albedo = applyColorChange(albedo, ChangeColor, albedo.a);
    albedo.a *= ChangeColor.a;
#endif // CHANGE_COLOR_MULTI

#if ALPHA_TEST
    albedo.a = max(UseAlphaRewrite.r, albedo.a);
#endif

    albedo = applyActorDiffuse(albedo, v_color0.rgb, vec4(grayscale(v_light.rgb), v_light.a), ColorBased.x, OverlayColor);
    //albedo = applyActorDiffuse(albedo, v_color0.rgb, v_light, ColorBased.x, OverlayColor);

#if TRANSPARENT
    albedo = applyHudOpacity(albedo, HudOpacity.x);
#endif

 bool DevEnd = FogColor.r > FogColor.g && FogColor.b > FogColor.g && FogColor.r <= 0.05 && FogColor.g <= 0.05 && FogColor.b <= 0.05 && FogAndDistanceControl.x >= 0.56 && FogAndDistanceControl.x <= 0.8 && FogAndDistanceControl.y >= 0.59;
 bool nether = detectNether(FogColor.rgb, FogAndDistanceControl.xy);
 bool DevUnWater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);
 
  bool isDaytime = false;
  bool isDusk = false;
  bool isNighttime = false;
  bool isInCave = false;
  float dayThreshold = 0.9;
  float duskThreshold = 0.6;
  float nightThreshold = 0.34;
  float caveThreshold = 0.34;
  
  if (v_light.x >= dayThreshold) {
      isDaytime = true;
  } else if (v_light.x >= duskThreshold && v_light.x < dayThreshold) {
      isDusk = true;
  } else if (v_light.x >= nightThreshold && v_light.x < duskThreshold) {
      isNighttime = true;
  } else if (v_light.x < caveThreshold) {
      isInCave = true;
  }
  
  if (v_light.x < caveThreshold) {
      isInCave = true;
      isDaytime = false;
      isDusk = false;
      isNighttime = false;
  }

 if (DevEnd) {
   albedo.rgb *= vec3(0.85);
 } else if (nether) {
   albedo.rgb *= vec3(0.9);
 } else if (!isInCave) {
   albedo.rgb *= v_colors.xyz;
 } else if (isInCave) {
   albedo.rgb *= ECAVEc+0.863;
 }

 vec3 norml = normalize(cross(dFdx(v_cpos), dFdy(v_cpos)));
 vec3 dirlitCC;
 float dp1 = max(abs(norml.z), norml.y);
 float dp2 = abs(norml.x);
 float isTorch = smoothstep(0.5, 1.0, v_light.r);
 isTorch =  (pow(isTorch, 2.0)*0.5+isTorch*0.5);

if (DevEnd) {

} else if (nether) {

} else if (!isInCave) {
// Shadows
vec3 ccmix1 = mix(mDS_DAYc, mDS_NIGHTc-1.0, AFnight);
ccmix1 = mix(ccmix1, mDS_DUSKc, AFdusk);
ccmix1 = mix(ccmix1, mix(mDS_RAINc, mDS_RAINc, AFnight), AFrain);
// Highlights
vec3 ccmix2 = mix(mDL_DAYc, mDL_NIGHTc-1.5, AFnight);
ccmix2 = mix(ccmix2, mDL_DUSKc, AFdusk);
ccmix2 = mix(ccmix2, mix(mDL_RAINc, mDL_RAINc, AFnight), AFrain);

vec3 colorFactor1 = mix(vec3(1.0), ccmix1, dp1);
vec3 colorFactor2 = mix(vec3(1.0), ccmix2, dp2);

dirlitCC = (colorFactor1 * colorFactor2);
albedo.rgb *= dirlitCC;
} /*else if (isInCave) {
  if (isDaytime) {
    /*
// Shadows
vec3 ccmix1 = vec3(mDS_DAYc+0.1);
// Highlights
vec3 ccmix2 = vec3(0.9,0.8,0.7);

vec3 colorFactor1 = mix(vec3(1.0), ccmix1, dp1);
vec3 colorFactor2 = mix(vec3(1.0), ccmix2, dp2);

dirlitCC = (colorFactor1 * colorFactor2);
albedo.rgb *= dirlitCC;*/
 

albedo.rgb = AzifyFN(albedo.rgb);
if (DevUnWater) {
  albedo.rgb = mix(albedo.rgb, UNDERWATER_FOG, v_fog.a);
} else {
  albedo.rgb = applyFog(albedo.rgb, v_skyMie.rgb, v_fog.a);
}
    gl_FragColor = albedo;
#endif // DEPTH_ONLY
}
