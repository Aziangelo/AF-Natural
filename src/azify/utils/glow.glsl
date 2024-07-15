#ifndef GLOW
#define GLOW

// c.a > max && c.a < min
// 98% Opacity 247 and 250
bool GLOW_PIXEL(vec4 c) {
  return c.a>0.968 && c.a<0.980;
}
// 85% Opacity 216 and 217
bool METAL_PIXEL(vec4 c) {
  return c.a>0.8469 && c.a<0.851;
}

#endif // GLOW
