$input v_color0, v_texcoord0
$input v_skypos

#include <bgfx_shader.sh>
SAMPLER2D_AUTOREG(s_MatTexture);
#include <azify/core.sh>

void main() {
	#ifndef OPAQUE
	//Opaque
	//vec3 diffuse = texture2D(s_MatTexture, v_texcoord0).rgb;
	vec3 diffuse;
	/* Time Detection */
	vec4 wtime = getTime();
	bool getUnWater;
	bool getNether;
	getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);

	vec3 viewPos = normalize(v_skypos);
	float minPos = min(viewPos.y, 0.005);
	vec3 skyMie = calculateSky(SkyColor.rgb, viewPos, minPos, wtime);
	if (getUnWater) {
		vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, wtime.z);
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
		float Grand2 = 0.145;
		float noiseValue = noise(vect2(atan2(v_skypos.x, v_skypos.z)) * 9.4);
		vec3 baseColor = mix(vect3(0.0), vec3(0.5, 0.8, 1.0) * Grand2, noiseValue);
		float weight = str(smoothstep(12.5,13.5,length(v_skypos.xz)));
	  vec3 finalColor = mix(vect3(0.0), baseColor, weight);
		diffuse += finalColor;
	}
	#endif

	// Tone Mapping Enabled
	diffuse = AzifyColors(diffuse);
	gl_FragColor = vec4(diffuse, 1.0);
	#else
	//Fallback
	gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

	#endif
}