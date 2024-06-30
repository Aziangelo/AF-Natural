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
  getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);
  getWaterTex = v_color0.b > 0.3 && v_color0.a < 0.95;
  find_UV = v_lightmapUV.y < 0.92384 && abs((2.0 * v_cpos.y - 15.0) / 16.0 - v_lightmapUV.y) < 0.00002 && v_lightmapUV.y > 0.187;
  getWaterlusion = false;
  if (find_UV) {
    getWaterlusion = true;
  }
  bool getMetals = u_texture.a < 0.88 && u_texture.a > 0.83;
  
  /* Get NormalMapping */
	vec3 integratedMapping;
	getNormals(integratedMapping, s_MatTexture, v_texcoord0, getMetals);

  /* Normal Positions */
  vec3 dx = dFdx(v_cpos);
  vec3 dy = dFdy(v_cpos);
  vec3 dXY = cross(dx,dy);
  vec3 norml = normalize(dXY);
  
  #ifdef NORMALMAPS
  mat3 tbnMatrix = mat3(abs(norml.y) + norml.z, 0.0, norml.x, 0.0, 0.0, norml.y, -norml.x, norml.y, norml.z);
  vec2 interMap = integratedMapping.xy;
  vec3 v3Map = vec3(interMap, sqrt(1.0-dot(interMap, interMap)));
  norml = normalize(mul(v3Map, tbnMatrix));
  #endif
  
  float Suntheta = radians(35.0);
	vec3 lpos = normalize(vec3(cos(Suntheta), sin(Suntheta), 0.0));
	
	vec3 normDir = normalize(v_wpos);
	vec3 viewDir = normalize(-v_wpos);
	vec3 combinedDir = normalize(viewDir + lpos);
	vec3 reflPos = reflect(normalize(v_wpos), norml);
	
	float DLN = max(0.0, dot(norml, lpos));
	float DVN = max(0.0, dot(norml, viewDir));
	float DHN = max(0.001, dot(norml, combinedDir));
	float CPD = clamp(dot(norml, viewDir), 0.0, 1.0);
	vec4 fresnelVector = clamp(vec4(getFresnel(DVN, float3(0.05)), smoothstep(0.5, 0.0, DVN)), 0.0, 1.0);
  
  float powCave = pow(v_lightmapUV.y, 2.0);
  float powLight = pow(v_lightmapUV.x, 3.5);

  /* Main World Coloring */
  diffuse.rgb *= v_worldColors.rgb;
  if (getUnWater) {
  	diffuse.rgb *= 
  	  mix(float3(1.0), vec3(0.7,0.8,0.9), powCave);
  }

  #ifdef AMBIENT_OCCLUSION
  float AOposition = max(abs(norml.x), -norml.y);
  diffuse.rgb *= 
    mix(vec3(1.0,1.0,1.0), v_AO.rgb, AOposition);
  #endif /* AMBIENT_OCCLUSION */

  #ifdef DIRECT_LIGHT
    #ifndef TRANSPARENT
  float absNormX = abs(norml.z);
  float absNormZ = abs(norml.x);
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
	
	vec3 viewPos = clamp(normalize(viewDir),0.0,1.0);
	float minPos = min(viewPos.y, 0.005);
	vec3 skyM = calculateSky(diffuse.rgb, viewPos, minPos);
	diffuse = vec4(mix(diffuse.rgb, skyM, fresnelVector.rgb), mix(diffuse.a*0.1,0.9,fresnelVector.a));
  #endif /* WATER_GRADIENT */
	}
	#endif /* TRANSPARENT */
	
	#ifdef CAUSTICS
  float caustics =
    getVoronoi((v_cpos.xz + v_cpos.y) * 0.6);
  if (getWaterlusion) {
  diffuse.rgb += 
  		max(caustics, 0.0) * 0.6 * diffuse.rgb;
  }
  #endif /* CAUSTICS */

 
  #ifdef BLOCK_REFLECTION
	 #ifndef ALPHA_TEST
	  #ifndef TRANSPARENT
	if (getMetals) {
	float GDist = smoothstep(1.0, 0.2, dot(norml, normalize(-v_wpos)));
	float Grand1 = 0.17;
	float Grand2 = mix(2.51, 2.0, AFnight);
	vec3 reflectVec = reflect(normalize(v_wpos), norml);
	float noiseValue = noise(vec2(atan2(v_wpos.x, v_wpos.z), atan2(v_wpos.x, v_wpos.z)) * 9.4);
	vec3 baseColor = mix(float3(1.0) * Grand1, vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
	float weight = clamp(length(v_wpos.xz * 0.06), 0.0, 1.0);
	vec3 finalColor = GDist * mix(float3(0.0), baseColor, weight * clamp(reflectVec.y, 0.0, 1.0)) * v_lightmapUV.y;
	
	diffuse.rgb += finalColor;
	}
	  #endif
	 #endif
	#endif

  /* Rain Floor Reflection */
	#ifdef FLOOR_REFLECTION
	 #ifndef ALPHA_TEST
	  #ifndef TRANSPARENT
	    if (!getUnWater) {
	    diffuse.rgb = mix(diffuse.rgb, v_RainFloorReflect.rgb, max(0.0,norml.y) * v_RainFloorReflect.a);
	    }
	  #endif
	 #endif
	#endif

  #ifdef FOG
  if (getUnWater) {
  	vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, AFnight);
    diffuse.rgb = mix(diffuse.rgb, UnDerWFog, v_fog.a);
  } else if (getNether) {
  } else {
    diffuse.rgb = mix(diffuse.rgb, v_skyMie.rgb, v_fog.a);
  }
  #endif /* FOG */
  #endif /* DEPTH_ONLY_OPAQUE DEPTH_ONLY */
  /* Simple Tone Mapping */
  diffuse.rgb = AzifyColors(diffuse.rgb);
  /* Vintage Tonemap */
  #ifdef VINTAGE_TONE
  diffuse.rgb = VintageCinematic(diffuse.rgb);
  #endif
  gl_FragColor = diffuse;
}