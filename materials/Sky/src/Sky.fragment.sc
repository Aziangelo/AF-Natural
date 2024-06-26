$input v_color0
$input v_skypos, v_viewPos, v_minPos
#if defined(GEOMETRY_PREPASS)
    $input v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
#if defined(OPAQUE)
    //Opaque
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
  getAurora(albedo0.rgb, viewPos, Wtime);
#endif

#ifdef STARS
getStars(albedo0.rgb, viewPos, Wtime);
#endif 

#ifdef CLOUDS
if (DevUnWater) {
} else {
  vec3 clCc = mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, AFdusk), CLOUD_NIGHTc, AFnight), CLOUD_RAINc, AFrain);
  vec3 shCc = mix(mix(mix(SHADOW_DAYc, SHADOW_DUSKc, AFdusk), SHADOW_NIGHTc, AFnight), SHADOW_RAINc, AFrain);
  vec2 scaledPos = (viewPos.xz / viewPos.y) * 2.5;
  float cloudData = getClouds(scaledPos);
  vec2 clPos = time * 0.15 + scaledPos;
  float cloudNoise = noise(clPos);
  float shadowData = smoothstep(0.3,1.0, cloudNoise);
  float smoothStepVal = clamp(smoothstep(0.5, 1.8, length(-viewPos.y * 5.0)),0.0,1.0);
  float mixFactor = cloudData * 0.5 * smoothStepVal;
  albedo0.rgb = mix(albedo0.rgb, clCc, mixFactor);
  albedo0.rgb = mix(albedo0.rgb, shCc, shadowData*smoothStepVal);
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