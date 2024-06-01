$input a_position, a_color0, a_texcoord0, a_indices, a_normal
#ifdef INSTANCING
    $input i_data0, i_data1, i_data2
#endif

$output v_color0, v_fog, v_light, v_texcoord0, v_lightmapUV, v_colors, v_skyMie, v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <MinecraftRenderer.Materials/FogUtil.dragonh>
#include <MinecraftRenderer.Materials/DynamicUtil.dragonh>
#include <MinecraftRenderer.Materials/TAAUtil.dragonh>

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
uniform vec4 LightDiffuseColorAndIntensity;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 FogAndDistanceControl;
uniform vec4 HudOpacity;
uniform vec4 UVAnimation;
uniform mat4 Bones[8];

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
    mat4 World = u_model[0];
    
    //StandardTemplate_InvokeVertexPreprocessFunction
    World = mul(World, Bones[int(a_indices)]);

    vec2 texcoord0 = a_texcoord0;
    texcoord0 = applyUvAnimation(texcoord0, UVAnimation);

    float lightIntensity = calculateLightIntensity(World, vec4(a_normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.0;
    vec4 light = vec4(lightIntensity * TileLightColor.rgb, 1.0);
    
    //StandardTemplate_VertSharedTransform
    vec3 worldPosition;
#ifdef INSTANCING
  mat4 model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0.0, 0.0, 0.0, 1.0));
  worldPosition = instMul(model, vec4(a_position, 1.0)).xyz;
#else
  worldPosition = mul(World, vec4(a_position, 1.0)).xyz;
#endif
    
    vec4 position;// = mul(u_viewProj, vec4(worldPosition, 1.0));

    //StandardTemplate_InvokeVertexOverrideFunction
    position = jitterVertexPosition(worldPosition);
    float cameraDepth = position.z;
    float fogIntensity = calculateFogIntensity(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vec4 fog = vec4(FogColor.rgb, fogIntensity);

#if defined(DEPTH_ONLY)
    v_texcoord0 = vec2(0.0, 0.0);
    v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
#else
    v_texcoord0 = texcoord0;
    v_color0 = a_color0;
#endif

 
 vec3 raincc = mix(RAINc*1.2, RAINc*2.65, AFnight);
 vec3 mainCC;
   mainCC = mix(DAYc*0.85, DUSKc*1.5, AFdusk);
   mainCC = mix(mainCC, NIGHTc*2.2, AFnight);
   mainCC = mix(mainCC, raincc, AFrain);
 vec4 Azify;
   Azify.xyz = (mainCC.xyz);

 vec3 v_skypos = (worldPosition.xyz + vec3(0.0, 0.128, 0.0));
 vec3 v_viewpos = normalize(v_skypos);
v_viewpos.y = (v_viewpos.y - 0.0128);
 float v_pos = min(v_viewpos.y, 0.005);
v_viewpos.y = max(v_viewpos.y, 0.0);
 vec3 scc_01 = vec3(0.17,0.42,0.6);
 vec3 scc_02 = vec3(0.1,0.23,0.4);
 vec3 scc_03 = vec3(0.07,0.1,0.2);
 vec3 scc_04 = vec3(0.3);
 vec3 scc_05 = vec3(0.95,1.0,0.9);
 vec3 scc_06 = vec3(1.0,0.45,0.23);
 vec3 scc_07 = vec3(0.35,0.1,0.25);
 vec3 scc_08 = vec3(0.5);
 vec3 scc_09 = vec3(0.3,0.4,0.6);
 vec3 scc_10 = vec3(0.6,0.4,0.3);
 vec3 scc_11 = (vec3(0.1,0.3,0.5) * 0.2);
 vec3 scc_12 = vec3(0.2);
 vec3 albedo1;
albedo1 = mix(scc_01, scc_02, AFdusk);
albedo1 = mix(albedo1, scc_03, AFnight);
albedo1 = mix(albedo1, scc_04, AFrain);
 vec3 albedo2;
albedo2 = mix(scc_05, scc_06, AFdusk);
albedo2 = mix(albedo2, scc_07, AFnight);
albedo2 = mix(albedo2, scc_08, AFrain);
 vec3 albedo3;
albedo3 = mix(scc_09, scc_10, AFdusk);
albedo3 = mix(albedo3, scc_11, AFnight);
albedo3 = mix(albedo3, scc_12, AFrain);
 vec3 albedo4;
albedo4 = vec3(0.0);
albedo4 += (albedo2 * exp(-v_viewpos.y * 4.0));
albedo4 += (albedo1 * (1.0 - exp(-v_viewpos.y * 10.0)));
albedo4 = mix(albedo4, albedo3, (1.0 - exp(v_pos * 8.0)));
    
 vec4 horizon;
   horizon.xyz = albedo4;
   v_cpos = a_position;
   v_wpos = worldPosition.xyz;
   v_colors = Azify;
   v_fog = fog; 
   v_skyMie = horizon;
   v_light = light;
    gl_Position = position;
}
