vec4 a_color0     : COLOR0;
vec3 a_position   : POSITION;
vec2 a_texcoord0  : TEXCOORD0;
vec2 a_texcoord1  : TEXCOORD1;

vec4 i_data0 : TEXCOORD7;
vec4 i_data1 : TEXCOORD6;
vec4 i_data2 : TEXCOORD5;

vec4          v_color0     : COLOR0;
vec4          v_fog        : COLOR2;
centroid vec2 v_texcoord0  : TEXCOORD0;
vec2          v_lightmapUV : TEXCOORD1;

vec4 v_worldColors	: COLOR4;
vec3 v_skyMie				: COLOR5;
vec4 v_ao						: COLOR3;
vec4 v_color2				: COLOR6;
vec4 v_color3				: COLOR7;
vec4 v_color4				: COLOR8;
vec4 v_nfog					: COLOR1;
vec3 v_newcolor			: NEWCOLOR1;
vec3 v_dhcol				: COLORED1;
vec3 v_dscol				: COLORED2;
vec3 v_cpos					: POSITION1;
vec3 v_wpos					: POSITION2;

// bools => floats
float v_wlus		: BOOL1;
float v_unwater	: BOOL2;
float v_nether	: BOOL3;
float v_water		: BOOL4;

vec4 v_wtime		: TIME0;
float v_ocave		: DETECT0;
