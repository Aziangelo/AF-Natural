#ifndef SHADER_INPUTS
 #define SHADER_INPUTS
 #define AzifyNaturalv1.0

/*
Please Read Instructions Below!
*/

/* ------- OVERWORLD FUNCTIONS ------- */
/* Toggles */
//#define VINTAGE_TONE       // [ TOGGLE ]
#define WATER_GRADIENT     // [ TOGGLE ]
//#define WATER_LINES        // [ TOGGLE ]
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

/* OPTIONS VARIABLES */
#define TONE_MAPPING_MODE 1 // [1]Simple [2]Vintage

/* Adjustable Variables */
#define CLOUD_STEPS          6
#define wNORMAL_INTENSITY    0.0009
#define WATER_OPACITY        0.2
#define WATERGRAD_OPACITY    0.9
#define WATERGRAD_SMOOTHNESS 0.38
#define WATERLINE_INTENSITY  0.68
#define WATERLINE_OPACITY    0.55
#define GLOW_BRIGHTNESS      0.8
/* NormalMaps */
#define METALLIC_BEVEL 0.0002
#define METALLIC_STREN 1.0
#define NORMALS_BEVEL  0.020
#define NORMALS_STREN  2.5
#define WATER_BEVEL    0.001
#define WATER_STREN    5.0

/* Overworld Colors */
#define DAYc     vec3(0.76,0.84,0.88)
#define DUSKc    vec3(0.45,0.42,0.4)
#define NIGHTc   vec3(0.2,0.25,0.4)
#define D_RAINc  vec3(0.58,0.58,0.58)
#define N_RAINc  vec3(0.35,0.38,0.4)
#define CAVEc    vec3(0.1,0.15,0.2)
#define CAVEOUTc vec3(0.8,0.93,1.0)* 0.7
#define UNWATERc vec3(0.7,0.8,0.9)* 0.3
#define NETHERc  vec3(0.5,0.45,0.4)* 0.5
/* Entity Colors
-- seperated color for more control! */
#define EDAYc   vec3(0.76,0.84,0.88)
#define EDUSKc  vec3(0.74,0.765,0.8)* 0.55
#define ENIGHTc vec3(0.2,0.25,0.4)
#define D_ERAINc  vec3(0.58,0.58,0.58)
#define N_ERAINc  vec3(0.35,0.38,0.4)
#define ECAVEc  vec3(0.1,0.15,0.2)

/* DirLight Colors: 
 mDL - Highlight
 mDS - Shadow
 Overworld Dirlight Colors */
#define mDL_DAYc   vec3(1.0,0.9,0.8) 
#define mDL_DUSKc  vec3(1.0,0.9,0.8)* 1.3
#define mDL_NIGHTc vec3(0.95,0.85,1.0)
#define mDL_RAINc  vec3(1.0,1.0,1.0)
#define mDS_DAYc   vec3(0.44,0.48,0.49)
#define mDS_DUSKc  vec3(0.5,0.51,0.55)
#define mDS_NIGHTc vec3(0.57,0.55,0.6)
#define mDS_RAINc  vec3(0.7,0.7,0.7)  


/* Water Lines Colors */
#define wLINE_DAYc vec3(1.0,0.99,0.97)* 1.5
#define wLINE_NIGHTc vec3(1.0,0.9,0.95)* 0.17
 
/* Under Water Fog Color */
#define FOG_UNDERW_DAY   vec3(0.0,0.33,0.44)
#define FOG_UNDERW_NIGHT vec3(0.02,0.14,0.26)


/* -------- SKY FUNCTIONS ---------- */
#define CLOUDS             // [ TOGGLE ]
//#define AURORA_BOREALIS  // [ TOGGLE ] [ BETA ]

/* Sky Colors 
SA - Upper Color
SB - Middle Color
SC - Below */
#define SA_DAY     vec3(0.14,0.35,0.5)
#define SA_DUSK    vec3(0.2,0.23,0.4)
#define SA_NIGHT   vec3(0.14,0.18,0.31)
#define SA_RAIN_D  vec3(0.45,0.45,0.45)
#define SA_RAIN_N  vec3(0.45,0.45,0.45)
#define SB_DAY     vec3(0.75,0.8,0.7)
#define SB_DUSK    vec3(1.0,0.45,0.23)
#define SB_NIGHT   vec3(0.45,0.28,0.65)
#define SB_RAIN_D  vec3(0.6,0.6,0.6)
#define SB_RAIN_N  vec3(0.5,0.5,0.5)
#define SC_DAY     vec3(0.35,0.4,0.5)
#define SC_DUSK    vec3(0.6,0.4,0.3)
#define SC_NIGHT   vec3(0.1,0.3,0.5)* 0.2
#define SC_RAIN_D  vec3(0.3,0.3,0.3)
#define SC_RAIN_N  vec3(0.2,0.2,0.2)

/* Aurora Colors */
#define AURA_C1  vec3(1.0,0.0,0.5)
#define AURA_C2  vec3(0.0,1.0,0.5)

/* Cloud Colors */
#define CLOUD_DAYc      vec3(0.98,0.99,1.0)
#define CLOUD_DUSKc     vec3(0.9,0.7,0.4)
#define CLOUD_NIGHTc    vec3(0.23,0.21,0.43)
#define CLOUD_D_RAINc   vec3(0.6,0.6,0.6)
#define CLOUD_N_RAINc   vec3(0.49,0.5,0.5)
#define SHADOW_DAYc     vec3(0.27,0.38,0.48)
#define SHADOW_DUSKc    vec3(0.5,0.3,0.25)* 0.7
#define SHADOW_NIGHTc   vec3(0.055,0.067,0.23)
#define SHADOW_D_RAINc  vec3(0.295,0.3,0.3)
#define SHADOW_N_RAINc  vec3(0.195,0.2,0.2)

#endif

/* PACK CONFIG */
#ifdef BETA_AURORA
  #define AURORA_BOREALIS
#endif

#ifdef VINTAGE_FILM_MODE
 #define VINTAGE_TONE
#endif


/*
---

**This is the file you can edit to modify the shader.**

**Please be informed that this is just a test feature for this shader, and some functions might be limited.**

### You can edit the following:
- Enable and disable functions
- Increase and decrease some functions
- Change any colors of the functions
- Enable some beta features

### Editing Tutorial:

**Enable and Disable:**
```
//#define color  // This is disabled
#define color   // This is enabled
```
- Simply add `//` to disable a function, and remove `//` to enable it. However, be cautious, as not all code can be disabled. For example:
``` 
#define color 1.0  // This function can't be disabled because it has a numeric indicator
#define color vec3(1.0, 1.0, 1.0)  // This is highly inadvisable to disable
```
- To help, I will add an indicator like `[toggle]` if a function can be both disabled and edited. For example:
```
#define color 1.0  // [toggle]
```
- This means the function can be disabled and edited. If `[toggle]` is not mentioned, do not disable the function.

**Color Values:**
```
vec3(RED, GREEN, BLUE) * BRIGHTNESS
```
- Values should be decimal (e.g., `1.0`, not `1`).
- `1.0` is the maximum (you can go higher, but only in specific situations), and `0.0` is the minimum.

---

Lmao, I hope my tutorial is understandable for you. Peace!  
Have a nice day!  
\- Azi Angelo
*/