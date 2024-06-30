#ifndef FUNCTIONS
 #define FUNCTIONS

/* Simple Tone Mapping */
vec3 AzifyColors(vec3 x) {
	 float a = 5.55; // 5.0
	 float b = 0.03; // 0.3
	 float c = 3.60;
	 float d = 0.40;
	 float e = 0.50;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}
/* Advanced Cinematic Tone Mapping */
vec3 VintageCinematic(vec3 color) {
  vec3 sepia;
  sepia.r = dot(color, vec3(0.393, 0.769, 0.189));
  sepia.g = dot(color, vec3(0.349, 0.686, 0.168));
  sepia.b = dot(color, vec3(0.272, 0.534, 0.131));

  float contrast = 1.2; // contrast
  sepia = ((sepia - 0.5) * max(contrast, 0.0)) + 0.5;
  sepia = clamp(sepia, 0.0, 1.0);

  // white balance
  //sepia = sepia / (sepia + vec3(1.0));

  float blendFactor = 0.8; // blend
  vec3 finalColor = mix(color, sepia, blendFactor);

  return finalColor;
}

/* Noise Hash */
float hash( float n ) {
    return fract(sin(n+2836.5)*43758.5453);
}
float noise(vec2 x) {
 vec2 p = floor(x);
 vec2 f = fract(x);
   f = f*f*(3.0-2.0*f);
   float n = p.x + p.y*57.0;
   return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

/* Dithering - UnOptimized */ 
// NONE

/* Integrated Normal Mapping */
void getNormals(inout vec3 integratedMapping, in sampler2D MatTexture, in vec2 texcoord0, inout bool Metals) {
	float MiXedB = mix(NORMALS_BEVEL, METALLIC_BEVEL, float(Metals));
	float MiXedS = mix(NORMALS_STREN, METALLIC_STREN, float(Metals));
	vec3 e = vec3(MiXedB, 0.0, MiXedB);
	vec3 f = texture2D(MatTexture,texcoord0+e.yz).rgb;
	vec3 g = texture2D(MatTexture,texcoord0+e.xx).rgb;
	vec3 h = texture2D(MatTexture,texcoord0+e.xy).rgb;
	vec3 w = vec3(0.299, 0.587, 0.114);
	
	float a = dot(f, w);
	float b = dot(g, w);
	float c = dot(h, w);
	
	float k = MiXedS;
	float d1 = (a - b) * k;
	float d2 = (a - c) * k;
	
	float r1 = d1 * 0.4 + d2 * 0.6;
	float r2 = d1 * 0.3 + d2 * 0.7;
	vec3 subVec3 = vec3(r1, r2, 1.0);
	integratedMapping = normalize(subVec3); // Convert texture to implement an Integrated PBR
}

/* Water Surface */
vec3 getFresnel(float valA, vec3 valB) {
    vec3 base = valB;
    float complement = 1.0 - valA;
    float exponent = pow(complement, 5.0);

    vec3 unitVec = float3(1.0);
    vec3 subtractedVec = unitVec - base;
    vec3 scaledVec = subtractedVec * exponent;

    vec3 resultVec = base + scaledVec;
    return resultVec;
}

/* UnOptimized - Voronoi */
float lpoint(vec2 pos) {
    pos.x += time*0.5;
    pos.y -= sin(time*0.3);
return length(fract(pos) - 0.5);
}

float getVoronoi(vec2 pos) {
    mat2 m = mat2(-8,-5,3.14,8) / 1e1;
    pos.x += sin(time*0.5);
    pos.y -= time*0.2;
return min(lpoint(pos), lpoint(mul(pos, m)));
}
/*
float getVoronoi(vec2 pos) {
    // Scaled positions
    vec2 scaledPos = pos * 1.5;
    float tempVar = time * 0.25;

    // Compute offset positions
    vec2 offset1 = fract(scaledPos + tempVar);
    vec2 tempPos = scaledPos + float2(0.9) - tempVar * 0.2;
    vec2 offset2 = fract(mat2(0.8, -0.6, 0.6, 0.8) * tempPos);

    // Calculate distance
    float distance1 = dot(offset1 - vec2(0.5), offset1 - vec2(0.5));
    float distance2 = dot(offset2 - vec2(0.5), offset2 - vec2(0.5));
    float minDistance = min(distance1, distance2);

    // noise
    float noise1 = sin(dot(offset1, vec2(10.0, 10.0)) + tempVar);
    float noise2 = sin(dot(offset2, vec2(10.0, 10.0)) + tempVar);
    float resultDistance = sqrt(minDistance) + 0.05 * noise1 * noise2;

    return resultDistance;
}*/

/* Luma / GrayScale */
float grayscale(vec3 color) {
    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
    return gray;
}

#endif