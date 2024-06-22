#ifndef CLOUD
 #define CLOUD
 
<<<<<<< HEAD
 #define time ViewPositionAndTime.w

 float fbm(vec2 pos) {
    float sum = 0.0;
    float amp = 1.0;
    float freq = 0.0;
    vec2 adjustedPos = pos + time * 0.1;
    
    for (int i = 0; i <= 2; i++) {
        sum += noise(adjustedPos) / amp;
        amp *= 2.5;
        adjustedPos *= 3.0;
        adjustedPos += time * 0.3;
    }
    return 1.0 - pow(0.1, max(1.0 - sum, 0.0));
}

float generateCloud(vec2 pos, float timed) {
    float cloudNoise = 0.0;
    vec2 modifiedPos = pos * 0.99;
    cloudNoise += noise(timed * 0.05 + modifiedPos);
    
    float noiseDensity = mix(smoothstep(0.3, 0.8, cloudNoise), smoothstep(-0.06, 0.26, cloudNoise), AFrain);

    float cloudFbm = fbm(-timed * 0.09 + modifiedPos);
    float fbmDensity = mix(smoothstep(-1.0, 2.0, cloudFbm), smoothstep(-1.15, 1.56, cloudFbm), AFrain);
    modifiedPos *= mix(1.0, 1.3, fbmDensity);
    
    float alpha = cloudNoise - (0.3 - noiseDensity) - cloudFbm - (0.3 - fbmDensity);
    alpha = max(alpha, 0.0);
    
    cloudNoise = 1.0 - pow(0.51, alpha);
    cloudFbm = 1.2 - pow(0.01, alpha);
    return cloudFbm - cloudNoise * cloudNoise - cloudNoise * 0.01 * cloudFbm * 2.0 - cloudFbm * 0.006 * cloudFbm;
}
 
 float generateAurora(vec2 p, float timed) {
=======
 float fbm(vec2 pos, float time) {
    float tot = 0.0, s = 1.0;
    pos += time * 0.001;
    for(int i = 0; i <= 1; i++){
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
}
 
 float amap(vec2 p, float time){
>>>>>>> origin/main
  float x;
  float x1;
  float x2;
  for(int i = 0; i <= 1; i++){
    x1 = noise(p);
<<<<<<< HEAD
    x2 = noise(p*4.+vec2(timed*0.02,16));
=======
    x2 = noise(p*4.+vec2(time*0.02,16));
>>>>>>> origin/main
  }
  x = dot(vec2(x1,x2),vec2(0.8,0.3));
  return x;
}
 
 #endif