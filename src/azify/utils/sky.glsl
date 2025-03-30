#ifndef SKY
 #define SKY
 
vec3 calculateSky(vec3 color, vec3 vpos, float mpos, vec4 wtime) {
vpos.y = max(vpos.y, 0.0);
vec3 RainC1 = mix(SA_RAIN_D, SA_RAIN_N, wtime.z);
vec3 RainC2 = mix(SB_RAIN_D, SB_RAIN_N, wtime.z);
vec3 RainC3 = mix(SC_RAIN_D, SC_RAIN_N, wtime.z);
 vec3 albedo1;
albedo1 = mix(SA_DAY, SA_DUSK, wtime.y);
albedo1 = mix(albedo1, SA_NIGHT, wtime.z);
albedo1 = mix(albedo1, RainC1, wtime.w);
 vec3 albedo2;
albedo2 = mix(SB_DAY, SB_DUSK, wtime.y);
albedo2 = mix(albedo2, SB_NIGHT, wtime.z);
albedo2 = mix(albedo2, RainC2, wtime.w);
 vec3 albedo3;
albedo3 = mix(SC_DAY, SC_DUSK, wtime.y);
albedo3 = mix(albedo3, SC_NIGHT, wtime.z);
albedo3 = mix(albedo3, RainC3, wtime.w);
 vec3 albedo4;
albedo4 = vec3(0.0,0.0,0.0);
albedo4 += (albedo2 * exp(-vpos.y * 6.0));
albedo4 += (albedo1 * (1.0 - exp(-vpos.y * 10.0)));
albedo4 = mix(albedo4, albedo3, (1.0 - exp(mpos * 8.0)));
color = albedo4-0.18;
return color;
}
 
 #endif