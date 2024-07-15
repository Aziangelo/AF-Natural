
**find <modify.glsl> file you can edit there and modify the shader.**

**Please be informed that this is just a test feature for this shader, and some functions might be limited.**

### You can edit the following:
- Enable and disable functions
- Increase and decrease some functions
- Change any colors of the functions
- Enable some beta features

### Editing Tutorial:

**Enable and Disable:**
```
//#define color  // This is disabled
#define color   // This is enabled
```
- Simply add `//` to disable a function, and remove `//` to enable it. However, be cautious, as not all code can be disabled. For example:
``` 
#define color 1.0  // This function can't be disabled because it has a numeric indicator
#define color vec3(1.0, 1.0, 1.0)  // This is highly inadvisable to disable
```
- To help, I will add an indicator like `[toggle]` if a function can be both disabled and edited. For example:
```
#define color 1.0  // [toggle]
```
- This means the function can be disabled and edited. If `[toggle]` is not mentioned, do not disable the function.

**Color Values:**
```
vec3(RED, GREEN, BLUE) * BRIGHTNESS
```
- Values should be decimal (e.g., `1.0`, not `1`).
- `1.0` is the maximum (you can go higher, but only in specific situations), and `0.0` is the minimum.

---

Lmao, I hope my tutorial is understandable for you. Peace!  
Have a nice day!  
\- Azi Angelo