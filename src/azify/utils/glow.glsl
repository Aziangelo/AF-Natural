#ifndef GLOW
#define GLOW

#define time ViewPositionAndTime.w
#ifdef ALPHA_TEST
  #define GLOW_PIXEL(C) C.a>0.9875 && C.a<0.993
#else
  #define GLOW_PIXEL(C) C.a>0.9875 && C.a<0.995
#endif

#endif