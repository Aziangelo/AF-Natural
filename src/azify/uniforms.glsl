#ifndef UNIFORMS
#define UNIFORMS

uniform vec4 SkyColor;
uniform vec4 FogColor;
uniform vec4 FogControl;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ColorBased;
uniform vec4 ChangeColor;
uniform vec4 UseAlphaRewrite;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 MatColor;
uniform vec4 OverlayColor;
uniform vec4 TileLightColor;
uniform vec4 MultiplicativeTintColor;
uniform vec4 ActorFPEpsilon;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 LightDiffuseColorAndIntensity;
uniform vec4 HudOpacity;
uniform vec4 UVAnimation;
uniform vec4 TextureDimensions;
uniform mat4 CubemapRotation;
uniform mat4 Bones[8];

#endif