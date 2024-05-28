$input v_texcoord0, v_posTime

#include <bgfx_shader.sh>

SAMPLER2D(s_MatTexture, 0);

void main() {
  vec4 diffuse = texture2D(s_MatTexture, v_texcoord0);

  // end sky gradient
  vec3 color = vec3(1.0);

  // stars
 // color += 2.8*diffuse.rgb;

  gl_FragColor = vec4(color, 1.0);
}
