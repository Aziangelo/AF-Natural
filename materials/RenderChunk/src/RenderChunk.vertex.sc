$input a_color0, a_position, a_texcoord0, a_texcoord1
#ifdef INSTANCING
    $input i_data0, i_data1, i_data2
#endif
$output v_color0, v_fog, v_texcoord0, v_lightmapUV
$output v_colors, v_skyMie, v_color1, v_color2, v_color3, v_color4, v_RainFloorReflect
$output v_cpos, v_wpos

#include <bgfx_shader.sh>
#include <azify/core.sh>

void main() {
    mat4 model;
#ifdef INSTANCING
    model = mtxFromCols(i_data0, i_data1, i_data2, vec4(0, 0, 0, 1));
#else
    model = u_model[0];
#endif

    vec3 worldPos = mul(model, vec4(a_position, 1.0)).xyz;
    vec4 color;
#ifdef CHUNK_ANIMATION
  float bI = 7.5;
  float bS = 1.2;
  float bX = abs(sin(RenderChunkFogAlpha.x * bS * 3.14159));
  float fogEffect = 600.0 * pow(RenderChunkFogAlpha.x, 3.0);
  worldPos.y += bI * bX - fogEffect;
#endif // CHUNK_ANIMATION

    color = a_color0;
    vec3 modelCamPos = (ViewPositionAndTime.xyz - worldPos);
    float camDis = length(modelCamPos);
    vec4 fogColor;
    fogColor.rgb = FogColor.rgb;
    fogColor.a = clamp(((((camDis / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) -
        FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x)), 0.0, 1.0);

#ifdef TRANSPARENT
    if(a_color0.a < 0.95) {
        color.a = mix(a_color0.a, 1.0, clamp((camDis / FogAndDistanceControl.w), 0.0, 1.0));
    };
#endif

    v_texcoord0 = a_texcoord0;
    v_lightmapUV = a_texcoord1;
    v_color0 = color;
    v_fog = fogColor;
    gl_Position = mul(u_viewProj, vec4(worldPos, 1.0));
}
