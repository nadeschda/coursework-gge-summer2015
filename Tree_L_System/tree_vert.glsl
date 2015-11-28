#version 120
#define PROCESSING_TEXLIGHT_SHADER


/*
 * Default uniform variables automatically set by Processing.
 */
uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

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
varying vec3 ecNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;
varying vec4 position;


void main() {

  position = vertex;

  /*
   * Calculations according to the 'Processing Shader Tutorial'.
   * cf. https://processing.org/tutorials/pshader/
   */
  vec3 ecVertex = vec3(modelview * position);
  ecNormal = normalize(normalMatrix * normal);
  vertLightDir = normalize(lightPosition.xyz - ecVertex);

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  /*
   * Simply pass the vertex color on to the fragment stage.
   */
  vertColor = color;

  gl_Position = transform * position;

}
