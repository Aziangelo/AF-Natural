$input a_color0, a_position
#ifdef GEOMETRY_PREPASS
    $input a_texcoord0
    #ifdef INSTANCING
        $input i_data0, i_data1, i_data2
    #endif
#endif

$output v_color0, v_position, v_worldpos, skypos
#ifdef GEOMETRY_PREPASS
    $output v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>

uniform vec4 SkyColor;
uniform vec4 FogColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;

void main() {
#if defined(OPAQUE)
    //Opaque
  // Shader Name: AzíFy Natural
  // Min Version: v1.0r
  // Original Made By: AzìAngelō
  // Please Do Not Steal This Shader/Code!!!
  // If you intend to use some codes in this shader contact and reach me in Discord!!!
  /*
    vec4 tmpvar;
    tmpvar.w = 1.0;
    tmpvar.xyz = a_position;
    tmpvar.y -= length(tmpvar.xyz);*/
  
    vec4 tmpvar;
    vec4 k1;
    tmpvar.w = 1.0;
    tmpvar.xyz = a_position;
    k1.xzw = tmpvar.xzw;
    k1.y = (a_position.y - sqrt(dot (a_position.xz, a_position.xz) * 17.5));
    
    skypos = (k1.xyz + vec3(0.0, 0.128, 0.0));
    v_position = a_position;
    v_worldpos = mul(u_model[0], k1).xyz;
    v_color0 = mix(SkyColor, FogColor, a_color0.x);
    gl_Position = mul(u_modelViewProj, k1);
#else
    //Fallback
    v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
    gl_Position = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}