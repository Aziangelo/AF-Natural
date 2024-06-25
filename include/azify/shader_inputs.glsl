#ifndef SHADER_INPUTS
 #define SHADER_INPUTS
 
// PLEASE NOTE BEFORE EDITING!!!
// ==> READ THE (README.txt) FIRST!!!
#define AzifyNaturalv1.0


// =====>  [ MAIN WORLD ]  <=====
// OVERWORLD COLORS
#define DAYc   vec3(0.76,0.84,0.88)* 1.0
#define DUSKc  vec3(0.45,0.42,0.4)* 1.0
#define NIGHTc vec3(0.2,0.25,0.4)* 1.0
#define RAINc  vec3(0.58,0.58,0.58)* 1.0
#define CAVEc  vec3(0.1,0.15,0.2)* 1.0
// ENTITY COLORS - seperated color for more control!
#define EDAYc   vec3(0.76,0.84,0.88)* 1.0
#define EDUSKc  vec3(0.74,0.765,0.8)* 0.55
#define ENIGHTc vec3(0.2,0.25,0.4)* 1.0
#define ERAINc  vec3(0.58,0.58,0.58)* 1.0
#define ECAVEc  vec3(0.1,0.15,0.2)* 1.0



#define SUPER_AO     // [ TOGGLE ]

#define CHUNK_ANIMATION

#define DIRECT_LIGHT     // [ TOGGLE ]
// >> OVERWORLD DIMENSION  <<===== // DIRECT LIGHT COLORS 
#define mDL_DAYc   vec3(1.0,0.9,0.8)* 1.0     // HIGHLIGHTS
#define mDL_DUSKc  vec3(1.0,0.9,0.8)* 1.3    // HIGHLIGHTS
#define mDL_NIGHTc vec3(0.95,0.85,1.0)* 1.0 // HIGHLIGHTS
#define mDL_RAINc  vec3(0.8,0.8,0.8)* 1.0    // HIGHLIGHTS
#define mDS_DAYc   vec3(0.54,0.58,0.59)* 1.0  // SHADOWS
#define mDS_DUSKc  vec3(0.8,0.81,0.85)* 1.0  // SHADOWS
#define mDS_NIGHTc vec3(0.77,0.75,0.8)* 1.0 // SHADOWS
#define mDS_RAINc  vec3(0.7,0.7,0.7)* 1.0    // SHADOWS
// >> NETHER DIMENSION <<===== // DIRECT LIGHT COLORS 
#define nDL_NETHc  vec3(0.74,0.78,0.79)* 1.0 // HIGHLIGHTS
#define nDS_NETHc  vec3(0.74,0.78,0.79)* 1.0 // SHADOWS
// >> END DIMENSION  <<===== // DIRECT LIGHT COLORS 
#define nDL_ENDc vec3(0.74,0.78,0.79)* 1.0  // HIGHLIGHTS
#define nDS_ENDc vec3(0.74,0.78,0.79)* 1.0  // SHADOWS


#define WATER_NORMALS      // [ TOGGLE ]
#define wNORMAL_INTENSITY 0.0009

#define WATER_GRADIENT     // [ TOGGLE ]
#define WATER_OPACITY 0.2
#define WATERGRAD_OPACITY 0.9
#define WATERGRAD_SMOOTHNESS 0.38


#define WATER_LINES        // [ TOGGLE ]
#define WATERLINE_INTENSITY 0.68
#define WATERLINE_OPACITY 0.55
// WATER LINES COLORS
#define wLINE_DAYc   vec3(0.45,0.9,1.0)* 1.0
#define wLINE_NIGHTc vec3(0.7,0.6,1.0)* 0.17
/*
// WATER LINES COLORS
#define wLINE_DAYc vec3(1.0,0.99,0.97)* 1.5
#define wLINE_NIGHTc vec3(1.0,0.9,0.95)* 0.17
*/
 
#define FOG     // [ TOGGLE ]
// UNDER WATER FOG COLOR
#define UNDERWATER_FOG vec3(0.1,0.53,0.6)* 1.0

#define CAUSTICS           // [ TOGGLE ]
#define BLOCK_REFLECTION   // [ TOGGLE ]
#define FLOOR_REFLECTION   // [ TOGGLE ]


// =====>  [ SKY MAIN ]  <=====
// SKY COLORS
#define SA_DAY   vec3(0.14,0.35,0.5)* 1.0  //up
#define SA_DUSK  vec3(0.2,0.23,0.4)* 1.0
#define SA_NIGHT vec3(0.14,0.18,0.31)* 1.0
#define SA_RAIN  vec3(0.3,0.3,0.3)* 1.0
#define SB_DAY   vec3(0.95,1.0,0.9)* 0.75  //mid
#define SB_DUSK  vec3(1.0,0.45,0.23)* 1.0
#define SB_NIGHT vec3(0.45,0.28,0.65)* 1.0
#define SB_RAIN  vec3(0.5,0.5,0.5)* 1.0
#define SC_DAY   vec3(0.1,0.2,0.4)* 1.0   //down
#define SC_DUSK  vec3(0.6,0.4,0.3)* 1.0
#define SC_NIGHT vec3(0.1,0.3,0.5) * 0.2
#define SC_RAIN  vec3(0.2,0.2,0.2)* 1.0

/* Aurora Enable and Colors */
//#define AURORA_BOREALIS     // [ TOGGLE ] [ BETA ]
#define AURA_C1  vec3(1.0,0.0,0.5)* 1.0
#define AURA_C2  vec3(0.0,1.0,0.5)* 1.0

/* Clouds Enable and Colors */
#define CLOUDS        // [ TOGGLE ]
#define CLOUD_DAYc     vec3(0.8,0.9,0.95)* 1.0
#define CLOUD_DUSKc    vec3(0.7,0.49,0.39)* 1.0
#define CLOUD_NIGHTc   vec3(0.14,0.18,0.31)* 1.0
#define CLOUD_RAINc    vec3(0.59,0.6,0.6)* 1.0
#define SHADOW_DAYc    vec3(0.25,0.4,0.475)
#define SHADOW_DUSKc   vec3(0.5,0.3,0.25)
#define SHADOW_NIGHTc  vec3(0.05,0.1,0.2)
#define SHADOW_RAINc   vec3(0.295,0.3,0.3)



#endif

