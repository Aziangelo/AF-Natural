vec4 a_color0 : COLOR0;
vec4 a_normal : NORMAL;
vec3 a_position : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

#if BGFX_SHADER_LANGUAGE_HLSL
int a_indices : BLENDINDICES;
#else
float a_indices : BLENDINDICES;
#endif

vec4 i_data0 : TEXCOORD7;
vec4 i_data1 : TEXCOORD6;
vec4 i_data2 : TEXCOORD5;

vec4 v_color0 : COLOR0;
vec4 v_fog : COLOR2;
vec4 v_light : COLOR3;
centroid vec2 v_texcoord0 : TEXCOORD0;
vec2          v_lightmapUV : TEXCOORD1;

vec4 v_colors     : COLOR1;
vec4 v_skyMie     : COLOR5;
vec3 v_cpos       : POSITION1;
vec3 v_wpos       : POSITION2;