$input a_color0, a_position, a_texcoord0

$output v_color0, v_texcoord0
$output v_skypos

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
#ifndef OPAQUE
  //Opaque
  vec3 pos;
  pos.xyz = a_position;
  pos.y -= 18.0*a_color0.r*a_color0.r;
  /*
  pos.y = a_position.y - sqrt(dot(a_position.xz, a_position.xz) * 360.0);*/
  vec3 viewPos = normalize(pos.xyz);
  float minPos = min(viewPos.y, 0.005);
  viewPos.y = max(viewPos.y, 0.0);
  
  //v_skypos = pos.xyz + vec3(0.0, 0.128, 0.0);
  v_skypos = mul(u_model[0], vec4(pos, 1.0)).xyz;
  v_color0 = vec4(calculateSky(a_color0.rgb,viewPos,minPos),1.0);
  v_texcoord0 = a_texcoord0;
  gl_Position = mul(u_modelViewProj, vec4(pos,1.0));
    
#else
  //Fallback
  v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
  gl_Position = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}