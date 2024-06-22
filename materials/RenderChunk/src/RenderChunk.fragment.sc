$input v_color0, v_fog, v_texcoord0, v_lightmapUV
$input v_colors, v_skyMie, v_color1, v_color2, v_color3, v_color4, v_RainFloorReflect
$input v_cpos, v_wpos

#include <bgfx_shader.sh>

uniform vec4 FogColor;
uniform float RenderDistance;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;

SAMPLER2D(s_MatTexture, 0);
SAMPLER2D(s_SeasonsTexture, 1);
SAMPLER2D(s_LightMapTexture, 2);


#include <azify/shader_inputs.glsl>
#include <azify/utils/time.glsl>
#include <azify/utils/functions.glsl>
#include <azify/utils/sky.glsl>

void main() {
    vec4 diffuse;

#if defined(DEPTH_ONLY_OPAQUE) || defined(DEPTH_ONLY)
    diffuse.rgb = vec3(1.0, 1.0, 1.0);
#else
    diffuse = texture2D(s_MatTexture, v_texcoord0);
    vec4 Gtex = texture2DLod(s_MatTexture, v_texcoord0, 0.0);
    if (((Gtex.a > 0.03) && (Gtex.a < 0.06))) {
    float flicker = 1.15 + 0.3 * sin(ViewPositionAndTime.w*1.15);
    diffuse.rgb *= max(vec3(1.0,1.0,1.0), ((flicker * (0.06 - Gtex.w)) / 0.007499993));
    }

#if defined(ALPHA_TEST)
    if (diffuse.a < 0.5) {
        discard;
    }
#endif

#if defined(SEASONS) && (defined(OPAQUE) || defined(ALPHA_TEST))
    diffuse.rgb *= mix(vec3(1.0, 1.0, 1.0),texture2D(s_SeasonsTexture, v_color0.xy).rgb * 2.0, v_color0.b);
    diffuse.rgb *= v_color0.aaa;
#else
    vec3 ncol_0 = normalize(v_color0.rgb);
        if(abs(ncol_0.r - ncol_0.g) > 0.001 || abs(ncol_0.g - ncol_0.b) > 0.001) {
        diffuse = vec4(diffuse.rgb * mix(ncol_0.rgb, v_color0.rgb, 0.45), v_color0.a);
    }
#endif
#endif

#ifndef TRANSPARENT
    diffuse.a = 1.0;
#endif

#if !defined(DEPTH_ONLY_OPAQUE) || !defined(DEPTH_ONLY)
vec3 white = vec3(1.0,1.0,1.0);
vec3 black = vec3(0.0,0.0,0.0);
bool DevUnWater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);
bool DevNether = detectNether(FogColor.rgb, FogAndDistanceControl.xy);
bool waterFlag = v_color0.b > 0.3 && v_color0.a < 0.95;
bool uvwater = false;
if (v_lightmapUV.y < 0.92384 && abs((2.0 * v_cpos.y - 15.0) / 16.0 - v_lightmapUV.y) < 0.00002 && v_lightmapUV.y > 0.187) {
    uvwater = true;
}
vec4 Mtex = texture2DLod(s_MatTexture,v_texcoord0,0.0);
bool DetectGlass = Mtex.a < 0.935 && Mtex.a > 0.0;

// FAKE NORMALMAP ======>
vec4 detMapX;
vec4 detMapY;
vec2 f_norm = vec2(0.3,1.5);
#ifdef WATER_NORMALS
  vec4 d0 = texture2D(s_MatTexture, v_texcoord0 + 0.0);
  detMapX -= texture2D(s_MatTexture, v_texcoord0 + + wNORMAL_INTENSITY);
  detMapX += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  detMapX += texture2D(s_MatTexture, v_texcoord0 + 0.00019 + wNORMAL_INTENSITY);
  detMapX += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  detMapX -= texture2D(s_MatTexture, v_texcoord0 + 0.00005 + wNORMAL_INTENSITY);
  float mapXY = (d0.r - detMapX.r);
  float mapY = (d0.g - detMapX.g);
 vec3 FNormalMap = normalize(vec3(f_norm.g * 
 vec2(mapXY, mapY), 1.));
#else
  detMap = texture2D(s_MatTexture, v_texcoord0);
#endif


// WORLD COLOR ======>
diffuse.rgb *= v_colors.rgb;

// GLOBAL FUNCTIONS  ======>
vec3 dx = dFdx(v_cpos);
vec3 dy = dFdy(v_cpos);
vec3 dXY = cross(dx,dy);
vec3 norml = normalize(dXY);
mat3 tbnMatrix = mat3(abs(norml.y) + norml.z, 0.0, norml.x, 0.0, 0.0, norml.y, -norml.x, norml.y, norml.z);

norml.xy = FNormalMap.xy;
norml.z = sqrt((1.0-dot(norml.xy, norml.xy)));
norml = normalize(norml * tbnMatrix);

float sunAngle = radians(35.0);
vec3 lpos = normalize(vec3(cos(sunAngle), sin(sunAngle), 0.0));

