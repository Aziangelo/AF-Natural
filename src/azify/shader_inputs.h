#ifndef SHADER_INPUTS
 #define SHADER_INPUTS
 
/*
 𝗣𝗟𝗘𝗔𝗦𝗘 𝗥𝗘𝗔𝗗 (𝗥𝗘𝗔𝗗𝗠𝗘.𝘁𝘅𝘁) 𝗙𝗜𝗥𝗦𝗧 𝗕𝗘𝗙𝗢𝗥𝗘 𝗘𝗗𝗜𝗧𝗜𝗡𝗚! 
*/
#define AzifyNaturalv1.0

//  ||█▓▒▒░░░ OVERWORLD FUNCTIONS ░░░▒▒▓█||
/* Toggles */
//#define VINTAGE_TONE       // [ TOGGLE ]
#define WATER_GRADIENT     // [ TOGGLE ]
#define WATER_LINES        // [ TOGGLE ]
#define WATER_SUN_REFL     // [ TOGGLE ]
#define UNDERWATER_RAYS    // [ TOGGLE ]
//#define AMBIENT_OCCLUSION  // [ TOGGLE ] * add ao
#define CHUNK_ANIMATION    // [ TOGGLE ]
#define DIRECT_LIGHT       // [ TOGGLE ]
#define CAUSTICS           // [ TOGGLE ]
#define BLOCK_REFLECTION   // [ TOGGLE ]
#define FLOOR_REFLECTION   // [ TOGGLE ]
#define NORMALMAPS		  	 // [ TOGGLE ]
#define FOG                // [ TOGGLE ]

/* Adjustable Variables */
#define CLOUD_STEPS          1
#define wNORMAL_INTENSITY    0.0009
#define WATER_OPACITY        0.2
#define WATERGRAD_OPACITY    0.9
#define WATERGRAD_SMOOTHNESS 0.38
#define WATERLINE_INTENSITY  0.68
#define WATERLINE_OPACITY    0.55
/* NormalMaps */
#define METALLIC_BEVEL 0.00065
#define METALLIC_STREN 5.0
#define NORMALS_BEVEL  0.00010
#define NORMALS_STREN  4.0
#define WATER_BEVEL    0.00040
#define WATER_STREN    3.0

/* Overworld Colors */
#define DAYc     vec3(0.76,0.84,0.88)* 1.0
#define DUSKc    vec3(0.45,0.42,0.4)* 1.0
#define NIGHTc   vec3(0.2,0.25,0.4)* 1.0
#define D_RAINc  vec3(0.58,0.58,0.58)* 1.0
#define N_RAINc  vec3(0.35,0.38,0.4)* 1.0
#define CAVEc    vec3(0.1,0.15,0.2)* 1.0
#define UNWATERc vec3(0.7,0.8,0.9)* 1.0
/* Entity Colors
 * seperated color for more control! */
#define EDAYc   vec3(0.76,0.84,0.88)* 1.0
#define EDUSKc  vec3(0.74,0.765,0.8)* 0.55
#define ENIGHTc vec3(0.2,0.25,0.4)* 1.0
#define ERAINc  vec3(0.58,0.58,0.58)* 1.0
#define ECAVEc  vec3(0.1,0.15,0.2)* 1.0

/* DirLight Colors: 
 mDL - Highlight
 mDS - Shadow
 Overworld Dirlight Colors */
#define mDL_DAYc   vec3(1.0,0.9,0.8)* 1.0 
#define mDL_DUSKc  vec3(1.0,0.9,0.8)* 1.3
#define mDL_NIGHTc vec3(0.95,0.85,1.0)* 1.0
#define mDL_RAINc  vec3(0.8,0.8,0.8)* 1.0
#define mDS_DAYc   vec3(0.54,0.58,0.59)* 1.0
#define mDS_DUSKc  vec3(0.8,0.81,0.85)* 1.0
#define mDS_NIGHTc vec3(0.77,0.75,0.8)* 1.0
#define mDS_RAINc  vec3(0.7,0.7,0.7)* 1.0  
/* Nether Dirlight Color */
#define nDL_NETHc  vec3(0.74,0.78,0.79)* 1.0
#define nDS_NETHc  vec3(0.74,0.78,0.79)* 1.0
/* End Dirlight Color */
#define nDL_ENDc vec3(0.74,0.78,0.79)* 1.0 
#define nDS_ENDc vec3(0.74,0.78,0.79)* 1.0

/* Water Lines Colors */
#define wLINE_DAYc vec3(1.0,0.99,0.97)* 1.5
#define wLINE_NIGHTc vec3(1.0,0.9,0.95)* 0.17
 
/* Under Water Fog Color */
#define FOG_UNDERW_DAY   vec3(0.0,0.33,0.44)* 1.0
#define FOG_UNDERW_NIGHT vec3(0.02,0.14,0.26)* 1.0


//  ||█▓▒▒░░░ SKY FUNCTIONS ░░░▒▒▓█||
#define CLOUDS             // [ TOGGLE ]
//#define AURORA_BOREALIS  // [ TOGGLE ] [ BETA ]

/* Sky Colors 
SA - Upper Color
SB - Middle Color
SC - Below */
#define SA_DAY     vec3(0.14,0.35,0.5)* 1.0
#define SA_DUSK    vec3(0.2,0.23,0.4)* 1.0
#define SA_NIGHT   vec3(0.14,0.18,0.31)* 1.0
#define SA_RAIN_D  vec3(0.45,0.45,0.45)* 1.0
#define SA_RAIN_N  vec3(0.45,0.45,0.45)* 1.0
#define SB_DAY     vec3(0.95,1.0,0.9)* 0.75
#define SB_DUSK    vec3(1.0,0.45,0.23)* 1.0
#define SB_NIGHT   vec3(0.45,0.28,0.65)* 1.0
#define SB_RAIN_D  vec3(0.6,0.6,0.6)* 1.0
#define SB_RAIN_N  vec3(0.5,0.5,0.5)* 1.0
#define SC_DAY     vec3(0.2,0.4,0.5)* 1.0
#define SC_DUSK    vec3(0.6,0.4,0.3)* 1.0
#define SC_NIGHT   vec3(0.1,0.3,0.5) * 0.2
#define SC_RAIN_D  vec3(0.3,0.3,0.3)* 1.0
#define SC_RAIN_N  vec3(0.2,0.2,0.2)* 1.0

/* Aurora Colors */
#define AURA_C1  vec3(1.0,0.0,0.5)* 1.0
#define AURA_C2  vec3(0.0,1.0,0.5)* 1.0

/* Cloud Colors */
#define CLOUD_DAYc      vec3(0.9,0.95,1.05)* 1.0
#define CLOUD_DUSKc     vec3(0.9,0.7,0.4)* 1.0
#define CLOUD_NIGHTc    vec3(0.13, 0.11, 0.33)* 1.1
#define CLOUD_D_RAINc   vec3(0.59,0.6,0.6)* 1.0
#define CLOUD_N_RAINc   vec3(0.49,0.5,0.5)* 1.0
#define SHADOW_DAYc     vec3(0.15,0.35,0.5)* 0.9
#define SHADOW_DUSKc    vec3(0.5,0.3,0.25)* 0.7
#define SHADOW_NIGHTc   vec3(0.055, 0.067, 0.235)
#define SHADOW_D_RAINc  vec3(0.295,0.3,0.3)
#define SHADOW_N_RAINc  vec3(0.195,0.2,0.2)

#endif

