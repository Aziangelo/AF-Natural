$input a_position, a_texcoord0
$output v_texcoord0, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
    v_texcoord0 = a_texcoord0;
    v_wpos = mul(u_model[0], vec4(a_position, 1.0)).xyz;
    gl_Position = mul(u_modelViewProj, mul(CubemapRotation, vec4(a_position, 1.0)));
}
