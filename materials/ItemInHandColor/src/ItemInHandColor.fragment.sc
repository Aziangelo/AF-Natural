$input v_texcoord0, v_color0, v_light, v_fog, v_colors, v_skyMie, v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <MinecraftRenderer.Materials/DynamicUtil.dragonh>
#include <MinecraftRenderer.Materials/FogUtil.dragonh>

uniform vec4 ChangeColor;
uniform vec4 OverlayColor;
uniform vec4 ColorBased;
uniform vec4 MultiplicativeTintColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
#if DEPTH_ONLY
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    return;
#else
    vec4 albedo;
    albedo.rgb = mix(vec3(1.0, 1.0, 1.0), v_color0.rgb, ColorBased.x);
    albedo.a = 1.0;

#if MULTI_COLOR_TINT
    albedo = applyMultiColorChange(albedo, ChangeColor.rgb, MultiplicativeTintColor.rgb);
#else
    albedo = applyColorChange(albedo, ChangeColor, v_color0.a);
#endif

    albedo = applyOverlayColor(albedo, OverlayColor);
    albedo = applyLighting(albedo, vec4(grayscale(v_light.rgb), v_light.a));

#if ALPHA_TEST
    if (albedo.a < 0.5) {
        discard;
    }
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
 float dp1 = max(abs(norml.x), norml.y);
 float dp2 = abs(norml.z);
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
}

if (DevUnWater) {
  albedo.rgb = mix(albedo.rgb, UNDERWATER_FOG, v_fog.a);
} else {
  albedo.rgb = applyFog(albedo.rgb, v_skyMie.rgb, v_fog.a);
}
albedo.rgb = AzifyFN(albedo.rgb);
    gl_FragColor = albedo;
#endif // DEPTH_ONLY
}
