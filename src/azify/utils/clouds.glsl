#ifndef CLOUD
 #define CLOUD

float dit(highp vec2 a){
a = floor(a);
return fract(a.x / 2.0 + a.y * a.y * 0.75);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) { // Increased octaves for more detail
        value += amplitude * noise(p);
        p.xy *= 3.5; // Stretch each octave
        amplitude *= 0.5;
    }
    return value;
}

float getCirrusClouds(vec2 p) {
  p *= 0.788; // Scale
  vec2 clP = p + time * 0.1;
  float cNoise = fbm(clP * 5.0) * 0.6 + fbm(clP * 10.0) * 0.3 + fbm(clP * 20.0) * 0.1; // Adjusted weights for more natural variation
  return smoothstep(0.4, 0.6, cNoise); 
}

/* 
Base code: https://www.shadertoy.com/view/4tdSWr
Reference: sues shader by shimpanseGaming */
float getFbm(vec2 pos) {
  float 
  sum = 0.0, 
  amp = 1.0;
  vec2 ajp = pos+time*0.1;
  for (int i=0;i<=CLOUD_STEPS;i++) {
    sum += noise(ajp*(0.98+dit(v_texcoord0*1024.0)*0.02))/amp;
    amp *= 2.5;
    ajp = ajp*3.0+time*0.3;
  }
  return 1.0-pow(0.1,max(1.0-sum,0.0));
}
float getClouds(vec2 p) {
    vec2 clP = p+time*0.15;
    float cNoise = noise(clP*(0.98+dit(v_texcoord0*1024.0)*0.02));
    float nDensity = mix(smoothstep(0.4,0.9,cNoise),smoothstep(0.0,0.7,cNoise),AFrain); // Compute noise density

    float cFbm = getFbm(-time*0.35+p);
    float fDensity = mix(smoothstep(0.0,2.5,cFbm),smoothstep(0.0,2.0,cFbm),AFrain); // Compute FBM density
    p *= mix(1.0,1.3,fDensity); // Adjust position with FBM density
    
    float alpha = cNoise-(0.3-nDensity)-cFbm-(0.3-fDensity); // Compute alpha
    alpha = max(alpha,0.0); // Ensure alpha is non-negative
    
    cNoise = 1.0-pow(0.51,alpha);
    cFbm = 1.2-pow(0.01,alpha);
    
    float mainClouds = cFbm-cNoise*cNoise-cNoise*0.01*cFbm*2.0-cFbm*0.006*cFbm;
    // Integrate cirrus
    float cirrus;
    //cirrus = getCirrusClouds(p);
    // final cloud value
    return max(cirrus*0.,mainClouds);
}

vec3 finalClouds(vec3 col, vec3 vpos, vec4 wtime) {
  vpos *= 0.888; // Scale position
  vec2 
  uv = (vpos.xz/vpos.y)*2.5,
  clPos = uv+time*0.15;
  float 
  dit = (0.98+dit(v_texcoord0*1024.0)*0.02),
  c1 = getClouds(uv*dit),
  cnoise = noise(clPos*dit),
  c2 = smoothstep(0.3,1.3,cnoise),
  x1 = str(smoothstep(0.5,1.8,length(-vpos.y*5.0))),
  mc1 = c1*0.5*x1;
  col = mix(col, cloudsColor(wtime), mc1);
  col = mix(col, cloudShadowColor(wtime), c2*x1);
  return col;
}

/* Aurora mapping */
float amap(vec2 p) {
    float x1 = noise(p);
    float x2 = noise(p * 2.0 + vec2(time * 0.02, 16.0));
    return dot(vec2(x1, x2), vec2(0.7, 0.4));
}

/* Aurora generation */
void getAurora(inout vec3 diffuse, in vec3 viewPos, in vec4 wtime) {
    vec2 timeOffset = vec2(0.1, 0.06);
    vec2 apos = viewPos.xz / viewPos.y;
    vec2 aposOffset = apos + time * timeOffset.x;

    float auroraPattern = amap(aposOffset);
    vec3 auroraColor = mix(AURA_C1, AURA_C2, smoothstep(0.5, 1.0, auroraPattern));

    float smoothedPos = smoothstep(0.5, 1.0, amap(apos - time * timeOffset.y));
    float yFactor = clamp(smoothstep(0.9, 2.5, length(-viewPos.y * 5.0)), 0.0, 1.0);

    diffuse += auroraColor * smoothedPos * yFactor * (wtime.z) * (1.0 - wtime.x) * (1.0 - wtime.w);
}

