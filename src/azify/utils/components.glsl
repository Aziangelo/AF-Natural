#ifndef COMPONENTS
#define COMPONENTS

/*
World detection of the shader
- water
- underwater 
- nether 
- end 

NOTE: Dont Edit! as it breaks the shaders calculations.
*/

/* Under Water Detection */
bool detectUnderwater(vec3 fc, vec2 fadc) {
  return fadc.x==0.0 && fadc.y<0.8 && (fc.b>fc.r || fc.g>fc.r);
}

/* Nether Detection 
-- Originally from (Newb Shader) by Deven */
bool detectNether(vec3 fc, vec2 fadc) {
  float expectedFogX = 0.029 + (0.09*fadc.y*fadc.y);
  bool netherFogCtrl = (fadc.x<0.14  && abs(fadc.x-expectedFogX) < 0.02);
  bool netherFogCol = (fc.r+fc.g)>0.0;
  bool underLava = fadc.x == 0.0 && fc.b == 0.0 && fc.g < 0.18 && fc.r-fc.g > 0.1;
  return (netherFogCtrl && netherFogCol) || underLava;
}

/* Mixed Nether And Under Water detections */
void getWorldDetections(inout bool getUnWater, inout bool getNether, in vec4 fc, in vec4 fadc) {
  getUnWater = detectUnderwater(fc.rgb, fadc.xy);
  getNether = detectNether(fc.rgb, fadc.xy);
}

/* Undewater Occlusion Detection */
bool getWaterLus(vec2 uv, vec3 cpos) {
  return (uv.y < 0.92384 && abs((2.0 * cpos.y - 15.0) / 16.0 - uv.y) < 0.00002 && uv.y > 0.187);
}

#endif
