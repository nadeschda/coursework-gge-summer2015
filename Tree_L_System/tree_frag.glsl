#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

/*
 * Custom uniform variable.
 * Passed from the sketch to the shader using the PShader 'set()' method.
 */
uniform sampler2D barkTexture;

/*
 * Incoming variables.
 */
varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;
varying vec4 position;

void main() {

  /*
   * Calculations according to the 'Processing Shader Tutorial'.
   * cf. https://processing.org/tutorials/pshader/
   */
  vec3 direction = normalize(vertLightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.0, dot(direction, normal));

  /*
   * We calculate the final output color by sampling the applied texture and multiplying the
   * vertex color and the light intensity.
   */
  gl_FragColor = texture2D(barkTexture, vertTexCoord.st) * vertColor * vec4(intensity, intensity, intensity, 1);
}
