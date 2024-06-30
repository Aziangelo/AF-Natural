$input a_position, a_texcoord0
$output v_texcoord0, v_pos

#include <bgfx_shader.sh>

void main() {
    vec4 tmpvar_1;
    tmpvar_1.w = 1.0;
    v_texcoord0 = a_texcoord0;
    v_pos = a_position;
    v_pos *= vec3(15.0,1.0,15.0);
    tmpvar_1.xyz = v_pos;
    v_texcoord0 = a_texcoord0;
    gl_Position = mul(u_modelViewProj, vec4(tmpvar_1.xyz, 1.0));
}