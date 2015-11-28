#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

/*
 * Incoming variables.
 */
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;
varying vec3 ecVertex;

void main() {

  /*
   * Calculations according to the 'Processing Shader Tutorial'.
   * cf. https://processing.org/tutorials/pshader/
   */
  vec3 direction = normalize(vertLightDir);
  vec3 normal = normalize(vertNormal);
  vec3 intensity = vec3(max(0.0, dot(direction, normal)));

  /*
   * The final output color.
   */
  gl_FragColor = vertColor * vec4(intensity, 1);;
}
