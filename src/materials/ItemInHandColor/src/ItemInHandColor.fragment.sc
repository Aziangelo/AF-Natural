$input v_texcoord0, v_color0, v_light, v_fog

#include <bgfx_shader.sh>
#include <MinecraftRenderer.Materials/DynamicUtil.dragonh>
#include <MinecraftRenderer.Materials/FogUtil.dragonh>
#include <azify/core.sh>

void main() {
	#if DEPTH_ONLY
	gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	return;
	#else
	vec4 albedo;
	albedo.rgb = mix(vec3(1.0, 1.0, 1.0), v_color0.rgb, ColorBased.x);
	albedo.a = 1.0;

	#if MULTI_COLOR_TINT
	albedo = applyMultiColorChange(albedo, ChangeColor.rgb, MultiplicativeTintColor.rgb);
	#else
	albedo = applyColorChange(albedo, ChangeColor, v_color0.a);
	#endif

	albedo = applyOverlayColor(albedo, OverlayColor);
	albedo = applyLighting(albedo, vec4(float3(grayscale(v_light.rgb)), v_light.a));
  bool getUnWater;
	bool getNether;
	bool getWaterTex;
	getWorldDetections(getUnWater, getNether, FogColor, FogAndDistanceControl);
	getWaterTex = v_color0.b > 0.3 && v_color0.a < 0.95;
	float getCave = smoothstep(0.65, 0.1, v_light.b);

	if (getNether) {
  albedo.rgb *= vec3(0.9, 0.9, 0.9);
	} else {
	vec3 raincc = mix(D_ERAINc, N_ERAINc+0.553, AFnight);
	vec3 mainCC;
	mainCC = mix(EDAYc, EDUSKc+0.337, AFdusk);
	mainCC = mix(mainCC, ENIGHTc+0.553, AFnight);
	mainCC = mix(mainCC, raincc, AFrain);
	mainCC = mix(mainCC, ECAVEc+0.863, getCave);
	albedo.rgb *= mainCC.rgb;
	}

	#if ALPHA_TEST
	if (albedo.a < 0.5) {
		discard;
	}
	#endif

  albedo.rgb = AzifyColors(albedo.rgb);
	/* Vintage Tonemap */
	#ifdef VINTAGE_TONE
	albedo.rgb = VintageCinematic(albedo.rgb);
	#endif
	albedo.rgb = applyFog(albedo.rgb, v_fog.rgb, v_fog.a);
	gl_FragColor = albedo;
	#endif // DEPTH_ONLY
}