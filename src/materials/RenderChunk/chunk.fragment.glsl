$input v_color0, v_fog, v_texcoord0, v_lightmapUV, v_worldColors, v_skyMie, v_ao, v_color2, v_color3, v_color4, v_nfog, v_newcolor, v_dhcol, v_dscol, v_cpos, v_wpos
$input v_wlus, v_unwater, v_nether, v_water, v_wtime, v_ocave

#include <bgfx_shader.sh>
#include <azify/core.sh>

SAMPLER2D_AUTOREG(s_MatTexture);
SAMPLER2D_AUTOREG(s_SeasonsTexture);
SAMPLER2D_AUTOREG(s_LightMapTexture);

void main() {
	// Textures
	vec4 diffuse;
	vec4 gtex;
	vec4 ntex; 
	
	// cave and light
	float powCave = pw2x(v_lightmapUV.y);
	float powLight = pw3x(v_lightmapUV.x);

	#if defined(DEPTH_ONLY_OPAQUE) || defined(DEPTH_ONLY)
	diffuse.rgb = vect3(1.0);
	#else
	diffuse = texture2DLod(s_MatTexture, v_texcoord0, 5.0);
	gtex = texture2DLod(s_MatTexture, v_texcoord0, 0.0);
	ntex = texture2D(s_MatTexture, v_texcoord0);
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
	// ao from: clover shader
	diffuse.rgb *= v_newcolor;

	#ifdef AMBIENT_OCCLUSION
	diffuse.rgb *= mix(vect3(1.0), v_ao.rgb, v_ao.a);
	#endif
	#endif
	#endif

	#ifndef TRANSPARENT
	diffuse.a = 1.0;
	#endif

	// Get NormalMapping 
	vec3 integratedMapping = getNormals(s_MatTexture, v_texcoord0,METAL_PIXEL(gtex), v_water);

	// Normal Positions
	vec3 dx = normalize(dFdx(v_cpos));
	vec3 dy = normalize(dFdy(v_cpos));
	vec3 norml = normalize(cross(dx, dy));
	vec3 norml2 = normalize(cross(dx, dy));

	#ifndef ALPHA_TEST
	#ifdef NORMALMAPS
	if (METAL_PIXEL(gtex)) {
		mat3 tbnMatrix = mat3(abs(norml.y) + norml.z, 0.0, norml.x, 0.0, 0.0, norml.y, -norml.x, norml.y, norml.z);

		vec2 interMap = integratedMapping.xy;
		vec3 vect3Map = vec3(interMap, sqrt(inv(dot(interMap, interMap))));
		norml = normalize(mul(vect3Map, tbnMatrix));
	} else if(v_water > 0.0) {
		vec3 mao = texture2D(s_MatTexture, v_texcoord0).rgb;
		norml = normalize(vec3(mao.rb, mao.g)*2.0-1.0);
	}
	#endif
	#endif

	float Suntheta = radians(45.0);
	vec3 lpos = normalize(vec3(cos(Suntheta), sin(Suntheta), 0.0));
	vec3 eyepos = normalize(-v_wpos);
	vec3 nwpos = normalize(vec3(v_wpos.xz,v_wpos.y).xzy);
	vec3 H = normalize(lpos + eyepos);
	float df = max(0.0, dot(norml, eyepos));
	float sdf = max(0.0, dot(norml, H));
	sdf = pow(sdf, 995.0);
	vec4 fvector = str(vec4(getFresnel(df, vect3(0.05)), smoothstep(0.5, 0.0, df)));
	vec3 ldir = getldir(v_wtime, norml);

	// Main World Coloring 
	if (!(GLOW_PIXEL(gtex))) {
			diffuse.rgb *= mix(v_worldColors.rgb, UNWATERc, v_unwater);

	// direct light & shadow
	float p2 = max(v_ocave, ldir.y);
	diffuse.rgb *= mix(vect3(1.0), v_dscol, p2);

	// direct lights
	#ifdef DIRECT_LIGHT
	vec3 dirlight = mix(vect3(1.0), v_dhcol, ldir.x);
		diffuse.rgb *= dirlight;
	#endif
	}


	#ifdef TRANSPARENT
	if (v_water > 0.0) {
		#ifdef WATER_GRADIENT
			diffuse = vec4(mix(diffuse.rgb, mix(v_skyMie, v_skyMie*0.6, powCave), fvector.rgb), mix(diffuse.a*0.2, 0.9, fvector.a));
		#endif /* WATER_GRADIENT */
		#ifdef WATER_SUN_REFL
			diffuse += (vec4(1.0,0.5,0.0,1.0)+0.5) * sdf * powCave;
		#endif // WATER_SUN_REFL
	} // watertex
	#endif // TRANSPARENT
	
	// CAUSTICS
	#ifdef CAUSTICS
	float caustics = getVoronoi((v_cpos.xz + v_cpos.y) * 0.6);
		diffuse.rgb += mul(diffuse.rgb * max(0.0, caustics) * 0.8, v_wlus);
	#endif // CAUSTICS

	// lussion
	vec3 luscol = vec3(0.5,1.0,0.8)+0.1;
	diffuse.rgb *= mix(vect3(1.0), luscol, max(norml.y, 0.5)*v_wlus);

	// reflection 
	#ifdef BLOCK_REFLECTION
	if (METAL_PIXEL(gtex)) {
		diffuse.rgb = mix(diffuse.rgb, v_skyMie, (fvector.rgb*0.8) * powCave);
		
		diffuse += (vec4(1.0,0.5,0.0,1.0)+0.3) * sdf * inv(v_ocave);
	}
	#endif

	// Rain Floor Reflection
	#ifdef FLOOR_REFLECTION
		diffuse.rgb = mix(diffuse.rgb, v_nfog.rgb, max(0.0, norml.y) * v_nfog.a *
		inv(v_unwater));
	#endif

	// New Fog
	#ifdef FOG
	vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, v_wtime.z);
	vec3 targetcol = mix(v_skyMie, UnDerWFog, v_unwater);
	diffuse.rgb = mix(diffuse.rgb, targetcol, v_fog.a);
	diffuse.rgb = mix(diffuse.rgb, v_skyMie,
	clamp(length(v_wpos.xz*0.003),0.0,0.5)*inv(v_unwater));
	#endif 

	// Underwater ray effect
	#ifdef UNDERWATER_RAYS
		float Grand2 = 0.145;
		float noiseValue = noise(vect2(atan2(v_wpos.x, v_wpos.z)) * 9.4);
		vec3 baseColor = mix(vect3(0.0), vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
		float weight = str(smoothstep(6.0,32.0,length(v_wpos.xz)));
		vec3 finalColor = mix(vect3(0.0), baseColor, weight * v_unwater);
		diffuse.rgb += finalColor;
	#endif

	// Tone Mapping Enabled
	diffuse.rgb = AzifyColors(diffuse.rgb);
	gl_FragColor = diffuse;
}