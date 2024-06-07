$input a_position, a_normal, a_texcoord0, a_color0
#if INSTANCING
    $input i_data0, i_data1, i_data2
#endif

$output v_texcoord0, v_color0, v_light, v_fog, v_colors, v_skyMie, v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <MinecraftRenderer.Materials/DynamicUtil.dragonh>
#include <MinecraftRenderer.Materials/FogUtil.dragonh>
#include <MinecraftRenderer.Materials/TAAUtil.dragonh>

uniform vec4 FogControl;
uniform vec4 OverlayColor;
uniform vec4 FogColor;
uniform vec4 TileLightColor;
uniform vec4 FogAndDistanceControl;

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
    mat4 World = u_model[0];

    float lightIntensity = calculateLightIntensity(World, vec4(a_normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.35;
    vec4 light = vec4(lightIntensity * TileLightColor.rgb, 1.0);

    vec3 worldPosition;
#if INSTANCING
    mat4 model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0.0, 0.0, 0.0, 1.0));
    worldPosition = instMul(model, vec4(a_position, 1.0)).xyz;
#else
    worldPosition = mul(World, vec4(a_position, 1.0)).xyz;
#endif

    vec4 position = jitterVertexPosition(worldPosition);
    float cameraDepth = position.z;
    float fogIntensity = calculateFogIntensity(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vec4 fog = vec4(FogColor.rgb, fogIntensity);

#if DEPTH_ONLY
    v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
#else
    v_color0 = a_color0;
#endif


bool isDaytime = false;
bool isDusk = false;
bool isNighttime = false;
bool isInCave = false;

float dayThreshold = 0.9;
float duskThreshold = 0.6;
float nightThreshold = 0.3;
float caveThreshold = 0.3;
float torchThreshold = 0.8; 

if (light.x >= dayThreshold) {
    isDaytime = true;
} else if (light.x >= duskThreshold && light.x < dayThreshold) {
    isDusk = true;
} else if (light.x >= nightThreshold && light.x < duskThreshold) {
    isNighttime = true;
} else if (light.x < caveThreshold) {
    isInCave = true;
}

if (light.x < caveThreshold) {
    isInCave = true;
    isDaytime = false;
    isDusk = false;
    isNighttime = false;
}

 vec3 raincc = mix(ERAINc, ERAINc+0.553, AFnight);
 vec3 mainCC;
   mainCC = mix(EDAYc-0.15, EDUSKc+0.337, AFdusk);
   mainCC = mix(mainCC, ENIGHTc+0.553, AFnight);
   mainCC = mix(mainCC, raincc, AFrain);
 vec4 Azify;
   Azify.xyz = (mainCC.xyz);

 vec3 v_skypos = (worldPosition.xyz + vec3(0.0, 0.128, 0.0));
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

    vec4 horizon;
    horizon.xyz = albedo4;
    v_light = light;
    v_cpos = a_position;
    v_wpos = worldPosition.xyz;
    v_colors = Azify;
    v_fog = fog; 
    v_skyMie = horizon;
    v_texcoord0 = a_texcoord0;
    gl_Position = position;
}
