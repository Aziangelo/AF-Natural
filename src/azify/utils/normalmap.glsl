#ifndef NORMALS
#define NORMALS

float alphaD(bool m, bool w) {
  float alp = mix(METALLIC_BEVEL, WATER_BEVEL, float(w));
  return alp;
}

/* Integrated Normal Mapping 
By: Robobo1221 */
vec3 getNormals(sampler2D mt, vec2 uv, bool mtex, bool wtex) {
	float
	epsil = alphaD(mtex,wtex),
	ipsil= 1.0/epsil,
  strn = METALLIC_STREN,
  
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
vec3 getFresnel(float valA, vec3 valB) {
  vec3 base = valB;
  float complement = 1.0 - valA;
  float exponent = pow(complement, 5.0);

  vec3 unitVec = vect3(1.0);
  vec3 subtractedVec = unitVec - base;
  vec3 scaledVec = subtractedVec * exponent;

  vec3 resultVec = base + scaledVec;
  return resultVec;
}

#endif // NORMALS