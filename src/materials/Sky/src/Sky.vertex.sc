$input a_color0, a_position
#ifdef GEOMETRY_PREPASS
    $input a_texcoord0
    #ifdef INSTANCING
        $input i_data0, i_data1, i_data2
    #endif
#endif

$output v_color0
$output v_skypos, v_viewPos, v_minPos
#ifdef GEOMETRY_PREPASS
    $output v_texcoord0, v_normal, v_worldPos, v_prevWorldPos
#endif

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
#if defined(OPAQUE)
  //Opaque
  vec4 pos;
  pos.w = 1.0;
  pos.xyz = a_position;
  pos.y = a_position.y - sqrt(dot(a_position.xz, a_position.xz) * 360.0);
  
  vec3 sPos = pos.xyz + vec3(0.0, 0.128, 0.0);
  
  v_viewPos = normalize(sPos);
  v_viewPos.y -= 0.0128;
  v_minPos = min(v_viewPos.y, 0.005);
  v_viewPos.y = max(v_viewPos.y, 0.0);
  v_skypos = sPos;
  v_color0 = mix(SkyColor, FogColor, a_color0.x);
  
  gl_Position = mul(u_modelViewProj, pos);
    
#else
  //Fallback
  v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
  gl_Position = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}