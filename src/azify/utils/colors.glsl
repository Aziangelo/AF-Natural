#ifndef COLORS
#define COLORS

vec3 worldColor(vec4 wtime, float lit, float lit2, float neth) {
  vec3 mRin = mix(D_RAINc, N_RAINc, wtime.z),
  col = mix(DAYc, DUSKc, wtime.y);
  col = mix(col, NIGHTc, wtime.z);
  col = mix(col, mRin, wtime.w);
  col = mix(col, CAVEc, lit2);
  col = mix(col, NETHERc, neth);
  col = mix(col, vect3(1.0), lit);
  return col;
}

vec3 shadowColor(float midC, float outC, float lit) {
  vec3 c = CAVEOUTc,
  col = mix(vect3(1.0), c, outC*inv(midC));
  col = mix(col, vec3(1.0, 0.93, 0.9), lit);
 return col;
}

//vec3 lightColor(vec4 wtime) {
//  return;
//}


vec3 cloudsColor(vec4 wtime) {
  vec3 mRin = mix(CLOUD_D_RAINc, CLOUD_N_RAINc, wtime.z);
  return mix(mix(mix(CLOUD_DAYc, CLOUD_NIGHTc, wtime.z), CLOUD_DUSKc, wtime.y), mRin, wtime.w);
}

vec3 cloudShadowColor(vec4 wtime) {
  vec3 mRin = mix(SHADOW_D_RAINc, SHADOW_N_RAINc, wtime.z);
  return mix(mix(mix(SHADOW_DAYc, SHADOW_NIGHTc, wtime.z), SHADOW_DUSKc, wtime.y), mRin, wtime.y);
}

#endif // COLORS