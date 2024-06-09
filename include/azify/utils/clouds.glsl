#ifndef CLOUD
 #define CLOUD
 
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
 
 #endif