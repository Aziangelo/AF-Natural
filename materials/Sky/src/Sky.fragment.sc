$input v_color0, v_position, v_worldpos, skypos
#if defined(GEOMETRY_PREPASS)
    $input v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>

uniform vec4 SkyColor;
uniform vec4 FogColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;
uniform float RenderDistance;

#include <azifyN/utils/functions.glsl>
#include <azifyN/shader_inputs.glsl>

void main() {
#if defined(OPAQUE)
 bool DevUnWater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);
 mediump vec3 v_skypos = (v_worldpos.xyz + vec3(0.0, 0.128, 0.0));
 mediump vec3 v_viewpos = normalize(v_skypos);
v_viewpos.y = (v_viewpos.y - 0.0128);
 mediump float v_pos = min(v_viewpos.y, 0.005);
v_viewpos.y = max(v_viewpos.y, 0.0);
 mediump vec3 albedo1;
albedo1 = mix(SA_DAY, SA_DUSK, AFdusk);
albedo1 = mix(albedo1, SA_NIGHT, AFnight);
albedo1 = mix(albedo1, SA_RAIN, AFrain);
 mediump vec3 albedo2;
albedo2 = mix(SB_DAY, SB_DUSK, AFdusk);
albedo2 = mix(albedo2, SB_NIGHT, AFnight);
albedo2 = mix(albedo2, SB_RAIN, AFrain);
 mediump vec3 albedo3;
albedo3 = mix(SC_DAY, SC_DUSK, AFdusk);
albedo3 = mix(albedo3, SC_NIGHT, AFnight);
albedo3 = mix(albedo3, SC_RAIN, AFrain);
 mediump vec3 albedo4;
albedo4 = vec3(0.0);
albedo4 += (albedo2 * exp(-v_viewpos.y * 4.0));
albedo4 += (albedo1 * (1.0 - exp(-v_viewpos.y * 10.0)));
albedo4 = mix(albedo4, albedo3, (1.0 - exp(v_pos * 8.0)));
  mediump vec4 albedo0;
  if (DevUnWater) {
    albedo0.xyz = UNDERWATER_FOG;
  } else {
    albedo0.xyz = albedo4;
  }



/*
vec2 aposX = spos.xz / spos.y + ViewPositionAndTime.w * vec2(0.1, 0.06);
vec2 aposZ = spos.xz / spos.y - ViewPositionAndTime.w * vec2(0.1, 0.05);
vec3 col1 = vec3(0.0, 0.8, 0.4);
vec3 col2 = vec3(0.4, 0.2, 0.8);
vec3 acol = mix(col1, col2, smoothstepCustom(0.5, 1.0, amap(aposZ)));
albedo0.rgb += acol * smoothstepCustom(0.5, 1.0, amap(aposX)) * AFnight * clamp(smoothstep(0.9, 2.5, length(-v_viewPos.y * 5.0)), 0.0, 1.0);
*/
vec3 spos = normalize(skypos);

#ifdef AURORA_BOREALIS
vec2 timeOffset = ViewPositionAndTime.w * vec2(0.1, 0.06);
vec2 aposX = spos.xz / spos.y + timeOffset;
vec2 aposZ = spos.xz / spos.y - timeOffset;
vec3 acol = mix(COL1, COL2, smoothstepCustom(0.5, 1.0, amap(aposZ, ViewPositionAndTime.w)));
float smoothstepX = smoothstepCustom(0.5, 1.0, amap(aposX, ViewPositionAndTime.w));
float yFactor = clamp(smoothstep(0.9, 2.5, length(- v_viewpos.y * 5.0)), 0.0, 1.0);
albedo0.rgb += acol * smoothstepX * AFnight * yFactor;
#endif

#ifdef CLOUDS
if (DevUnWater) {
} else {
lowp vec3 clCc;
clCc = mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, AFdusk), CLOUD_NIGHTc, AFnight), CLOUD_RAINc, AFrain);
vec2 scaledPos = (spos.xz / spos.y) * 3.2;
mediump float cloudAlpha = generateCloud(scaledPos, ViewPositionAndTime.w).a;
mediump float smoothStepVal = smoothstep(0.3, 1.5, length(-v_viewpos.y * 5.0));
mediump float mixFactor = cloudAlpha * 0.75 * clamp(smoothStepVal, 0.0, 1.0);
albedo0.rgb = mix(albedo0.rgb, clCc, mixFactor);
}
#endif

    //Opaque
    gl_FragColor = albedo0;
#else
    //Fallback
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

#endif
} 
