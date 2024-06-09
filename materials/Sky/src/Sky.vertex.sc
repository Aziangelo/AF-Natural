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

uniform vec4 SkyColor;
uniform vec4 FogColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;

#include <azify/shader_inputs.glsl>
#include <azify/utils/time.glsl>
#include <azify/utils/functions.glsl>

void main() {
#if defined(OPAQUE)

    vec4 tmpvar;
    vec4 k1;
    tmpvar.w = 1.0;
    tmpvar.xyz = a_position;
    k1.xzw = tmpvar.xzw;
    k1.y = (a_position.y - sqrt(dot (a_position.xz, a_position.xz) * 17.5));
    vec3 sPos  = (k1.xyz + vec3(0.0, 0.128, 0.0));
 
    v_viewPos = normalize(sPos);
    v_viewPos.y = (v_viewPos.y - 0.0128);
    v_minPos = min(v_viewPos.y, 0.005);
    v_viewPos.y = max(v_viewPos.y, 0.0);
    v_skypos = sPos;
    v_color0 = mix(SkyColor, FogColor, a_color0.x);
    gl_Position = mul(u_modelViewProj, k1);
#else
    //Fallback
    v_color0 = vec4(0.0, 0.0, 0.0, 0.0);
    gl_Position = vec4(0.0, 0.0, 0.0, 0.0);

#endif
}