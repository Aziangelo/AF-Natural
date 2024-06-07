$input a_color0, a_position, a_texcoord0, a_texcoord1
#ifdef INSTANCING
    $input i_data0, i_data1, i_data2
#endif
$output v_color0, v_fog, v_texcoord0, v_lightmapUV, v_colors, v_skyMie, v_cpos, v_wpos, v_color1, v_RainFloorReflect

#include <bgfx_shader.sh>

uniform vec4 RenderChunkFogAlpha;
uniform vec4 FogAndDistanceControl;
uniform vec4 Viev_wpositionAndTime;
uniform vec4 FogColor;
uniform float RenderDistance;

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
    mat4 model;
#ifdef INSTANCING
    model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0, 0, 0, 1));
#else
    model = u_model[0];
#endif


    vec3 worldPos = mul(model, vec4(a_position, 1.0)).xyz;
    vec4 color;
    //ChunkAnimation
#ifdef CHUNK_ANIMATION
    float bI = 7.5;
    float bS = 1.2;
    float bX = abs(sin(RenderChunkFogAlpha.x * bS * 3.14159));
    worldPos.y -= (600.0 * pow(RenderChunkFogAlpha.x,3.0));
    worldPos.y += bI * bX;
#endif
    color = a_color0;

    vec3 modelCamPos = (Viev_wpositionAndTime.xyz - worldPos);
    float camDis = length(modelCamPos);
    vec4 fogColor;
    fogColor.rgb = FogColor.rgb;
    fogColor.a = clamp(((((camDis / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) -
        FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x)), 0.0, 1.0);

#ifdef TRANSPARENT
    if(a_color0.a < 0.95) {
        color.a = mix(a_color0.a, 1.0, clamp((camDis / FogAndDistanceControl.w), 0.0, 1.0));
    };
#endif

 float cve1 = smoothstep(0.92, 0.89, a_texcoord1.y);
 float cve2 = smoothstep(0.68, 0.05, a_texcoord1.y);
 vec3 shadC = (vec3(0.8, 0.93, 1.0)*0.85);
 vec4 shadowCC;
shadowCC.rgb = mix(mix(vec3(1.0), shadC, cve1 * (1.0-cve2)), vec3(1.0, 0.93, 0.9), pow(a_texcoord1.x, 3.5));
 float cve0 = pow(1.0 - a_texcoord1.y, 1.2);
 vec3 mainCC;
  mainCC = mix(DAYc, DUSKc, AFdusk);
  mainCC = mix(mainCC, NIGHTc, AFnight);
  mainCC = mix(mainCC, RAINc, AFrain);
  mainCC = mix(mainCC, CAVEc, cve0);
  mainCC = mix(mainCC, vec3(1.0), pow(a_texcoord1.x, 3.5));
 vec4 lightCC;
 vec3 torchcc = mix(vec3(0.1), vec3(0.6), AFdusk * AFnight);
torchcc = mix(torchcc, vec3(0.46), smoothstep(0.88, 0.35, a_texcoord1.y));
lightCC.rgb = (torchcc * pow(a_texcoord1.x, 3.5));
 vec4 Azify;
Azify.rgb = (mainCC.rgb * shadowCC.rgb + lightCC.rgb);


 vec3 v_skypos = (worldPos.xyz + vec3(0.0, 0.128, 0.0));
 vec3 v_viewpos = normalize(v_skypos);
v_viewpos.y = (v_viewpos.y - 0.0128);
 float v_pos = min(v_viewpos.y, 0.005);
v_viewpos.y = max(v_viewpos.y, 0.0);
 vec3 albedo1;
albedo1 = mix(SA_DAY, SA_DUSK, AFdusk);
albedo1 = mix(albedo1, SA_NIGHT, AFnight);
albedo1 = mix(albedo1, SA_RAIN, AFrain);
 vec3 albedo2;
albedo2 = mix(SB_DAY, SB_DUSK, AFdusk);
albedo2 = mix(albedo2, SB_NIGHT, AFnight);
albedo2 = mix(albedo2, SB_RAIN, AFrain);
 vec3 albedo3;
albedo3 = mix(SC_DAY, SC_DUSK, AFdusk);
albedo3 = mix(albedo3, SC_NIGHT, AFnight);
albedo3 = mix(albedo3, SC_RAIN, AFrain);
 vec3 albedo4;
albedo4 = vec3(0.0);
albedo4 += (albedo2 * exp(-v_viewpos.y * 4.0));
albedo4 += (albedo1 * (1.0 - exp(-v_viewpos.y * 10.0)));
albedo4 = mix(albedo4, albedo3, (1.0 - exp(v_pos * 8.0)));
vec3 skyCol = albedo4-0.18;


  vec3 a_pos = normalize(-worldPos.xyz);
  float smtr1 = smoothstep(0.5, 0.0, a_pos.y);
  float fogDist = mix(0.0, mix(0.0, 0.7, smtr1), AFrain * a_texcoord1.y);
  vec4 azifyColor1;
  azifyColor1.rgb = skyCol;
  azifyColor1.a = fogDist;

    vec4 horizon;
    horizon.rgb = skyCol;
    v_texcoord0 = a_texcoord0;
    v_lightmapUV = a_texcoord1;
    v_color0 = a_color0;
    v_fog = fogColor;
    v_colors = Azify;
    v_skyMie = horizon;
    v_cpos = a_position;
    v_wpos = worldPos.xyz;
    v_color1 = a_color0;
    v_RainFloorReflect = azifyColor1;
    gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
}
