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
  fogColor.a =
  clamp(((((camDis / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y)), 0.0, 1.0);

  #ifdef TRANSPARENT
  if(a_color0.a < 0.95) {
    color.a = mix(a_color0.a, 1.0, clamp((camDis / FogAndDistanceControl.w), 0.0, 1.0));
  };
  #endif

  vec4 ambientOcclusion;
  vec3 ncol_1 = normalize(a_color0.rgb);
  float minColor = min(a_color0.r, a_color0.b);
  float FactorAO = a_color0.g * 2.0 - minColor;
  float negative = 1.0 - FactorAO * 1.4;
  float adjustAO = clamp(negative * 0.9, 0.0, 1.0);
  ambientOcclusion.rgb = mix(vec3(1.0, 1.0, 1.0), vec3(0.3, 0.3, 0.3), adjustAO);
  ambientOcclusion.a = 1.0;


  float cve1 = smoothstep(0.92,0.89,a_texcoord1.y);
  float cve2 = smoothstep(0.68,0.05,a_texcoord1.y);

  vec3 getShadowColor = vec3(0.8, 0.93, 1.0)*0.85;
  vec3 getShadow = mix(mix(vec3(1.0, 1.0, 1.0), getShadowColor, cve1 * (1.0-cve2)), vec3(1.0, 0.93, 0.9), pow(a_texcoord1.x, 3.5));
  
  float cve0 = pow(1.0-a_texcoord1.y, 1.2);
  vec3 getMainColor;
  getMainColor = mix(DAYc, DUSKc, AFdusk);
  getMainColor = mix(getMainColor, NIGHTc, AFnight);
  getMainColor = mix(getMainColor, RAINc, AFrain);
  getMainColor = mix(getMainColor, CAVEc, cve0);
  getMainColor = mix(getMainColor, vec3(1.0, 1.0, 1.0), pow(a_texcoord1.x, 3.5));

  vec3 getLightColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.6, 0.6), AFdusk * AFnight);
  getLightColor = mix(getLightColor, vec3(0.46, 0.46, 0.46), smoothstep(0.88, 0.35, a_texcoord1.y));
  vec3 getLights = getLightColor*pow(a_texcoord1.x, 3.5);
  vec4 Azify;
  Azify.rgb = (getMainColor*getShadow+getLights);
  Azify.a = 1.0;

  v_texcoord0 = a_texcoord0;
  v_lightmapUV = a_texcoord1;
  v_color0 = color;
  v_fog = fogColor;
  v_cpos = a_position;
  v_wpos = worldPos;
  v_AO = ambientOcclusion;
  v_worldColors = Azify;
  gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
}