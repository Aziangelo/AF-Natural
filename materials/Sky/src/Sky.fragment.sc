$input v_color0
$input v_skypos, v_viewPos, v_minPos
#if defined(GEOMETRY_PREPASS)
    $input v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>

uniform vec4 SkyColor;
uniform vec4 FogColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;
uniform float RenderDistance;

#include <azify/shader_inputs.glsl>
#include <azify/utils/time.glsl>
#include <azify/utils/functions.glsl>
#include <azify/utils/sky.glsl>
#include <azify/utils/clouds.glsl>

void main() {
#if defined(OPAQUE)
 vec4 albedo0;
 bool DevUnWater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);

  vec3 viewPos = normalize(v_skypos);
  viewPos.y = (viewPos.y - 0.0128);
  float minPos = min(viewPos.y, 0.005);
  viewPos.y = max(viewPos.y, 0.0);
  vec3 skyMie = calculateSky(albedo0.rgb,viewPos,minPos);
  if (DevUnWater) {
  albedo0.rgb = UNDERWATER_FOG;
  } else {
  albedo0.rgb = skyMie;
  }

#ifdef AURORA_BOREALIS
vec2 timeOffset = ViewPositionAndTime.w * vec2(0.1, 0.06);
vec2 aposX = viewPos.xz / viewPos.y + timeOffset;
vec2 aposZ = viewPos.xz / viewPos.y - timeOffset;
vec3 acol = mix(COL1, COL2, smoothstep(0.5, 1.0, amap(aposZ, ViewPositionAndTime.w)));
float smoothedPos = smoothstep(0.5, 1.0, amap(aposX, ViewPositionAndTime.w));
float yFactor = clamp(smoothstep(0.9, 2.5, length(- viewPos.y * 5.0)), 0.0, 1.0);
albedo0.rgb += acol * smoothedPos * AFnight * yFactor;
#endif

#ifdef CLOUDS
if (DevUnWater) {
} else {
  vec3 clCc = mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, AFdusk), CLOUD_NIGHTc, AFnight), CLOUD_RAINc, AFrain);
  vec2 scaledPos = (viewPos.xz / viewPos.y) * 3.0;
  float cloudAlpha = generateCloud(scaledPos, ViewPositionAndTime.w, 2); 
  float smoothStepVal = smoothstep(0.5, 1.8, length(-viewPos.y * 5.0));
  float mixFactor = cloudAlpha * 0.4 * clamp(smoothStepVal, 0.0, 1.0);
  albedo0.rgb = mix(albedo0.rgb, clCc, mixFactor);
}
#endif

    //Opaque
    albedo0.rgb = AzifyFN(albedo0.rgb);
    gl_FragColor = albedo0;
#else
    //Fallback
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

#endif
} 
