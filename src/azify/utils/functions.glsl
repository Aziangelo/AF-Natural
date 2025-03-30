#ifndef FUNCTIONS
#define FUNCTIONS


// Noise Hash
float hash(float n) {
	return fract(sin(n+2836.5)*43758.5453);
}
float noise(vec2 x) {
	vec2 p = floor(x),
	f = fract(x); f = f*f*(3.0-2.0*f);
	float n = p.x+p.y*57.0;
	return mix(mix(hash(n+0.0), hash(n+1.0), f.x), mix(hash(n+57.0), hash(n+58.0), f.x), f.y);
}

//float noise(vec2 x) {
//  return texture2D(s_MatTexture, fract(x*vec2(1,2))).r;
//}

// Dithering - UnOptimized
// NONE

// Optimized - Voronoi
float lpoint(vec2 pos) {
	pos.x += time*0.5;
	pos.y -= sin(time*0.3);
	return length(fract(pos) - 0.5);
}
float getVoronoi(vec2 pos) {
	mat2 m = mat2(-8, -2, 3.14, 8) / 1e1;
	return min(lpoint(pos), lpoint(mul(pos, m)));
}

// light directions
vec3 getldir(vec4 t, vec3 n) {
	float x = max(mix(-n.x, n.x, t.z), n.y);
	float y = max(0.0, max(mix(n.x, -n.x, t.z), 0.0) + max(n.z, -n.z) - n.y);
	float z = max(0.0, mix(-n.x, n.x, t.z));
	return str(vec3(x, y, z));
}

// chunk animation
float chunkAni() {
	float bI = 7.5,
	bS = 1.2,
	bX = abs(sin(RenderChunkFogAlpha.x*bS*3.14159)),
	bump = 600.0*pow(RenderChunkFogAlpha.x, 3.0);
	return bI * bX - bump;
}

#endif