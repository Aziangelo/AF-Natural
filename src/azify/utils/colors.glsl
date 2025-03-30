#ifndef COLORS
#define COLORS

// world shadow color
vec3 shadowColor(float midC, float outC, float lit) {
	vec3 c = vec3(1.0),
	col = mix(vect3(1.0), c, outC*inv(midC));
	col = mix(col, vec3(1.0, 0.93, 0.9), lit);
	return col;
}

// world color
vec3 worldColor(vec4 wtime, float lit, float ic, float neth, float mc, float oc) {
	vec3 mRin = mix(D_RAINc, N_RAINc, wtime.z);
	vec3 col = mix(DAYc, DUSKc, wtime.y);
	col = mix(col, NIGHTc, wtime.z);
	col = mix(col, mRin, wtime.w);
	col = mix(col, CAVEc, ic);
	col = mix(col, NETHERc, neth);
	col = mix(col, vect3(1.0), pw3x(lit));
	return col;
}


// world torch light color
vec3 lightColor(vec4 wtime, float oc, float x) {
	vec3 c = TORCH_D;
	vec3 cx = c*pw3x(x);
	float d = max(oc, wtime.z);
	return mul(cx, d);
}

// direct light (highlight) color
vec3 dirHighlightColor(vec4 wtime, float neth, float lit, float cve) {
	vec3 x = mix(mDL_DAYc, mDL_DUSKc, wtime.y);
	x = mix(x, mDL_NIGHTc, wtime.z);
	x = mix(x, mDL_RAINc, wtime.w);
	return x;
}
// direct light (shadow) color
vec3 dirShadowColor(vec4 wtime, float neth, float lit, float cve) {
	vec3 x = mix(mDS_DAYc, mDS_DUSKc, wtime.y);
	x = mix(x, mDS_NIGHTc, wtime.z);
	x = mix(x, mDS_RAINc, wtime.w);
	x = mix(x, NETHERc-0.3, neth);
	return x;
}

// clouds base color
vec3 cloudsColor(vec4 wtime) {
	vec3 mRin = mix(CLOUD_D_RAINc, CLOUD_N_RAINc, wtime.z);
	return mix(mix(mix(CLOUD_DAYc, CLOUD_DUSKc, wtime.y), CLOUD_NIGHTc, wtime.z), mRin, wtime.w);
}

// clouds shadow color
vec3 cloudShadowColor(vec4 wtime) {
	vec3 mRin = mix(SHADOW_D_RAINc, SHADOW_N_RAINc, wtime.z);
	return mix(mix(mix(SHADOW_DAYc, SHADOW_DUSKc, wtime.y), SHADOW_NIGHTc, wtime.z), mRin, wtime.w);
}

#endif // COLORS