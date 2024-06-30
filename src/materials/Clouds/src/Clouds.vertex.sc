$input a_color0, a_position
#ifdef INSTANCING
  $input i_data0, i_data1, i_data2, i_data3
#endif
$output v_color0
#if defined(TRANSPARENT)
  $output v_color1, v_color2, v_fogColor, v_cpos
#endif

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
#ifdef TRANSPARENT
#ifdef INSTANCING
  mat4 model = mtxFromCols(i_data0, i_data1, i_data2, i_data3);
#else
  mat4 model = u_model[0];
#endif
  float t = ViewPositionAndTime.w;
  vec3 pos = a_position;
  vec4 color;

    pos.xz = pos.xz - 32.0;
    pos.y *= 0.01;
    vec3 worldPos;
    worldPos.x = pos.x*model[0][0];
    worldPos.z = pos.z*model[2][2];
    #if BGFX_SHADER_LANGUAGE_GLSL
      worldPos.y = pos.y+model[3][1];
    #else
      worldPos.y = pos.y+model[1][3];
    #endif

    float fade = clamp(2.0-2.0*length(worldPos.xyz)*0.0022, 0.0, 1.0);
    float len = length(worldPos.xz)*0.01;
    worldPos.y -= len*len*clamp(0.2*worldPos.y, -1.0, 1.0);
    worldPos.y -= 1.5*color.a*3.3;
    color.a *= 1.0;
    color.a *= fade;
    color = vec4(worldPos, fade);
    v_color0 = color;
    v_cpos = worldPos;
    gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
#else
  v_color0 = vec4(0.0,0.0,0.0,0.0);
  gl_Position = vec4(0.0,0.0,0.0,0.0);
#endif
}
