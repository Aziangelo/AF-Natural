$input v_color0, v_texcoord0
$input v_skypos

#include <bgfx_shader.sh>
SAMPLER2D_AUTOREG(s_MatTexture);
#include <azify/core.sh>

void main() {
#ifndef OPAQUE
  //Opaque
  vec3 diffuse;
  diffuse = texture2D(s_MatTexture, v_texcoord0).rgb;
  /* Time Detection */
  vec4 wtime = getTime(FogColor);
  bool getUnWater;
  bool getNether;
  getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);

  vec3 viewPos = normalize(v_skypos);
  float minPos = min(viewPos.y, 0.005);
  viewPos.y = max(viewPos.y, 0.0);
  vec3 skyMie = calculateSky(diffuse,viewPos,minPos);
  if (getUnWater) {
  	vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, AFnight);
    diffuse = UnDerWFog;
  } else {
    diffuse = skyMie;
  }

#ifdef AURORA_BOREALIS
  getAurora(diffuse, viewPos, Wtime);
#endif

#ifdef STARS
  getStars(diffuse, viewPos, Wtime);
#endif 

#ifdef CLOUDS
if (!getUnWater) {
  diffuse.rgb = finalClouds(diffuse.rgb, viewPos, wtime);
}
#endif

#ifdef UNDERWATER_RAYS
if (getUnWater) {
float Grand1 = 0.01;
float Grand2 = 0.13;
float noiseValue = noise(vect2(atan2(v_skypos.x, v_skypos.z)) * 9.4);
vec3 baseColor = mix(vect3(1.0) * Grand1, vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
float weight = clamp(length(v_skypos.xz * 0.06), 0.0, 1.0);
vec3 finalColor = mix(vect3(0.0), baseColor, weight);
diffuse += finalColor;
}
#endif

  /* Simple Tone Mapping */
  diffuse = AzifyColors(diffuse);
  /* Vintage Tone Mapping */
  #ifdef VINTAGE_TONE
  diffuse = VintageCinematic(diffuse);
  #endif
  gl_FragColor = vec4(diffuse,1.0);
#else
  //Fallback
  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}