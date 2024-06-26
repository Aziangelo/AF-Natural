$input v_color0, v_fog, v_texcoord0, v_lightmapUV
$input v_worldColors, v_skyMie, v_AO, v_color2, v_color3, v_color4, v_RainFloorReflect
$input v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

SAMPLER2D(s_MatTexture, 0);
SAMPLER2D(s_SeasonsTexture, 1);
SAMPLER2D(s_LightMapTexture, 2);

void main() {
  vec4 diffuse;
  vec4 u_texture =
  texture2DLod(s_MatTexture, v_texcoord0, 0.0);

  #if defined(DEPTH_ONLY_OPAQUE) || defined(DEPTH_ONLY)
  diffuse.rgb = vec3(1.0, 1.0, 1.0);
  #else
  diffuse = texture2D(s_MatTexture, v_texcoord0);
  if (GLOW_PIXEL(u_texture)) {
    diffuse.rgb += vec3(1.0, 1.0, 1.0)+sin(time);
  }

  #if defined(ALPHA_TEST)
  if (diffuse.a < 0.5) {
    discard;
  }
  #endif

  #if defined(SEASONS) && (defined(OPAQUE) || defined(ALPHA_TEST))
  diffuse.rgb *=
  mix(vec3(1.0, 1.0, 1.0),
    texture2D(s_SeasonsTexture, v_color0.xy).rgb * 2.0, v_color0.b);
  diffuse.rgb *= v_color0.aaa;
  #else
  vec3 n_color = normalize(v_color0.rgb);
  bool mix_color = abs(n_color.r - n_color.g) > 0.001 || abs(n_color.g - n_color.b) > 0.001;
  if (mix_color) {
    diffuse = vec4(diffuse.rgb * mix(n_color.rgb, v_color0.rgb, 0.45), v_color0.a);
  }
  #endif
  #endif

  #ifndef TRANSPARENT
  diffuse.a = 1.0;
  #endif

  #if !defined(DEPTH_ONLY_OPAQUE) || !defined(DEPTH_ONLY)
  bool getUnWater;
  bool getNether;
  bool find_UV;
  bool getWaterlusion;
  bool getWaterTex;
  getWorldDetctions(getUnWater, getNether, FogColor, FogAndDistanceControl);
  getWaterTex = v_color0.b > 0.3 && v_color0.a < 0.95;
  find_UV = v_lightmapUV.y < 0.92384 && abs((2.0 * v_cpos.y - 15.0) / 16.0 - v_lightmapUV.y) < 0.00002 && v_lightmapUV.y > 0.187;
  getWaterlusion = false;
  if (find_UV) {
    getWaterlusion = true;
  }

  vec4 uvTexture;
  uvTexture -= texture2D(s_MatTexture, v_texcoord0 + 0.00005 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00019 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  uvTexture -= texture2D(s_MatTexture, v_texcoord0 + 0.00005 + wNORMAL_INTENSITY);
  vec3 integratedMapping = normalize(uvTexture.rgb * 2.0 - 1.0); // Convert texture to fake integrated PBR

  diffuse.rgb *= v_worldColors.rgb;


  diffuse.rgb = mix(diffuse.rgb, FogColor.rgb, v_fog.a);
  #endif /* DEPTH_ONLY_OPAQUE DEPTH_ONLY */
  gl_FragColor = diffuse;
}