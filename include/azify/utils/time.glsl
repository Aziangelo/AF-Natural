#ifndef TIME
 #define TIME
 
// TIME AND WORLD DETECTIONS
#define detect(a,b,x) clamp(((x)-(a))/((b)-(a)), 0.0, 1.0)
const float AFrain  = smoothstep(0.66, 0.3, FogAndDistanceControl.x);
const float AFnight = mix( detect( 0.65, 0.02, FogColor.r ), detect( 0.15, 0.01, FogColor.g ), AFrain );
const float AFdusk  = mix( detect( 1.0, 0.0, FogColor.b ), detect( 0.25, 0.15, FogColor.g ), AFrain );
const float AFday   = detect(0.02, 0.65, FogColor.r);
#define timecycle( a, b, c ) mix( mix( a, b, AFdusk ), c, AFnight )
vec4 wtime = vec4(AFday,AFdusk,AFnight,AFrain);
 
 #endif