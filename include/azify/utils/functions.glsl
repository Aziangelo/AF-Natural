#ifndef FUNCTIONS
 #define FUNCTIONS

// TONE MAPPING 
vec3 AzifyFN(vec3 x) {
 float a = 5.0;
 float b = 0.3;
 float c = 3.6;
 float d = 0.4;
 float e = 0.5;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

// NOISE & HASH
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

// DITHER
#define CL_QUALITY 0.5
#define DITHER 1
#if DITHER==1
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}
float dither(vec2 pos) {
    return CL_QUALITY * (rand(pos) - 0.5);
}
#elif DITHER==2
float dither(vec2 pos) {
    float gridSize = 4.0; // Adjust the grid size for dither effect
    vec2 grid = floor(pos * gridSize);
    float ditherValue = mod(grid.x + grid.y, 2.0) * 0.5;
    return CL_QUALITY * (ditherValue - 0.25);
}
#endif




vec3 getTangent(vec3 n) 
{
    if (n.x > 0.0) return vec3(0, 0, -1);
    if (n.x < -0.5) return vec3(0, 0, 1);
    if (n.y > 0.0) return vec3(1, 0, 0);
    if (n.y < -0.5) return vec3(1, 0, 0);
    if (n.z > 0.0) return vec3(1, 0, 0);
    if (n.z < -0.5) return vec3(-1, 0, 0);
    return vec3(0, 0, 0);
}


mat3 getTBN(vec3 n) 
{
  vec3 t = normalize(getTangent(n));
  vec3 b = cross(n, t);
  return transpose(mat3(t, b, n));
}

vec3 getFresnel(float NoV, vec3 roughness)
{
  vec3 f0 = roughness;
  return (f0 + (1.0-f0) * pow((1.0-NoV), 5.));
}

// VORONEI
float voronoi(vec2 pos) {
    vec2 p = pos * 1.5; // scale
    float t = time * 0.25;
    mat2 m = mat2(0.8, -0.6, 0.6, 0.8);

    // Offset position
    vec2 p1 = fract(p + t);
    vec2 tpt = mul((p + vec2(0.9, 0.9) - t * 0.2), m);
    vec2 p2 = fract(tpt);
    float d1 = length(p1 - vec2(0.5,0.5));
    float d2 = length(p2 - vec2(0.5,0.5));
    float d = min(d1, d2);
    d += 0.05 * sin(10.0 * p1.x + 10.0 * p1.y + t) * sin(10.0 * p2.x + 10.0 * p2.y + t);
    return d;
}

vec3 grayscale(vec3 color) {
    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
    return vec3(gray,gray,gray);
}

#endif