/* Calculate Stars
Base code: https://www.shadertoy.com/view/NtsBzB */
vec3 shash( vec3 p ) {
	p=vec3( dot(p,vec3(127.1,311.7, 74.7)),
			  dot(p,vec3(269.5,183.3,246.1)),
			  dot(p,vec3(113.5,271.9,124.6)));
	return -1.0+2.0*fract(sin(p)*43758.5453123);
}
float snoise( in vec3 p ) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  vec3 u = f*f*(3.0-2.0*f);

  return mix( mix( mix( dot( shash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
       dot( shash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
       mix( dot( shash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
          dot( shash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
         mix( mix( dot( shash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
        dot( shash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
        mix( dot( shash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
    dot( shash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}

/* Enable Stars */
void getStars(inout vec3 diffuse, in vec3 viewPos, in vec4 wtime) {
  vec2 timeOffset = vec2(0.1, 0.06);
  vec2 apos = viewPos.xz / -viewPos.y;
  vec3 starPos = normalize(vec3(viewPos.xy * 2.0f - 1.0f, viewPos.z)); // could be view vector for example
	float stars_threshold = 8.0f; // modifies the number of stars that are visible
	float stars_exposure = 205.0f; // modifies the overall strength of the stars
	float stars = pow(clamp(snoise(starPos * 200.0f), 0.0f, 1.0f), stars_threshold) * stars_exposure;
	stars *= mix(0.4, 1.4, snoise(starPos * 100.0f + time)); // time based flickering
	float yFactor = clamp(smoothstep(0.0, 2.0, length(-viewPos.y * 5.0)), 0.0, 1.0);
diffuse.rgb += vec3(stars,stars,stars)*yFactor*max(wtime.y,wtime.z)*(1.0-wtime.w);
}


/*
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}
// Function to generate cirrus clouds
float getCirrusClouds(vec2 p) {
    p *= 0.5; // Scale position for cirrus clouds
    vec2 clP = p + time * 0.1;
    float cNoise = fbm(clP * 5.0) * 0.5 + fbm(clP * 10.0) * 0.25 + fbm(clP * 20.0) * 0.125;
    return smoothstep(0.3, 0.5, cNoise);
}
*/
/*
 float fbm(vec2 pos, float time) {
    float tot = 0.0, s = 1.0;
    pos += time * 0.001;
    for(int i = 0; i <= 1; i++) {
        tot += noise(pos) / s;
        s *= 2.2;
        pos *= 3.0;
        pos += time * 0.03;
    }
    return 1.0 - pow(0.1, max(1.0 - tot, 0.0));
}

float generateCloud(vec2 position, float time, int detail) {
    float cloudNoise = 0.0;
    position *= 0.7995;
    cloudNoise += noise(time * 0.06 + (position));
    
    float smoothNoise = smoothstep(0.1, 1.2, cloudNoise);
    float cloudFbm = fbm(-time * 0.13 + (position), time);
    float smoothFbm = smoothstep(-1.0, 2.5, cloudFbm);
    position *= mix(1.0, 1.93, smoothFbm);

    for (int i = 0; i < detail; i++) {
        position *= 0.7995;
        cloudNoise += noise(time * 0.06 + (position)) / float(i + 1);
        cloudFbm += fbm(-time * 0.13 + (position), time) / float(i + 1);
    }

    float alpha = cloudNoise - (mix(0.3, 0.16, AFrain) - smoothNoise) - cloudFbm - (0.3 - smoothFbm);
    if (alpha < 0.0) alpha = 0.0;
    cloudNoise = 1.0 - pow(0.51, alpha);
    cloudFbm = 1.2 - pow(0.01, alpha);

    float cloudResult = cloudFbm - cloudNoise * cloudNoise - cloudNoise * 0.01 * cloudFbm * 2.0 - cloudFbm * 0.006 * cloudFbm;
    return cloudResult;
}*/

 #endif