$input v_texcoord0, v_pos

#ifndef INSTANCING
#include <bgfx_shader.sh>
#include <azify/core.sh>
uniform vec4 SunMoonColor;
SAMPLER2D_AUTOREG(s_SunMoonTexture);
#endif

void main() {
#ifndef INSTANCING
  vec4 color = texture2D(s_SunMoonTexture, v_texcoord0);
  color.rgb *= SunMoonColor.rgb;
  vec4 wtime = getTime();

	vec3 SunColorCC = mix(vec3(1.0, 0.76, 0.2) + 0.01, vec3(0.8, 1.0, 1.2), wtime.z);
	vec2 scale = v_pos.xz * mix(1.5, 1.7, wtime.z);
	vec3 albedo2 = SunColorCC * smoothstep(0.7, 0.9, 1.0 - length(v_pos.xz * 4.0));
	albedo2 += exp(-length(scale)) * SunColorCC * mix(mix(0.2, 0.3, wtime.y), 0.3, wtime.z);
	
	color = SunMoonColor * texture2D(s_SunMoonTexture, v_texcoord0);
	color.xyz = (FogAndDistanceControl.x <= 0.0) ? albedo2 : albedo2;
	color.w = smoothstep(1.0, 0.0, wtime.w);
  gl_FragColor = color;
#else
  gl_FragColor = vec4(0.0,0.0,0.0,0.0);
#endif
}