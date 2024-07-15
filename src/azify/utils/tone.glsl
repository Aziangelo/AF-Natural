#ifndef TONES
#define TONES

/*
Overall Color Customization of the Shader.
NOTE: Edit at your own RISK!
*/

/* Luma / GrayScale */
float gray(vec3 color) {
    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
    return gray;
}

#if TONE_MAPPING_MODE == 1
/* Simple Tone Mapping */
vec3 AzifyColors(vec3 x) {
 float 
 a = 5.55, // 5.0
 b = 0.03, // 0.3
 c = 3.60,
 d = 0.40,
 e = 0.50;
  return str((x*(a*x+b))/(x*(c*x+d)+e));
}

#elif TONE_MAPPING_MODE == 2
/* Advanced Cinematic Tone Mapping */
vec3 AzifyColors(vec3 c) {
  vec3 sepia;
  sepia.r = dot(c, vec3(0.393,0.769,0.189));
  sepia.g = dot(c, vec3(0.349,0.686,0.168));
  sepia.b = dot(c, vec3(0.272,0.534,0.131));
  float ctr = 1.2; // contrast
  sepia = ((sepia-0.5)*max(ctr,0.0))+0.5;
  sepia = str(sepia);

  // white balance
  //sepia = sepia/(sepia+vec3(1.0));
  float bf = 0.75; // blend [1.0]no color [0.3]more color
  return mix(c, sepia, bf);
}
#endif // TONE_MAPPING_MODE

#endif // TONES