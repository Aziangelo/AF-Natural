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

  /*
  vec4 uvTexture;
  uvTexture -= texture2D(s_MatTexture, v_texcoord0 + 0.00005 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00019 + wNORMAL_INTENSITY);
  uvTexture += texture2D(s_MatTexture, v_texcoord0 + 0.00017 + wNORMAL_INTENSITY);
  uvTexture -= texture2D(s_MatTexture, v_texcoord0 + 0.00005 + wNORMAL_INTENSITY);*/
  /*
  float uvTexture1;
  float uvTexture2;
  float baseTex;
  vec2 texCoords = vec2(0.0001,0.0);
  baseTex = grayscale(texture2D(s_MatTexture, v_texcoord0+texCoords.yy).rgb);
  uvTexture1 = grayscale(texture2D(s_MatTexture, v_texcoord0+texCoords.xy).rgb);
  uvTexture2 = grayscale(texture2D(s_MatTexture, v_texcoord0+texCoords.yx).rgb);
  float uvX = (baseTex - uvTexture1) * 5.0;
  float uvY = (baseTex - uvTexture2) * 5.0;
  vec3 integratedMapping = normalize(vec3(uvX,uvY,1.0)); // Convert texture to implement an Integrated PBR*/
  vec3 offset = vec3(0.0001, 0.0, 0.00015);
	vec3 color1 = texture2D(s_MatTexture, v_texcoord0 + offset.yy).rgb;
	vec3 color2 = texture2D(s_MatTexture, v_texcoord0 + offset.xx).rgb;
	vec3 color3 = texture2D(s_MatTexture, v_texcoord0 + offset.xy).rgb;
	//vec3 color4 = texture2D(s_MatTexture, v_texcoord0 + offset.yx).rgb;
	float intensity1 = dot(color1, vec3(0.299, 0.587, 0.114));
	float intensity2 = dot(color2, vec3(0.299, 0.587, 0.114));
	float intensity3 = dot(color3, vec3(0.299, 0.587, 0.114));
	//float intensity4 = dot(color4, vec3(0.299, 0.587, 0.114));
	float PBRS = 5.0;
	float diff1 = (intensity1 - intensity2) * PBRS;
	float diff2 = (intensity1 - intensity3) * PBRS;
	//float diff3 = (intensity1 - intensity4) * 1.0;
	vec3 integratedMapping = normalize(vec3(diff1, diff2, 1.));

  /* Normal Positions */
  vec3 dx = dFdx(v_cpos);
  vec3 dy = dFdy(v_cpos);
  vec3 dXY = cross(dx,dy);
  vec3 norml = normalize(dXY);
  mat3 tbnMatrix = mat3(abs(norml.y) + norml.z, 0.0, norml.x, 0.0, 0.0, norml.y, -norml.x, norml.y, norml.z);
  norml.xy = integratedMapping.xy;
  norml.z = sqrt(1.0-dot(norml.xy, norml.xy));
  norml = normalize(norml * tbnMatrix);
  
  float sunAngle = radians(35.0);
  vec3 lpos = normalize(vec3(cos(sunAngle), sin(sunAngle), 0.0));

  vec3 wnpos = normalize(v_wpos), 
  vdir = normalize(-v_wpos), 
  hdir = normalize(vdir+lpos), 
  refVec = reflect(normalize(v_wpos), norml);

  float NoL = max(0.0,dot(norml, lpos));
  float NoV = max(0.0, dot(norml, vdir));
  float NoH = max(.001, dot(norml, hdir));
  float ndotv = clamp(dot(norml, vdir),0.0,1.0);
  vec4 fresnel = clamp(vec4(getFresnel(NoV, vec3(0.05)), smoothstep(.5, 0., NoV)),0.,1.);
  
  float powCave = pow(v_lightmapUV.y, 2.0);
  float powLight = pow(v_lightmapUV.x, 3.5);

  /* Main World Coloring */
  diffuse.rgb *= v_worldColors.rgb;

  #ifdef AMBIENT_OCCLUSION
  float AOposition = max(abs(norml.x), -norml.y);
  diffuse.rgb *= 
    mix(vec3(1.0,1.0,1.0), v_AO.rgb, AOposition);
  #endif /* AMBIENT_OCCLUSION */

  #ifdef DIRECT_LIGHT
    #ifndef TRANSPARENT
  float absNormX = abs(norml.x);
  float absNormZ = abs(norml.z);
  float SHposition = max(absNormX, -norml.y);
  float DHposition = absNormZ;
  
  vec3 DirSh = mix(mDS_DAYc, mDS_NIGHTc, AFnight);
  DirSh = mix(DirSh, mDS_DUSKc, AFdusk);
  DirSh = mix(DirSh, mDS_RAINc, AFrain);
  vec3 DirHi = mix(mDL_DAYc, mDL_NIGHTc, AFnight);
  DirHi = mix(DirHi, mDL_DUSKc, AFdusk);
  DirHi = mix(DirHi, mDL_RAINc, AFrain);
  
  vec3 getDSpos = mix(vec3(1.0,1.0,1.0), DirSh, powCave * SHposition);
  vec3 getDHpos = mix(vec3(1.0,1.0,1.0), DirHi, powCave * DHposition);
  vec3 getDirectLight = mix(vec3(1.0,1.0,1.0), (getDSpos * getDHpos), 1.0 - powLight);
  
  diffuse.rgb *= getDirectLight;
    #endif
  #endif /* DIRECT_LIGHT */
  
  
	#ifdef TRANSPARENT
	if (getWaterTex) {
	// WATER LINES ======>
	#ifdef WATER_LINES
	if (texture2D(s_MatTexture,v_texcoord0).b > WATERLINE_INTENSITY) {
	   vec3 wlc = mix(wLINE_DAYc,wLINE_NIGHTc,AFnight);
	   wlc = mix(vec3(0.0,0.0,0.0),wlc,v_lightmapUV.y);
	   diffuse.a = WATERLINE_OPACITY;
	   diffuse += vec4(wlc, 1.0);
	}
	#endif /* WATER_LINES */
	#ifdef WATER_GRADIENT
	
	vec3 viewPos = clamp(normalize(vdir),0.,1.);
	float minPos = min(viewPos.y, 0.005);
	vec3 skyM = calculateSky(diffuse.rgb, viewPos, minPos);
	diffuse = vec4(mix(diffuse.rgb, skyM, fresnel.rgb), mix(diffuse.a*0.1,0.9,fresnel.a));
	/*
	vec3 y_pos = normalize(-v_wpos.xyz);
  float fnel = (smoothstep(0.5, 0.0, y_pos.y) * (0.7 * v_lightmapUV.y));
  diffuse = vec4(mix(diffuse.rgb, v_skyMie.rgb, fnel), mix(diffuse.a * WATER_OPACITY, WATERGRAD_OPACITY,  smoothstep(WATERGRAD_SMOOTHNESS, 0.0, max(0.001, dot(norml, y_pos)))));*/
  #endif /* WATER_GRADIENT */
	}
	#endif /* TRANSPARENT */

  diffuse.rgb = mix(diffuse.rgb, v_skyMie.rgb, v_fog.a);
  #endif /* DEPTH_ONLY_OPAQUE DEPTH_ONLY */
  /* Color Tone Mapping */
  diffuse.rgb = AzifyFN(diffuse.rgb);
  gl_FragColor = diffuse;
}