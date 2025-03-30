$input a_color0, a_position, a_texcoord0, a_texcoord1
#ifdef INSTANCING
$input i_data0, i_data1, i_data2
#endif
$output v_color0, v_fog, v_texcoord0, v_lightmapUV, v_worldColors, v_skyMie, v_ao, v_color2, v_color3, v_color4, v_nfog, v_newcolor, v_dhcol, v_dscol, v_cpos, v_wpos
$output v_wlus, v_unwater, v_nether, v_water, v_wtime, v_ocave

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
	/* Time Detection */
	vec4 wtime = getTime();

	mat4 model;
	#ifdef INSTANCING
	model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0, 0, 0, 1));
	#else
	model = u_model[0];
	#endif

	vec3 worldPos = mul(model, vec4(a_position, 1.0)).xyz;
	vec4 color;
	#ifdef CHUNK_ANIMATION
	worldPos.y += chunkAni();
	#endif // CHUNK_ANIMATION

	color = a_color0;
	vec3 modelCamPos = (ViewPositionAndTime.xyz - worldPos);
	float camDis = length(modelCamPos);
	vec4 fogColor;
	fogColor.rgb = FogColor.rgb;
	fogColor.a = clamp(((((camDis / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x)), 0.0, 1.0);

	#ifdef TRANSPARENT
	if (a_color0.a < 0.95) {
		color.a = mix(a_color0.a, 1.0, clamp((camDis / FogAndDistanceControl.w), 0.0, 1.0));
	};
	#endif

	// world detections
	float waterlus = float(getWaterLus(a_texcoord1, a_position));
	float unwater = float(detectUnderwater(FogColor.rgb,
		FogAndDistanceControl.xy));
	float nether = float(detectNether(FogColor.rgb, FogAndDistanceControl.xy));
	#if !defined(DEPTH_ONLY_OPAQUE) || !defined(DEPTH_ONLY)
	bool getwtex = (a_color0.b > 0.3 && a_color0.a < 0.95);
	float watertex = float(getwtex);
	#endif

	// ambient occlusion
	vec4 getAO;
	float mincol = min(a_color0.r, a_color0.b),
	ncolor = (1.0-a_color0.g*1.0-mincol)*2.5,
	ao = str(ncolor*0.9);
	getAO.rgb = vec3(0.67, 0.69, 0.7);
	getAO.a = ao;

	vec3 newcolor = normalize(a_color0.rgb);
	newcolor /= mix(vect3(1.0), newcolor, (lights(newcolor) > 0.575)?1.0: 0.0);

	// cave detections
	float ocave = step(a_texcoord1.y, 0.935);
	float mcave = smoothstep(0.68, 0.05, a_texcoord1.y);
	//float powCave = pw2x(a_texcoord1.y);
	float powLight = pw3x(a_texcoord1.x);

	// Main World Color
	float icave = pow(1.0-a_texcoord1.y, 1.2);
	vec3 getMainColor = worldColor(wtime, a_texcoord1.x, icave, float(nether), mcave, ocave);
	// Torch Light
	vec3 getLights = lightColor(wtime, ocave, a_texcoord1.x);
	// World overall lighting
	vec4 Azify;
	Azify.rgb = (getMainColor)+getLights;
	Azify.a = 1.0;
	// End of world colors

	// Dirlight colors
	vec3 dirhi = dirHighlightColor(wtime, float(nether), powLight, inv(ocave));
	vec3 dirsh = dirShadowColor(wtime, float(nether), powLight, inv(ocave));
	vec3 getDSpos = mix(vect3(1.0), dirsh, inv2( powLight,mcave)); //x
	vec3 getDHpos = mix(vect3(1.0), dirhi, inv2( powLight,ocave)); //y

	// skycol
	vec3 viewPos = normalize(worldPos);
	float minPos = min(viewPos.y, 0.005);
	vec3 getSky;
	getSky = calculateSky(SkyColor.rgb, viewPos, minPos, wtime);

	// rain reflection 
	vec3 n_wpos = normalize(-worldPos);
	float fogPosition = mix(0.0,
		mix(0.0, 0.65, smoothstep(0.5, 0.0, n_wpos.y)), abs(a_texcoord1.y) * wtime.w);
	vec4 sfog;
	sfog.rgb = getSky;
	sfog.a = fogPosition*0.7;

	v_texcoord0 = a_texcoord0;
	v_lightmapUV = a_texcoord1;
	v_color0 = a_color0;
	v_fog = fogColor;
	v_ao = getAO;
	v_worldColors = Azify;
	v_skyMie = getSky;
	v_nfog = sfog;
	v_newcolor = newcolor;
	v_dscol = getDSpos;
	v_dhcol = getDHpos;
	v_cpos = a_position;
	v_wpos = worldPos;
	v_wlus = waterlus;
	v_unwater = unwater;
	v_nether = nether;
	v_water = watertex;
	v_wtime = wtime;
	v_ocave = ocave;
	gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
}