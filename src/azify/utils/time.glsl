#ifndef TIME
 #define TIME

// time and world detections
//#define AFrain mix(smoothstep(0.55, 0.3, FogAndDistanceControl.x), 0.0, step(FogAndDistanceControl.x, 0.0))
float 
AFrain = mix(smoothstep(0.55, 0.3, FogAndDistanceControl.x), 0.0, step(FogAndDistanceControl.x, 0.0)),
AFday = smoothstep(0.02,0.65,FogColor.r),
AFnight = mix(smoothstep(0.65,0.02,FogColor.r),smoothstep(0.15,0.01,FogColor.g),smoothstep(0.55, 0.3, FogAndDistanceControl.x)),
AFdusk = mix(smoothstep(1.0,0.0,FogColor.b),smoothstep(0.25,0.15,FogColor.g),smoothstep(0.55, 0.3, FogAndDistanceControl.x));

//#define AFday smoothstep(0.02,0.65,FogColor.r)
//#define AFnight mix(smoothstep(0.65,0.02,FogColor.r),smoothstep(0.15,0.01,FogColor.g),AFrain)
//#define AFdusk mix(smoothstep(1.0,0.0,FogColor.b),smoothstep(0.25,0.15,FogColor.g),AFrain)


float getFogTime(vec4 fogCol)
{
  return clamp(((349.305545 * fogCol.g - 159.858192) * fogCol.g + 30.557216) * fogCol.g - 1.628452, -1., 1.);
}

vec4 getTime(vec4 fc) {
  vec4 wtime;
  wtime.x = AFday;
  wtime.y = AFdusk;
  wtime.z = AFnight;
  wtime.w = AFrain;
  return wtime;
}
 
 #endif