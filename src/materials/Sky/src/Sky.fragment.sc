$input v_color0
$input v_skypos
#if defined(GEOMETRY_PREPASS)
    $input v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
#if defined(OPAQUE)
  //Opaque
  vec3 albedo0;
  bool getUnWater;
  bool getNether;
  getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);

  vec3 viewPos = normalize(v_skypos);
  float minPos = min(viewPos.y, 0.005);
  viewPos.y = max(viewPos.y, 0.0);
  vec3 skyMie = calculateSky(albedo0,viewPos,minPos);
  if (getUnWater) {
  	vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, AFnight);
    albedo0 = UnDerWFog;
  } else {
    albedo0 = skyMie;
  }

#ifdef AURORA_BOREALIS
  getAurora(albedo0, viewPos, Wtime);
#endif

#ifdef STARS
getStars(albedo0, viewPos, Wtime);
#endif 

#ifdef CLOUDS
if (!getUnWater) {
	vec3 CRainCol = mix(CLOUD_D_RAINc, CLOUD_N_RAINc, AFnight);
	vec3 SRainCol = mix(SHADOW_D_RAINc, SHADOW_N_RAINc, AFnight);
  vec3 clCc = mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, AFdusk), CLOUD_NIGHTc, AFnight), CRainCol, AFrain);
  vec3 shCc = mix(mix(mix(SHADOW_DAYc, SHADOW_DUSKc, AFdusk), SHADOW_NIGHTc, AFnight), SRainCol, AFrain);
  vec2 scaledPos = (viewPos.xz / viewPos.y) * 2.5;
  float cloudData = getClouds(scaledPos);
  vec2 clPos = time * 0.15 + scaledPos;
  float cloudNoise = noise(clPos);
  float shadowData = smoothstep(0.3,1.0, cloudNoise);
  float smoothStepVal = clamp(smoothstep(0.5, 1.8, length(-viewPos.y * 5.0)),0.0,1.0);
  float mixFactor = cloudData * 0.5 * smoothStepVal;
  albedo0 = mix(albedo0, clCc, mixFactor);
  albedo0 = mix(albedo0, shCc, shadowData*smoothStepVal);
}
#endif

  /* Simple Tone Mapping */
  albedo0 = AzifyColors(albedo0);
  /* Vintage Tone Mapping */
  #ifdef VINTAGE_TONE
  albedo0 = VintageCinematic(albedo0);
  #endif
  gl_FragColor = vec4(albedo0,1.0);
#else
  //Fallback
  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}