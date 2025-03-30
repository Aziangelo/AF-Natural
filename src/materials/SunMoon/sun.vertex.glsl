$input a_position, a_texcoord0
$output v_texcoord0, v_pos

#ifndef INSTANCING
#include <bgfx_shader.sh>
#endif

void main() {
#ifndef INSTANCING
  v_texcoord0 = a_texcoord0;
  vec3 pos = a_position;
  v_pos = pos * vec3(15.0,1.0,15.0);

  pos.xz *= 14.5;
  gl_Position = mul(u_modelViewProj, vec4(pos, 1.0));
#else
  gl_Position = vec4(0.0,0.0,0.0,0.0);
#endif
}