$input v_color0, v_fog, v_texcoord0, v_lightmapUV
$input v_worldColors, v_skyMie, v_AO, v_color2, v_color3, v_color4, v_RainFloorReflect
$input v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

SAMPLER2D_AUTOREG(s_MatTexture);
SAMPLER2D_AUTOREG(s_SeasonsTexture);
SAMPLER2D_AUTOREG(s_LightMapTexture);

void main() {
  vec4 diffuse;
  /* Time Detection */
  vec4 wtime = getTime(FogColor);
  /* Textures */
  vec4
  gtex = texture2DLod(s_MatTexture, v_texcoord0, 0.0),
  ntex = texture2D(s_MatTexture, v_texcoord0);

  /* Detections */
  bool getUnWater, getNether, getWaterlusion, getWaterTex,
  getMetals = METAL_PIXEL(ntex);
  getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);
  #if !defined(DEPTH_ONLY_OPAQUE) || !defined(DEPTH_ONLY)
  getWaterTex = v_color0.b > 0.3 && v_color0.a < 0.95;
  #endif /* DEPTH_ONLY_OPAQUE DEPTH_ONLY */
  // water occlusion 
  getWaterlusion = false;
  if (v_lightmapUV.y < 0.92384 && abs((2.0 * v_cpos.y - 15.0) / 16.0 - v_lightmapUV.y) < 0.00002 && v_lightmapUV.y > 0.187) {
    getWaterlusion = true;
  }
  // cave and light
  float 
  powCave = pw2x(v_lightmapUV.y), 
  powLight = pw3x(v_lightmapUV.x);

  #if defined(DEPTH_ONLY_OPAQUE) || defined(DEPTH_ONLY)
  diffuse.rgb = vect3(1.0);
  #else
  diffuse = texture2D(s_MatTexture, v_texcoord0);
  if (GLOW_PIXEL(gtex)) {
    diffuse.rgb *= vect3(GLOW_BRIGHTNESS);
  }

  #if defined(ALPHA_TEST)
  if (diffuse.a < 0.5) {
    discard;
  }
  #endif

  #if defined(SEASONS) && (defined(OPAQUE) || defined(ALPHA_TEST))
  diffuse.rgb *= mix(vect3(1.0), texture2D(s_SeasonsTexture, v_color0.xy).rgb * 2.0, v_color0.b);
  diffuse.rgb *= v_color0.aaa;
  #else
  float 
  mincol = min(v_color0.r, v_color0.b),
  ncolor = inv(v_color0.g * 1.0-mincol) * 2.4,
  ao = str(ncolor * 0.9);
  // ao from: clover shader
  vec3 
  newcolor = normalize(v_color0.rgb);
  newcolor /= mix(vect3(1.0),newcolor,(lights(newcolor)>0.575)?1.0:0.0);
  diffuse.rgb *= newcolor;
  diffuse.rgb *= mix(mix(vect3(1.0),
        vect3(0.6),ao),
        vect3(0.75),pw3x(v_lightmapUV.x));
  #endif
  #endif

  #ifndef TRANSPARENT
  diffuse.a = 1.0;
  #endif

  /* Get NormalMapping */
  vec3 integratedMapping = getNormals(s_MatTexture, v_texcoord0, getMetals, getWaterTex);

  /* Normal Positions */
  vec3 dx = normalize(dFdx(v_wpos));
  vec3 dy = normalize(dFdy(v_wpos));
  vec3 dXY = cross(dx, dy);
  vec3 norml = normalize(dXY);

  #ifdef NORMALMAPS
  //if (getMetals) {
  mat3 tbnMatrix = mat3(abs(norml.y) + norml.z, 0.0, norml.x, 0.0, 0.0, norml.y, -norml.x, norml.y, norml.z);
  
  vec2 interMap = integratedMapping.xy;
  vec3 vect3Map = vec3(interMap, sqrt(inv(dot(interMap, interMap))));
  norml = normalize(mul(vect3Map, tbnMatrix));
 // } else if (getWaterTex) {
  
 // }
  #endif

  float Suntheta = radians(45.0);
  vec3 lpos = normalize(vec3(cos(Suntheta), sin(Suntheta), 0.0));

  vec3 normDir = normalize(v_wpos);
  vec3 viewDir = normalize(-v_wpos);
  vec3 combinedDir = normalize(viewDir + lpos);
  vec3 reflPos = reflect(normalize(v_wpos), norml);

  float DVN = max(0.001, dot(norml, viewDir));
  float DHN = str(dot(norml, combinedDir));
  vec4 fresnelVector = str(vec4(getFresnel(DVN, vect3(0.05)), smoothstep(0.5, 0.0, DVN)));

  /* Main World Coloring */
  if (!(GLOW_PIXEL(gtex))) {
  if (getUnWater) {
    diffuse.rgb *= mix(UNWATERc+0.15, UNWATERc, inv(powCave));
  } else {
    diffuse.rgb *= v_worldColors.rgb;
  }
  } // GLOW_PIXEL


  #ifdef AMBIENT_OCCLUSION
  float AOposition = max(abs(norml.x), -norml.y);
  diffuse.rgb *=
  mix(vect3(1.0), v_AO.rgb, AOposition);
  #endif // AMBIENT_OCCLUSION


  #ifdef DIRECT_LIGHT
  vec3 DirSh = mix(mDS_DAYc, mDS_NIGHTc, wtime.z);
  DirSh = mix(DirSh, mDS_DUSKc, wtime.y);
  DirSh = mix(DirSh, mDS_RAINc, wtime.w);
  DirSh = mix(DirSh, NETHERc-0.3, float(getNether));
  vec3 DirHi = mix(mDL_DAYc, mDL_NIGHTc, wtime.z);
  DirHi = mix(DirHi, mDL_DUSKc, wtime.y);
  DirHi = mix(DirHi, mDL_RAINc, wtime.w);
  //#if !defined(TRANSPARENT) && !defined(ALPHA_TEST)
  float 
  SHposition = str(max(0.0,max(0.0,mix(-norml.x,norml.x,max(wtime.y,wtime.z)))+max(norml.z,-norml.z)+-norml.y)),
  DHposition = str(max(mix(norml.x,-norml.x,max(wtime.y,wtime.z)),norml.y));

  vec3 
  getDSpos = mix(vect3(1.0), DirSh, powCave * SHposition),
  getDHpos = mix(vect3(1.0), DirHi, powCave * DHposition),
  getDirectLight = mix(vect3(1.0), (getDSpos * getDHpos), inv(powLight));

  if (GLOW_PIXEL(gtex)) {} else {
    diffuse.rgb *= getDirectLight;
  }
  //#endif // ALPHA_TEST, TRANSPARENT
  #if defined(ALPHA_TEST)
  //diffuse.rgb *= mix(vect3(1.0),DirHi,max(0.0,abs(norml.x))*powCave*inv(powLight));
  #endif // ALPHA_TEST
  #endif // DIRECT_LIGHT


  #ifdef TRANSPARENT
  if (getWaterTex) {
    // WATER LINES ======>
    #ifdef WATER_LINES
    if (texture2D(s_MatTexture, v_texcoord0).b > WATERLINE_INTENSITY) {
      vec3 wlc = mix(wLINE_DAYc, wLINE_NIGHTc, wtime.z);
      wlc = mix(vect3(0.0), wlc, v_lightmapUV.y);
      diffuse.a = WATERLINE_OPACITY;
      diffuse += vec4(wlc, 1.0);
    }
    #endif /* WATER_LINES */
    #ifdef WATER_GRADIENT
    vec3 viewPos = str(normalize(viewDir));
    float minPos = min(viewPos.y, 0.005);
    vec3 skyM = calculateSky(diffuse.rgb, viewPos, minPos);
    diffuse = vec4(mix(diffuse.rgb, skyM, fresnelVector.rgb), mix(diffuse.a*0.1, 0.9, fresnelVector.a));
    #endif /* WATER_GRADIENT */
    #ifdef WATER_SUN_REFL
    diffuse = mix(diffuse, vec4(1.0, 0.8, 0.5, 1.0), (smoothstep(0.995, 1.0,DHN)) * 1.5 * powCave);
    #endif // WATER_SUN_REFL
  } // getWaterTex
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
  diffuse = mix(diffuse, vec4(1.0, 0.8, 0.5, 1.0), pow(DHN, 95.0) * powCave);
  }
  #endif
  #endif
  #endif



  /* Rain Floor Reflection */
  #ifdef FLOOR_REFLECTION
  #ifndef ALPHA_TEST
  #ifndef TRANSPARENT
  if (!getUnWater) {
    diffuse.rgb = mix(diffuse.rgb, v_RainFloorReflect.rgb, max(0.0, norml.y) * v_RainFloorReflect.a);
  }
  #endif
  #endif
  #endif

  #ifdef FOG
  if (getUnWater) {
    vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, wtime.z);
    diffuse.rgb = mix(diffuse.rgb, UnDerWFog, v_fog.a);
  } else if (getNether) {} else {
    diffuse.rgb = mix(diffuse.rgb, v_skyMie.rgb, v_fog.a);
  }
  #endif /* FOG */

  #ifdef UNDERWATER_RAYS
  if (getUnWater) {
    float Grand1 = 0.01;
    float Grand2 = 0.13;
    float noiseValue = noise(vect2(atan2(v_wpos.x, v_wpos.z)) * 9.4);
    vec3 baseColor = mix(vect3(1.0) * Grand1, vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
    float weight = str(length(v_wpos.xz * 0.06));
    vec3 finalColor = mix(vect3(0.0), baseColor, weight);
    diffuse.rgb += finalColor;
  }
  #endif

  /* Tone Mapping Enabled */
  diffuse.rgb = AzifyColors(diffuse.rgb);
  gl_FragColor = diffuse;
}