vec3 wnpos = normalize(v_wpos), 
vdir = normalize(-v_wpos), 
hdir = normalize(vdir+lpos), 
refVec = reflect(normalize(v_wpos), norml);

  float NoL = max(0.0,dot(norml, lpos));
  float NoV = max(0.0, dot(norml, vdir));
  float NoH = max(.001, dot(norml, hdir));
  float ndotv = clamp(dot(norml, vdir),0.0,1.0);
  vec4 fresnel = clamp(vec4(getFresnel(NoV, vec3(0.05)), smoothstep(.5, 0., NoV)),0.,1.);


float isNoCave = pow(v_lightmapUV.y, 2.0);
vec3 skyfog = v_skyMie.rgb;
float Tlight = pow(v_lightmapUV.x, 3.5);

// NEW AMBIENT OCCLUSION ======>
#ifdef SUPER_AO
float ShadDir = max(abs(norml.x), -norml.y);
diffuse.rgb *= mix(white, v_color2.rgb, ShadDir);
#endif

// FAKE DIRECTIONAL LIGHT ======>
#ifdef DIRECT_LIGHT
  #ifndef TRANSPARENT
vec3 dirlitCC;
float absNormX = abs(norml.x);
float absNormZ = abs(norml.z);
float dp1 = max(absNormX, -norml.y);
float dp2 = absNormZ;

vec3 DirSh = mix(mDS_DAYc, mDS_NIGHTc, AFnight);
DirSh = mix(DirSh, mDS_DUSKc, AFdusk);
DirSh = mix(DirSh, mDS_RAINc, AFrain);
vec3 DirHi = mix(mDL_DAYc, mDL_NIGHTc, AFnight);
DirHi = mix(DirHi, mDL_DUSKc, AFdusk);
DirHi = mix(DirHi, mDL_RAINc, AFrain);

float Factdp1 = isNoCave * dp1;
float Factdp2 = isNoCave * dp2;
vec3 colorFactor1 = mix(white, DirSh, Factdp1);
vec3 colorFactor2 = mix(white, DirHi, Factdp2);
dirlitCC = mix(white, (colorFactor1 * colorFactor2), 1.0 - Tlight);

diffuse.rgb *= dirlitCC;
  #endif
#endif


// WATER FUNCTIONS  ======>
#ifdef TRANSPARENT
if (waterFlag) {
// WATER LINES ======>
#ifdef WATER_LINES
if (texture2D(s_MatTexture,v_texcoord0).b > WATERLINE_INTENSITY) {
vec3 wlc = mix(wLINE_DAYc,wLINE_NIGHTc,AFnight);
     wlc = mix(black,wlc,v_lightmapUV.y);
     diffuse.a = WATERLINE_OPACITY;
     diffuse += vec4(wlc, 1.0);
  }
#endif


// WATER GRADIENT ======>
#ifdef WATER_GRADIENT
vec3 viewPos = clamp(normalize(vdir),0.,1.);
float minPos = min(viewPos.y, 0.005);
vec3 skyM = calculateSky(diffuse.rgb, viewPos, minPos);
diffuse = vec4(mix(diffuse.rgb, skyM, fresnel.rgb), mix(diffuse.a*0.1,0.9,fresnel.a));
#endif
}
#endif


// CAUSTICS  ======>
#ifdef CAUSTICS
float caustics = voronoi((v_cpos.xz + v_cpos.y) * 0.3, ViewPositionAndTime.w);
if (uvwater) {
diffuse.rgb += max(caustics, 0.0) * 0.7 * diffuse.rgb;
}
#endif


// BLOCK REFLECTIONS ======>
#ifdef BLOCK_REFLECTION
 #ifndef ALPHA_TEST
  #ifndef TRANSPARENT
if (Mtex.a < 0.88 && Mtex.a > 0.83) {
float GDist = smoothstep(1.0, 0.2, dot(norml, normalize(-v_wpos)));
float Grand1 = 0.17;
float Grand2 = mix(2.51, 2.0, AFnight);
vec3 reflectVec = reflect(normalize(v_wpos), norml);
float noiseValue = noise(vec2(atan2(v_wpos.x, v_wpos.z), atan2(v_wpos.x, v_wpos.z)) * 9.4);
vec3 baseColor = mix(white * Grand1, vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
float weight = clamp(length(v_wpos.xz * 0.06), 0.0, 1.0);
vec3 finalColor = GDist * mix(black, baseColor, weight * clamp(reflectVec.y, 0.0, 1.0)) * v_lightmapUV.y;

diffuse.rgb += finalColor;
}
  #endif
 #endif
#endif

// RAIN FLOOR REFLECTION ======>
#ifdef FLOOR_REFLECTION
 #ifndef ALPHA_TEST
  #ifndef TRANSPARENT
    if (DevUnWater) {
    } else {
    diffuse.rgb = mix(diffuse.rgb, v_RainFloorReflect.rgb, max(0.0,norml.y) * v_RainFloorReflect.a);
    }
  #endif
 #endif
#endif

// FOG REMAKE ======>
#ifdef FOG
  if (DevUnWater) {
    diffuse.rgb = mix(diffuse.rgb, UNDERWATER_FOG, v_fog.a);
  } else if (DevNether) {
  } else {
    diffuse.rgb = mix(diffuse.rgb, skyfog, v_fog.a);
  }
#endif
#endif // End of (DEPTH_ONLY_OPAQUE) (DEPTH_ONLY)
  // TONE MAPPING ======>
  diffuse.rgb = AzifyFN(diffuse.rgb);
  gl_FragColor = diffuse;
}