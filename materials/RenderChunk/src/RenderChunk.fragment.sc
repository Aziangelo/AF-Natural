$input v_color0, v_fog, v_texcoord0, v_lightmapUV, v_colors, v_skyMie, v_cpos, v_wpos, v_color1

#include <bgfx_shader.sh>

uniform vec4 FogColor;
uniform float RenderDistance;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;

SAMPLER2D(s_MatTexture, 0);
SAMPLER2D(s_SeasonsTexture, 1);
SAMPLER2D(s_LightMapTexture, 2);

#include <azify/utils/functions.glsl>
#include <azify/shader_inputs.glsl>

void main() {
    vec4 diffuse;

#if defined(DEPTH_ONLY_OPAQUE) || defined(DEPTH_ONLY)
    diffuse.rgb = vec3(1.0, 1.0, 1.0);
#else
    diffuse = texture2D(s_MatTexture, v_texcoord0);
    lowp vec4 Gtex = texture2DLod(s_MatTexture, v_texcoord0, 0.0);
    if (((Gtex.a > 0.03) && (Gtex.a < 0.06))) {
    diffuse.rgb *= max (diffuse.rgb, ((1.34 * (0.06 - Gtex.w) ) / 0.007499993));
    }

#if defined(ALPHA_TEST)
    if (diffuse.a < 0.5) {
        discard;
    }
#endif

#if defined(SEASONS) && (defined(OPAQUE) || defined(ALPHA_TEST))
    diffuse.rgb *= mix(vec3(1.0, 1.0, 1.0),texture2D(s_SeasonsTexture, v_color0.xy).rgb * 2.0, v_color0.b);
    diffuse.rgb *= v_color0.aaa;
#else
    vec3 ncol_0 = normalize(v_color0.rgb);
        if(abs(ncol_0.r - ncol_0.g) > 0.001 || abs(ncol_0.g - ncol_0.b) > 0.001) {
        diffuse = vec4(diffuse.rgb * mix(ncol_0.rgb, v_color0.rgb, 0.45), v_color0.a);
    }
#endif
#endif

#ifndef TRANSPARENT
    diffuse.a = 1.0;
#endif

lowp float waterFlag = 0.0;
#ifdef TRANSPARENT
    if (v_color1.r != v_color1.g || v_color1.g != v_color1.b || v_color1.r != v_color1.b) {
        waterFlag = 1.0;
    }
#endif

bool DevUnWater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);

// World Color
diffuse.rgb *= v_colors.xyz;



vec3 norml = normalize(cross(dFdx(v_cpos), dFdy(v_cpos)));
mediump float disableinCve = pow(v_lightmapUV.y, 2.0);
mediump vec3 skyfog = v_skyMie.rgb;
lowp vec4 Mtex = texture2DLod(s_MatTexture, v_texcoord0, 0.0);
bool DetectGlass = Mtex.a < 0.935 && Mtex.a > 0.0;


#ifdef SUPER_AO
 #ifndef ALPHA_TEST
// AO Remake
mediump float vanillaAO = (1.0 - (v_color0.y * 2.0 - (v_color0.x < v_color0.z ? v_color0.x : v_color0.z)) * 1.4);
mediump float fakeAO = clamp(1.0 - (vanillaAO * 0.5), 0.0, 1.0);
//lowp float occlShadow1 = mix(1.0, 0.55, vanillaAO);
diffuse.rgb *= mix(vec3(1.0), vec3(0.25), (1.0-fakeAO));
 #endif
#endif

// Fake Directional Light
#ifdef DIRECT_LIGHT
  #ifndef TRANSPARENT
mediump vec3 dirlitCC;
float dp1 = max(abs(norml.z), -norml.y);
float dp2 = abs(norml.x);
// Shadows
mediump vec3 ccmix1 = mix(mDS_DAYc, mDS_NIGHTc, AFnight);
ccmix1 = mix(ccmix1, mDS_DUSKc, AFdusk);
ccmix1 = mix(ccmix1, mDS_RAINc, AFrain);
// Highlights
mediump vec3 ccmix2 = mix(mDL_DAYc, mDL_NIGHTc, AFnight);
ccmix2 = mix(ccmix2, mDL_DUSKc, AFdusk);
ccmix2 = mix(ccmix2, mDL_RAINc, AFrain);

mediump vec3 colorFactor1 = mix(vec3(1.0), ccmix1, disableinCve * dp1);
mediump vec3 colorFactor2 = mix(vec3(1.0), ccmix2, disableinCve * dp2);

dirlitCC = mix(vec3(1.0),(colorFactor1 * colorFactor2),(1.0-pow(v_lightmapUV.x,3.5)));
diffuse.rgb *= dirlitCC;
  #endif
#endif

