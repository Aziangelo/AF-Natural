#ifndef FUNCTIONS
 #define FUNCTIONS


/* Noise Hash */
float hash( float n ) {
  return fract(sin(n+2836.5)*43758.5453);
}
float noise(vec2 x) {
 vec2 p = floor(x),
 f = fract(x);f = f*f*(3.0-2.0*f);
 float n = p.x+p.y*57.0;
 return mix(mix(hash(n+0.0),hash(n+1.0),f.x),mix(hash(n+57.0),hash(n+58.0),f.x),f.y);
}
/*
float noise(vec2 x) {
  return texture2D(s_MatTexture, fract(x*vec2(1,2))).r;
}
*/

/* Dithering - UnOptimized */ 
// NONE

/* Optimized - Voronoi */
float lpoint(vec2 pos) {
    pos.x += time*0.5;
    pos.y -= sin(time*0.3);
return length(fract(pos) - 0.5);
}

float getVoronoi(vec2 pos) {
    mat2 m = mat2(-8,-2,3.14,8) / 1e1;
return min(lpoint(pos), lpoint(mul(pos, m)));
}
/*
float getVoronoi(vec2 pos) {
    // Scaled positions
    vec2 scaledPos = pos * 1.5;
    float tempVar = time * 0.25;

    // Compute offset positions
    vec2 offset1 = fract(scaledPos + tempVar);
    vec2 tempPos = scaledPos + vec2(0.9) - tempVar * 0.2;
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

#endif