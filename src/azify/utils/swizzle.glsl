#ifndef SWIZ
#define SWIZ

// simplify variable names
#define time ViewPositionAndTime.w 

// clamping
#define str(x)    clamp(x,0.0,1.0) 
#define lights(x) ((x).r+(x).g+(x).b)/3.0 

// power
#define pw2x(x) pow(x,2.0) 
#define pw3x(x) pow(x,3.0) 

// exception
#define inv(x)      (1.0-x) 
#define inv2(x,y)   (1.0-max(x,y))
#define inv3(x,y,z) (1.0-max(max(x, y), z))

// vector
vec2 vect2(float x) {
  return vec2(x,x);
}
vec3 vect3(float x) {
  return vec3(x,x,x);
}
vec4 vect4(float x) {
  return vec4(x,x,x,x);
}


#endif