// Water Functions
#if defined(TRANSPARENT)
  if (waterFlag > 0.5) {
// Fake NormalMap
lowp vec4 Line;
#ifdef WATER_NORMALS
  Line -= texture2D(s_MatTexture, v_texcoord0+0.00005+wNORMAL_INTENSITY);
  Line += texture2D(s_MatTexture, v_texcoord0+0.00017+wNORMAL_INTENSITY);
  Line += texture2D(s_MatTexture, v_texcoord0+0.00019+wNORMAL_INTENSITY);
  Line += texture2D(s_MatTexture, v_texcoord0+0.00017+wNORMAL_INTENSITY);
  Line -= texture2D(s_MatTexture, v_texcoord0+0.00005+wNORMAL_INTENSITY);
#else
  Line = diffuse;
#endif

// Water Gradient
#ifdef WATER_GRADIENT
mediump vec3 y_pos = normalize(-v_wpos.xyz);
mediump float fnel = (smoothstep(0.5, 0.0, y_pos.y) * (0.7 * v_lightmapUV.y));
mediump vec3 sky1 = v_skyMie.rgb;
  diffuse = vec4(mix(diffuse.rgb, sky1, fnel), mix(diffuse.a * WATER_OPACITY, WATERGRAD_OPACITY,  smoothstep(WATERGRAD_SMOOTHNESS, 0.0, max(0.001, dot(norml, y_pos)))));
#endif
//  diffuse.rgb *= Line.rgb;

// Water Lines
#ifdef WATER_LINES
if (Line.b > WATERLINE_INTENSITY) {
mediump vec3 wlc = mix(wLINE_DAYc,wLINE_NIGHTc,AFnight);
     wlc = mix(vec3(0.0),wlc,v_lightmapUV.y);
     diffuse += vec4(wlc, diffuse.a * WATERLINE_OPACITY);
  }
#endif
}
#endif


/*
vec2 uv = v_wpos.xz/ v_wpos.y;
float time = ViewPositionAndTime.w * .5+23.0;
vec2 p = mod(uv*TAU, TAU)-250.0;
vec2 i = vec2(p);
	float c = 1.0;
	float inten = .005;
	for (int n = 0; n < MAX_ITER; n++) 
	{
		float t = time * (1.0 - (3.5 / float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
	}
	c /= float(MAX_ITER);
	c = 1.17-pow(c, 1.4);
	vec3 colour = vec3(pow(abs(c), 8.0));
    colour = clamp(colour + vec3(0.0, 0.35, 0.5), 0.0, 1.0);
    diffuse.rgb *= colour;
*/

#ifdef CAUSTICS
mediump float caustics = voro2D((v_cpos.xz + v_cpos.y) * 0.4, ViewPositionAndTime.w);
if (DevUnWater) {
diffuse.rgb += max(caustics, 0.0) * 0.85 * diffuse.rgb;
}
#endif


// Block Reflections
#ifdef BLOCK_REFLECTION
 #ifndef ALPHA_TEST
  #ifndef TRANSPARENT
if (Mtex.a < 0.88 && Mtex.a > 0.83) {
mediump float GDist = smoothstep(1.0, 0.2, dot(norml, normalize(-v_wpos)));
float Grand1 = 0.17;
float Grand2 = mix(2.51, 2.0, AFnight);
mediump vec3 reflectVec = reflect(normalize(v_wpos), norml);
float noiseValue = noise(vec2(atan(v_wpos.x, v_wpos.z)) * 9.4);
mediump vec3 baseColor = mix(vec3(1.0) * Grand1, vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
mediump float weight = clamp(length(v_wpos.xz * 0.06), 0.0, 1.0);
mediump vec3 finalColor = GDist * mix(vec3(0), baseColor, weight * clamp(reflectVec.y, 0.0, 1.0)) * v_lightmapUV.y;

diffuse.rgb += finalColor;
}
  #endif
 #endif
#endif


// Tone-Mapping
  diffuse.rgb = AzifyFN(diffuse.rgb);
#ifdef FLOOR_REFLECTION
 #ifndef ALPHA_TEST
  #ifndef TRANSPARENT
  if (norml.y > 0.1) {
    lowp vec3 a_pos = normalize(-v_wpos.xyz);
    lowp float smtr1 = smoothstep(0.5, 0.0, a_pos.y);
    lowp float fogDist = mix(0.0, mix(0.0, 0.7, smtr1), AFrain * v_lightmapUV.y);
    diffuse.rgb = mix(diffuse.rgb, skyfog, fogDist);
  }
  #endif
 #endif
#endif
// Fog Remake
#ifdef FOG
  if (DevUnWater) {
    diffuse.rgb = mix(diffuse.rgb, UNDERWATER_FOG, v_fog.a);
  } else {
    diffuse.rgb = mix(diffuse.rgb, skyfog, v_fog.a);
  }
#endif
  gl_FragColor = diffuse;
}