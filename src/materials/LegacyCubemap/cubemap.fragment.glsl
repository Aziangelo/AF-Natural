$input v_texcoord0, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

SAMPLER2D_AUTOREG(s_MatTexture);

void main() {
	// Time Detection
	vec4 wtime = getTime();
	bool unwater = detectUnderwater(FogColor.rgb, FogAndDistanceControl.xy);
	vec4 diffuse = texture2D(s_MatTexture, v_texcoord0);
	vec4 color;

	vec3 eyepos = normalize(v_wpos);
	float minPos = min(eyepos.y, 0.005);
	vec3 skyMie = calculateSky(SkyColor.rgb, eyepos, minPos, wtime);
	if (unwater) {
		vec3 UnDerWFog = mix(FOG_UNDERW_DAY, FOG_UNDERW_NIGHT, wtime.z);
		color.rgb = UnDerWFog;
	} else {
		color.rgb = skyMie;
	}

	#ifdef UNDERWATER_RAYS
  if (unwater) {
		float gval = 0.145;
		float nval = noise(vect2(atan2(v_wpos.x, v_wpos.z)) * 9.4);
		vec3 basecol = mix(vect3(0.0), vec3(0.5, 0.8, 1.0) * gval, nval);
		float weight = str(smoothstep(106.5,632.5,length(v_wpos.xz)));
	  vec3 finalColor = mix(vect3(0.0), basecol, weight);
		color.rgb += finalColor;
  }
	#endif

	float fade = str(-10.0*eyepos.y);
	color = vec4(AzifyColors(color.rgb), fade);
  diffuse = mix(color, diffuse, diffuse.a);
	gl_FragColor = diffuse;
}