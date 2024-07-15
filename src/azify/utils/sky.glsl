#ifndef SKY
 #define SKY
 
vec3 calculateSky(vec3 color, vec3 vpos, float mpos) {
vec3 RainC1 = mix(SA_RAIN_D, SA_RAIN_N, AFnight);
vec3 RainC2 = mix(SB_RAIN_D, SB_RAIN_N, AFnight);
vec3 RainC3 = mix(SC_RAIN_D, SC_RAIN_N, AFnight);
 vec3 albedo1;
albedo1 = mix(SA_DAY, SA_DUSK, AFdusk);
albedo1 = mix(albedo1, SA_NIGHT, AFnight);
albedo1 = mix(albedo1, RainC1, AFrain);
 vec3 albedo2;
albedo2 = mix(SB_DAY, SB_DUSK, AFdusk);
albedo2 = mix(albedo2, SB_NIGHT, AFnight);
albedo2 = mix(albedo2, RainC2, AFrain);
 vec3 albedo3;
albedo3 = mix(SC_DAY, SC_DUSK, AFdusk);
albedo3 = mix(albedo3, SC_NIGHT, AFnight);
albedo3 = mix(albedo3, RainC3, AFrain);
 vec3 albedo4;
albedo4 = vec3(0.0,0.0,0.0);
albedo4 += (albedo2 * exp(-vpos.y * 6.0));
albedo4 += (albedo1 * (1.0 - exp(-vpos.y * 10.0)));
albedo4 = mix(albedo4, albedo3, (1.0 - exp(mpos * 8.0)));
color = albedo4-0.18;
return color;
}
 
 #endif