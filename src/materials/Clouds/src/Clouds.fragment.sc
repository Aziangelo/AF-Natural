$input v_color0, CubePosition, v_cpos
#if defined(TRANSPARENT)
  $input v_color1, v_color2, v_fogColor
#endif

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
  vec4 albedo0 = v_color0;
#if defined(TRANSPARENT)
vec3 vDir = normalize(v_color0.xyz);
vec3 CRainCol = mix(CLOUD_D_RAINc, CLOUD_N_RAINc, AFnight);
	vec3 SRainCol = mix(SHADOW_D_RAINc, SHADOW_N_RAINc, AFnight);
  vec3 clCc = mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, AFdusk), CLOUD_NIGHTc, AFnight), CRainCol, AFrain);
  vec3 shCc = mix(mix(mix(SHADOW_DAYc, SHADOW_DUSKc, AFdusk), SHADOW_NIGHTc, AFnight), SRainCol, AFrain);
  vec2 scaledPos = (vDir.xz / vDir.y) * 2.5;
  float cloudData = getClouds(scaledPos);
  vec2 clPos = time * 0.15 + scaledPos;
  float cloudNoise = noise(clPos);
  float shadowData = smoothstep(0.3,1.0, cloudNoise);
  float smoothStepVal = clamp(smoothstep(0.5, 1.8, length(-vDir.y * 5.0)),0.0,1.0);
  float mixFactor = cloudData * 0.5 * smoothStepVal;
  albedo0.rgb = mix(albedo0.rgb, clCc, mixFactor);
  albedo0.rgb = mix(albedo0.rgb, shCc, shadowData*smoothStepVal);
  albedo0.a *= v_color0.a;
#endif
   gl_FragColor = vec4(albedo0);
}
