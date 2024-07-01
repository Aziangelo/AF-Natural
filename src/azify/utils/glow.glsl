#ifndef GLOW
#define GLOW

// c.a > max && c.a < min
// 252 and 253
#define GLOW_PIXEL(c)  c.a>0.988 && c.a<0.993
// 85% Opacity 216 and 217
#define METAL_PIXEL(c) c.a>0.846 && c.a<0.85

#endif