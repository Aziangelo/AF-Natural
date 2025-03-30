#ifndef NORMALS
#define NORMALS

float bevel(bool m, float w) {
  return mix(METALLIC_BEVEL, WATER_BEVEL, w);
}
float strength(bool m, float w) {
  return mix(METALLIC_STREN, WATER_STREN, w);
}

/* Integrated Normal Mapping 
By: Robobo1221 */
vec3 getNormals(sampler2D mt, vec2 uv, bool mtex, float wtex) {
	float
	epsil = bevel(mtex,wtex),
	ipsil= 1.0/epsil,
  strn = strength(mtex,wtex),
  
  e = epsil,
	g = gray(texture2D(mt,uv+vec2(e,0.0)).rgb),
  h = gray(texture2D(mt,uv+vec2(0.0,e)).rgb),
  f = gray(texture2D(mt,uv).rgb),

  k = strn,
  dx = (f-g)*k,
  dy = (f-h)*k;
	return normalize(vec3(dx, dy, 1.0));
}

/* Water Surface */
vec3 getFresnel(float df, vec3 base) {
    float comp = pow(1.0 - df, 3.0);
    return base + (vec3(1.0) - base) * comp;
}

#endif // NORMALS