#version 120
#define PROCESSING_LIGHT_SHADER

/*
 * Default uniform variables automatically set by Processing.
 */
uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

/*
 * Custom uniform variables.
 * Passed from the sketch to the shader using the PShader 'set()' method.
 * Values may change due to user input.
 */
uniform sampler2D terrainTexture;
uniform float terrainWidth;
uniform float terrainHeight;
uniform float high;
uniform float low;
uniform vec3 terrainColorA;
uniform vec3 terrainColorB;

/*
 * Default attribute variables provided by Processing.
 */
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

/*
 * Variables to be passed from the vertex to the fragment sahder.
 */
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

// Color definitions
// vec3 BROWN = vec3(0.647059, 0.164706, 0.164706);
// vec3 KHAKI = vec3(0.623529, 0.623529, 0.372549);
// vec3 WHEAT = vec3(0.847059, 0.847059, 0.74902);
// vec3 SIENNA = vec3(0.556863, 0.419608, 0.137255);
vec3 LIGHTBLUE = vec3(0.74902, 0.847059, 0.847059);
vec3 LIGHTSTEELBLUE = vec3(0.560784, 0.560784, 0.737255);


void main() {

  vec4 position = vertex;

   vec2 coord = position.xz;
  if (coord.x<0.0) {
    coord.x=0.0;
  }
  if (coord.y<0.0) {
    coord.y=0.0;
  }

  /*
   * We use the texture2D() function to access the texture pixel values (aka 'texels') of the
   * passed in sampler2D texture at the specified texture coordinates.
   */
  vec3 noiseTex = texture2D(terrainTexture, coord).xyz;

  // We calculate displaced position dependent on noise texture
  position.y = (low*noiseTex.x + high*noiseTex.y  ) * terrainHeight;
  position.x *= terrainWidth;
  position.z *= terrainWidth;// * (-1.0); // negative z-direction

  gl_Position = transform * position;

  /*
   * Calculations according to the 'Processing Shader Tutorial'.
   * cf. https://processing.org/tutorials/pshader/
   */
  vertNormal = normalize(normalMatrix * normal);
  vec3 ecVertex = vec3(modelview * position);
  vertLightDir = normalize(lightPosition.xyz - ecVertex);

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  /*
   * We calulate the color of the terrain mesh and pass the result to the fragment stage.
   * 'terrainColorA' and 'terrainColorB' may be changed dynamically by user input.
   */
  vertColor.rgb = mix(terrainColorA, terrainColorB, noise1(position.y + high)) + mix(LIGHTBLUE, LIGHTSTEELBLUE, noise1(position.y + low));;
  // vertColor.rgb = mix(KHAKI, SIENNA, noise1(position.y + high))
  vertColor.a = 1.0;

}
