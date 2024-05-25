#ifndef SHADER_INPUTS
 #define SHADER_INPUTS
 
// PLEASE NOTE BEFORE EDITING!!!
// ==> READ THE (README.txt) FIRST!!!
#define AzifyNaturalv1.0


// =====>  [ MAIN WORLD ]  <=====
// OVERWORLD COLORS
 const vec3 DAYc = (vec3(0.76, 0.84, 0.88)* 1.0);
 const vec3 DUSKc = (vec3(0.74, 0.765, 0.8)* 0.55);
 const vec3 NIGHTc = (vec3(0.29, 0.33, 0.4)* 1.0);
 const vec3 RAINc = (vec3(0.58, 0.58, 0.58)* 1.0);
 const vec3 CAVEc = (vec3(0.2, 0.2, 0.25)* 1.0);
// ENTITY COLORS - seperated color!
 const vec3 IDAYc = (vec3(0.76, 0.84, 0.88)* 1.0);
 const vec3 IDUSKc = (vec3(0.74, 0.765, 0.8)* 0.55);
 const vec3 INIGHTc = (vec3(0.29, 0.33, 0.4)* 1.0);
 const vec3 IRAINc = (vec3(0.58, 0.58, 0.58)* 1.0);


#define SUPER_AO     // [ TOGGLE ]
#define CHUNK_ANIMATION

#define DIRECT_LIGHT     // [ TOGGLE ]
// >> OVERWORLD DIMENSION  <<===== // DIRECT LIGHT COLORS 
 const vec3 mDL_DAYc = (vec3(1.0, 0.9, 0.8)* 1.0);     // HIGHLIGHTS
 const vec3 mDL_DUSKc = (vec3(1.0, 0.9, 0.8)* 1.3);    // HIGHLIGHTS
 const vec3 mDL_NIGHTc = (vec3(1.0, 0.85, 0.95)* 1.0); // HIGHLIGHTS
 const vec3 mDL_RAINc = (vec3(0.8, 0.8, 0.8)* 1.0);    // HIGHLIGHTS
 const vec3 mDS_DAYc = (vec3(0.54, 0.58, 0.59)* 1.0);  // SHADOWS
 const vec3 mDS_DUSKc = (vec3(0.8, 0.81, 0.85)* 1.0);  // SHADOWS
 const vec3 mDS_NIGHTc = (vec3(0.75, 0.77, 0.8)* 1.0); // SHADOWS
 const vec3 mDS_RAINc = (vec3(0.7, 0.7, 0.7)* 1.0);    // SHADOWS
// >> NETHER DIMENSION <<===== // DIRECT LIGHT COLORS 
 const vec3 nDL_NETHc = (vec3(0.74, 0.78, 0.79)* 1.0); // HIGHLIGHTS
 const vec3 nDS_NETHc = (vec3(0.74, 0.78, 0.79)* 1.0); // SHADOWS
// >> END DIMENSION  <<===== // DIRECT LIGHT COLORS 
 const vec3 nDL_ENDc = (vec3(0.74, 0.78, 0.79)* 1.0);  // HIGHLIGHTS
 const vec3 nDS_ENDc = (vec3(0.74, 0.78, 0.79)* 1.0);  // SHADOWS


#define WATER_NORMALS      // [ TOGGLE ]
#define wNORMAL_INTENSITY 0.0009

#define WATER_GRADIENT     // [ TOGGLE ]
#define WATER_OPACITY 0.2
#define WATERGRAD_OPACITY 0.75
#define WATERGRAD_SMOOTHNESS 0.38


#define WATER_LINES        // [ TOGGLE ]
#define WATERLINE_INTENSITY 0.68
#define WATERLINE_OPACITY 0.3
// WATER LINES COLORS
 const vec3 wLINE_DAYc = (vec3(1.0, 0.99, 0.97)* 1.5);
 const vec3 wLINE_NIGHTc = (vec3(1.0, 0.9, 0.95)* 0.17);
 
#define FOG     // [ TOGGLE ]
// UNDER WATER FOG COLOR
 const vec3 UNDERWATER_FOG = (vec3(0.1, 0.53, 0.6)* 1.0);

#define CAUSTICS           // [ TOGGLE ]
#define BLOCK_REFLECTION   // [ TOGGLE ]
#define FLOOR_REFLECTION   // [ TOGGLE ]


// =====>  [ SKY MAIN ]  <=====
// SKY COLORS
 const vec3 SA_DAY = (vec3(0.17,0.42,0.6)* 1.0);
 const vec3 SA_DUSK = (vec3(0.1,0.23,0.4)* 1.0);
 const vec3 SA_NIGHT = (vec3(0.07,0.1,0.2)* 1.0);
 const vec3 SA_RAIN = (vec3(0.3, 0.3, 0.3)* 1.0);
 const vec3 SB_DAY = (vec3(0.95,1.0,0.9)* 1.0);
 const vec3 SB_DUSK = (vec3(1.0,0.45,0.23)* 1.0);
 const vec3 SB_NIGHT = (vec3(0.35,0.1,0.25)* 1.0);
 const vec3 SB_RAIN = (vec3(0.5, 0.5, 0.5)* 1.0);
 const vec3 SC_DAY = (vec3(0.3,0.4,0.6)* 1.0);
 const vec3 SC_DUSK = (vec3(0.6,0.4,0.3)* 1.0);
 const vec3 SC_NIGHT = (vec3(0.1,0.3,0.5) * 0.2);
 const vec3 SC_RAIN = (vec3(0.2, 0.2, 0.2)* 1.0);

//#define AURORA_BOREALIS     // [ TOGGLE ] [ BETA ]
#define CLOUDS              // [ TOGGLE ]
 const vec3 CLOUD_DAYc = (vec3(0.95, 0.98, 1.0)* 1.0);
 const vec3 CLOUD_DUSKc = (vec3(0.7, 0.49, 0.39)* 1.0);
 const vec3 CLOUD_NIGHTc = (vec3(0.25, 0.25, 0.37)* 1.0);
 const vec3 CLOUD_RAINc = (vec3(0.59, 0.6, 0.6)* 1.0);

#endif