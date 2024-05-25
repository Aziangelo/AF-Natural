$input v_texcoord0, v_position

#include <bgfx_shader.sh>

uniform vec4 SunMoonColor;
uniform vec4 FogColor;
uniform vec4 FogAndDistanceControl;

SAMPLER2D(s_SunMoonTexture, 0);

#define detect(a,b,x) clamp(((x)-(a))/((b)-(a)), 0.0, 1.0)
#define disf ((FogAndDistanceControl.w-80.0)/112.0)

#define AFnether detect( 0.24, 0.13 - ( 0.08 * disf ), FogAndDistanceControl.x )
#define AFrain detect( 0.75 - ( 0.15 * disf ), 0.24, FogAndDistanceControl.x ) * ( 1.0 -  AFnether )

#define AFnight mix( detect( 0.65, 0.02, FogColor.r ), detect( 0.15, 0.01, FogColor.g ), AFrain )
#define AFdusk mix( detect( 1.0, 0.0, FogColor.b ), detect( 0.25, 0.15, FogColor.g ), AFrain )

#define timecycle( a, b, c ) mix( mix( a, b, AFdusk ), c, AFnight )

void main() {
    lowp vec4 albedo0;
    lowp vec4 diffuse_2;
    diffuse_2 = SunMoonColor;
    //diffuse_2 = (SunMoonColor * texture2D (s_SunMoonTexture, v_texcoord0));
    albedo0 = diffuse_2;
    albedo0.xyz *= vec3(0);
    mediump vec3 albedo1;
    albedo1 = mix(vec3(1.0,0.76,0.2)+0.01, vec3(0.8,1.0,1.2), AFnight);
    mediump vec3 albedo2;
    albedo2 = albedo1 * smoothstep(0.8, 0.9, 1.0 - length(v_position.xz * 5.5));
    albedo2 += exp(-length(v_position.xz * mix(2.0,1.7, AFnight))) * albedo1 * mix(mix(0.23, 0.18, AFdusk), 0.3,AFnight);
    albedo0.xyz = albedo2;
    if ((FogAndDistanceControl.x <= 0.0)) {
      albedo0.xyz = albedo2;
    }
    albedo0.w = (1.0 * smoothstep(1.0, 0.0, AFrain));
    gl_FragColor = albedo0;
}