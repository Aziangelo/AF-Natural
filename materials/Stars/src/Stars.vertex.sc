$input a_color0, a_position
$output v_color0

#include <bgfx_shader.sh>

void main() {
    vec4 tmpvar;
    tmpvar.w = 1.0;
    tmpvar.xyz = a_position;
    tmpvar.xyz *= vec3(15.0,15.0,15.0);
    v_color0 = a_color0;
    v_color0 *= 35.0;
    gl_Position = mul(u_modelViewProj, vec4(tmpvar.xyz, 1.0));
}