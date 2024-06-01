#ifndef FUNCTIONS
 #define FUNCTIONS



// TIME AND WORLD DETECTIONS
 #define detect(a,b,x) clamp(((x)-(a))/((b)-(a)), 0.0, 1.0)
 #define disf ((FogAndDistanceControl.w-80.0)/112.0)
 #define AFnether detect( 0.24, 0.13 - ( 0.08 * disf ), FogAndDistanceControl.x )
 #define AFrain smoothstep(0.66, 0.3, FogAndDistanceControl.x)
 #define AFnight mix( detect( 0.65, 0.02, FogColor.r ), detect( 0.15, 0.01, FogColor.g ), AFrain )
 #define AFdusk mix( detect( 1.0, 0.0, FogColor.b ), detect( 0.25, 0.15, FogColor.g ), AFrain )
 #define timecycle( a, b, c ) mix( mix( a, b, AFdusk ), c, AFnight )


// TONE MAPPING 
vec3 AzifyFN(vec3 x) {
 float a = 5.61;
 float b = 0.03;
 float c = 3.6;
 float d = 0.4;
 float e = 0.5;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

// NOISE
float hash( float n ) {
    return fract(sin(n)*43758.5453);
}
float noise(vec2 x) {
 vec2 p = floor(x);
 vec2 f = fract(x);
   f = f*f*(3.0-2.0*f);
   float n = p.x + p.y*57.0;
   return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

float fbm(vec2 pos, float time) {
    float s1 = 1.0, s2 = 2.2;
    float tot1 = noise(pos + time * 0.005) / s1;
    pos = (pos + time * 0.005) * 3.0 + time * 0.06;
    float tot2 = noise(pos) / s2;
    
    float tot = tot1 + tot2;
    return 1.0 - pow(0.1, max(1.0 - tot, 0.0));
}

vec4 generateCloud( vec2 position, float time) {
    float cloudNoise = 0.0;
      position *= 0.7995;
      cloudNoise += noise(time * 0.06 + (position));
    float smoothNoise = smoothstep(0.1, 1.2, cloudNoise);
    float cloudFbm = fbm(-time * 0.13 + (position), time);
    float smoothFbm = smoothstep(-1.0, 2.5, cloudFbm);
      position *= mix(1.0, 1.93, smoothFbm);

    // Clouds Sizes
    float alpha = cloudNoise - (mix(0.3, 0.16, AFrain) - smoothNoise) - cloudFbm - (0.3 - smoothFbm);
    if (alpha < 0.0) alpha = 0.0;
      cloudNoise = 1.0 - pow(0.51, alpha);
      cloudFbm = 1.2 - pow(0.01, alpha);

    lowp vec4 cloudResult = vec4(cloudFbm - cloudNoise * cloudNoise - cloudNoise * 0.01 * cloudFbm * 2.0 - cloudFbm * 0.006 * cloudFbm);
    return cloudResult;
}

float amap(vec2 p, float time){
  float x;
  float x1;
  float x2;
  for(int i = 0; i <= 1; i++){
    x1 = noise(p);
    x2 = noise(p*4.+vec2(time*0.02,16));
  }
  x = dot(vec2(x1,x2),vec2(0.8,0.3));
  return x;
}

float smoothstepCustom(float edge0, float edge1, float x) {
    float t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
}

// VORONEI
float voro2D(vec2 p, float time) {
    vec4 v = vec4(p, p.x + p.y, p.x + p.y);
    v.xy += time * 0.35;
    float s1 = length(0.5 - fract(v.xyw *= mat3(0, -1, 2, 3, -3, 1, 1, 2, 1) * 0.5));
    float s2 = length(0.5 - fract(v.xyw *= mat3(0, -1, 2, 3, -3, 1, 1, 2, 1) * 0.4));
    float s3 = length(0.5 - fract(v.xyw *= mat3(0, -1, 2, 3, -3, 1, 1, 2, 1) * 0.3));
    float minDist = min(min(s1, s2), s3);
    return pow(minDist, 4.0) * 4.0;
}

vec3 grayscale(vec3 color) {
    return vec3(dot(color, vec3(0.2126, 0.7152, 0.0722)));
}

bool detectUnderwater(vec3 FOG_COLOR, vec2 FOG_CONTROL) {
  return FOG_CONTROL.x==0.0 && FOG_CONTROL.y<0.8 && (FOG_COLOR.b>FOG_COLOR.r || FOG_COLOR.g>FOG_COLOR.r);
}

bool detectNether(vec3 FOG_COLOR, vec2 FOG_CONTROL) {
  float expectedFogX = 0.029 + (0.09*FOG_CONTROL.y*FOG_CONTROL.y);
  bool netherFogCtrl = (FOG_CONTROL.x<0.14  && abs(FOG_CONTROL.x-expectedFogX) < 0.02);
  bool netherFogCol = (FOG_COLOR.r+FOG_COLOR.g)>0.0;
  bool underLava = FOG_CONTROL.x == 0.0 && FOG_COLOR.b == 0.0 && FOG_COLOR.g < 0.18 && FOG_COLOR.r-FOG_COLOR.g > 0.1;
  return (netherFogCtrl && netherFogCol) || underLava;
}

#endif