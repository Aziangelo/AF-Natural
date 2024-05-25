$input v_color0

#include <bgfx_shader.sh>

uniform vec4 StarsColor;

void main() {
  vec4 starColor;
  vec4 addB;
  addB = v_color0;
  addB.x = max(addB.r,47.0);
  addB.y = max(addB.g,47.0);
  addB.z = max(addB.b,47.0);
  
  starColor.a = v_color0.w*39.5;

  starColor.rgb = (v_color0.rgb * (vec3(StarsColor.r * 55.0, StarsColor.g * 45.0, StarsColor.b * 20.3) * v_color0.w)) * addB.xyz;
    gl_FragColor = starColor;
}