/**
 * Branch
 *
 * A class to describe the shape of a branch segment in 3D.
 * 
 * A Branch object represents the building block of a tree, a bush, 
 * a plant, or a flower. Its geometry is defined as a cylinder that is drawn
 * from bottom-to-top. The bottom radius may differ from the radius at the top 
 * to allow for cone shapes, which would mimic the narrowing of branch segments.
 */

class Branch {
  int DETAIL = 10;
  float topRadius;
  float bottomRadius;
  float highness;
  PShape body;
  PShape topCap;
  PGraphics barkTexture;
  PShader treeShader;


  /* 
   * Constructor. 
   * 
   * Creates the cylindrical shape of a branch segment and applies a texture.
   * Furthermore, loads the specified shader.
   *
   * The algorithm to build the shape is borrowed from the Processing shader 
   * tutorial: https://processing.org/tutorials/pshader/
   */
  Branch(float r1, float r2, float h) {
    barkTexture = createBarkTexture(int(h), int(h), P3D);
    bottomRadius = r1;
    topRadius = r2;
    highness = h;

    textureMode(NORMAL);
    body = createShape();
    body.setTexture(barkTexture);

    body.beginShape(QUAD_STRIP);
    for (int i = 0; i <= DETAIL; i++) {
      float angle = TWO_PI / DETAIL;
      float x = cos(i * angle);
      float z = sin(i * angle);
      float u = float(i) / DETAIL;
      body.normal(x, 0, z);
      body.fill(190, 149, 111);
      body.vertex(x * topRadius, -highness, z * topRadius, u, 0);
      body.vertex(x * bottomRadius, 0, z * bottomRadius, u, 1);

      // Add this when using mode QUADS
      // x = sin((i+1) * angle);
      // z = cos((i+1) * angle);
      // body.normal(x, 0, z);
      // body.vertex(x * bottomRadius, 0, z * bottomRadius, u, 0);
      // body.vertex(x * topRadius, -highness, z * topRadius, u, 1);
    }
    body.endShape();

    topCap = createShape();
    topCap.setTexture(barkTexture);
    topCap.beginShape(TRIANGLE_FAN);
    // Center point
    topCap.vertex(0, -highness, 0, 0, 0);
    for (int i = 0; i <= DETAIL; i++) {
      float angle = TWO_PI / DETAIL;
      float x = cos(i * angle);
      float z = sin(i * angle);
      float u = float(i) / DETAIL;
      topCap.vertex(x * topRadius, -highness, z * topRadius, u, 0);
    }
    topCap.endShape();

    treeShader = loadShader("tree_frag.glsl", "tree_vert.glsl");
  }

  /**
   * Applies the shader, sets the accompanied uniform variables, 
   * and draws the shapes that form a branch segment.
   */
  void render() {
    pushMatrix();
    shader(treeShader);
    treeShader.set("barkTexture", barkTexture);
    shape(body);
    shape(topCap);
    popMatrix();
    resetShader();
  }




  /**
   * Creates a noise-generated texture to be applied to the branch shape.
   */
  PGraphics createBarkTexture(int w, int h, String renderer) {
    // Value to control smoothness of noise
    float noiseOff = 0.08; 
    barkTexture = createGraphics(w, h, renderer);
    barkTexture.beginDraw();
    for (int i=0; i<=w; i++) {
      for (int j=0; j<=h; j++) {
        // Calculate RED color component based on noise value
        float r = noise(j*noiseOff, i*noiseOff) * 129; 
        // Calculate GREEN color component based on noise value
        float g = noise(j*noiseOff, i*noiseOff) * 76;
        // Calculate BLUE color component based on noise value
        float b = noise(j*noiseOff, i*noiseOff) * 60;
        // Color the texture with the calculated values
        barkTexture.stroke(r, g, b);
        // Draw the texture
        barkTexture.point(i, j);
      }
    }
    barkTexture.endDraw();
    //barkTexture.save("bark_texture_noise.png");
    return barkTexture;
  }



  /* =================================================== */
  /*       METHODS BELOW ARE CURRENTLY NOT IN USE
  /* =================================================== */

  /**
   * Creates a noise-generated texture to be applied to the branch shape.
   * 
   * This version to generate a noise texture combines noise() and sin().
   * The algorithm is borrowed from 'Processing. A Programming Handbook 
   * for Visual Designers and Artists.' (page 132).
   */
  //  PGraphics createBarkTexture2(int w, int h, String renderer) {
  //    // Turbulence power to control the texture deformation
  //    float power = 6; 
  //    // Turbulence density to control the granularity of the texture
  //    float d = 6; 
  //    noiseSeed(0);
  //    barkTexture = createGraphics(w, h, renderer);
  //    barkTexture.beginDraw();
  //    for (int y=0; y<=h; y++) {
  //      for (int x=0; x<=w; x++) {
  //        float total = 0.0; 
  //        for (float i = d; i >= 1; i = i/2) { 
  //          total += noise(x/d, y/d) * d;
  //        }
  //        float turbulence = 128.0 * total / d;
  //        float base = (x * 0.2) + (y * 0.12);
  //        float offset = base + (power * turbulence / 255);
  //        // Calculate RED color component based on noise value
  //        float r = abs(sin(offset)) * 77;
  //        // Calculate GREEN color component based on noise value
  //        float g = abs(sin(offset)) * 45;
  //        // Calculate BLUE color component based on noise value
  //        float b = abs(sin(offset)) * 39;
  //
  //        // Color the texture with the calculated values
  //        barkTexture.stroke(r, g, b);
  //        // Draw the texture
  //        barkTexture.point(x, y);
  //      }
  //    }
  //    barkTexture.endDraw();
  //    //barkTexture.save("bark_texture_turbulence.png");
  //    return barkTexture;
  //  }
}

