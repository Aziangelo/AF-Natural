$input v_texcoord0, v_pos

#include <bgfx_shader.sh>
#include <azify/core.sh>
uniform vec4 SunMoonColor;

SAMPLER2D(s_SunMoonTexture, 0);

void main() {
	vec3 SunColorCC = mix(vec3(1.0, 0.76, 0.2) + 0.01, vec3(0.8, 1.0, 1.2), AFnight);
	vec2 posScaled = v_pos.xz * mix(1.5, 1.7, AFnight);
	vec3 albedo2 = SunColorCC * smoothstep(0.7, 0.9, 1.0 - length(v_pos.xz * 4.0));
	albedo2 += exp(-length(posScaled)) * SunColorCC * mix(mix(0.2, 0.3, AFdusk), 0.3, AFnight);
	
	vec4 albedo0 = SunMoonColor * texture2D(s_SunMoonTexture, v_texcoord0);
	albedo0.xyz = (FogAndDistanceControl.x <= 0.0) ? albedo2 : albedo2;
	albedo0.w = smoothstep(1.0, 0.0, AFrain);
	
	gl_FragColor = albedo0;
}