#ifndef TIME
 #define TIME
 
// TIME AND WORLD DETECTIONS
#define detect(a,b,x) clamp(((x)-(a))/((b)-(a)), 0.0, 1.0)
#define AFrain smoothstep(0.66, 0.3, FogAndDistanceControl.x)
#define AFnight mix( smoothstep( 0.65, 0.02, FogColor.r ), smoothstep( 0.15, 0.01, FogColor.g ), AFrain )
#define AFdusk mix( smoothstep( 1.0, 0.0, FogColor.b ), smoothstep( 0.25, 0.15, FogColor.g ), AFrain )
#define AFday smoothstep(0.02, 0.65, FogColor.r)
//#define timecycle( a, b, c ) mix( mix( a, b, AFdusk ), c, AFnight )
#define Wtime vec4(AFday,AFdusk,AFnight,AFrain)
 
 #endif