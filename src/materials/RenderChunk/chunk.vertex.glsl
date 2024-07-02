$input a_color0, a_position, a_texcoord0, a_texcoord1
#ifdef INSTANCING
$input i_data0, i_data1, i_data2
#endif
$output v_color0, v_fog, v_texcoord0, v_lightmapUV
$output v_worldColors, v_skyMie, v_AO, v_color2, v_color3, v_color4, v_RainFloorReflect
$output v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
  mat4 model;
  #ifdef INSTANCING
  model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0, 0, 0, 1));
  #else
  model = u_model[0];
  #endif

  vec3 worldPos = mul(model, vec4(a_position, 1.0)).xyz;
  vec4 color;
  #ifdef CHUNK_ANIMATION
  float bI = 7.5;
  float bS = 1.2;
  float bX = abs(sin(RenderChunkFogAlpha.x * bS * 3.14159));
  float fogEffect = 600.0 * pow(RenderChunkFogAlpha.x, 3.0);
  worldPos.y += bI * bX - fogEffect;
  #endif // CHUNK_ANIMATION

  color = a_color0;
  vec3 modelCamPos = (ViewPositionAndTime.xyz - worldPos);
  float camDis = length(modelCamPos);
  vec4 fogColor;
  fogColor.rgb = FogColor.rgb;
  fogColor.a = clamp(((((camDis / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x)), 0.0, 1.0);

  #ifdef TRANSPARENT
  if(a_color0.a < 0.95) {
    color.a = mix(a_color0.a, 1.0, clamp((camDis / FogAndDistanceControl.w), 0.0, 1.0));
  };
  #endif

  bool getUnWater;
  bool getNether;
  getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);

  vec4 ambientOcclusion;
  vec3 ncol_1 = normalize(a_color0.rgb);
  float minColor = min(a_color0.r, a_color0.b);
  float FactorAO = a_color0.g * 2.0 - minColor;
  float negative = 1.0 - FactorAO * 1.4;
  float adjustAO = clamp(negative * 0.9, 0.0, 1.0);
  ambientOcclusion.rgb = mix(vec3(1.0, 1.0, 1.0), vec3(0.3, 0.3, 0.3), adjustAO);
  ambientOcclusion.a = 1.0;


  float outerCave = smoothstep(0.91,0.9,a_texcoord1.y);
  float middlCave = smoothstep(0.68,0.05,a_texcoord1.y);

  vec3 getShadowColor = CAVEOUTc;
  vec3 getShadow = mix(mix(vec3(1.0, 1.0, 1.0), getShadowColor, outerCave*(1.0-middlCave)), vec3(1.0, 0.93, 0.9), pow(a_texcoord1.x, 3.5));
  
  float invPowCave = pow(1.0-a_texcoord1.y, 1.2);
  vec3 RainC = mix(D_RAINc, N_RAINc, AFnight);
  vec3 getMainColor;
  getMainColor = mix(DAYc, DUSKc, AFdusk);
  getMainColor = mix(getMainColor, NIGHTc, AFnight);
  getMainColor = mix(getMainColor, RainC, AFrain);
  getMainColor = mix(getMainColor, CAVEc, invPowCave);
  getMainColor = mix(getMainColor, NETHERc, float(getNether));
  getMainColor = mix(getMainColor, vec3(1.0, 1.0, 1.0), pow(a_texcoord1.x, 3.5));

  vec3 getLightColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.6, 0.6), AFdusk * AFnight);
  getLightColor = mix(getLightColor, vec3(0.46, 0.46, 0.46), smoothstep(0.88, 0.35, a_texcoord1.y));
  vec3 getLights = getLightColor*pow(a_texcoord1.x, 3.5);
  vec4 Azify;
  Azify.rgb = (getMainColor*getShadow+getLights);
  Azify.a = 1.0;
  
  vec3 viewPos = normalize(worldPos);
  float minPos = min(viewPos.y, 0.005);
  viewPos.y = max(viewPos.y, 0.0);
  vec4 getSky;
  getSky.rgb = calculateSky(SkyColor.rgb, viewPos, minPos);
  getSky.a = 1.0;

  vec3 n_wpos = normalize(-worldPos);
  float fogPosition = mix(0.0, 
    mix(0.0, 0.65, smoothstep(0.5, 0.0, n_wpos.y)), abs(a_texcoord1.y) * AFrain);
  vec4 azifyFog;
  azifyFog.rgb = getSky.rgb;
  azifyFog.a = fogPosition*0.7;
  
  v_texcoord0 = a_texcoord0;
  v_lightmapUV = a_texcoord1;
  v_color0 = a_color0;
  v_fog = fogColor;
  v_cpos = a_position;
  v_wpos = worldPos;
  v_AO = ambientOcclusion;
  v_worldColors = Azify;
  v_skyMie = getSky;
  v_RainFloorReflect = azifyFog;
  gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
}