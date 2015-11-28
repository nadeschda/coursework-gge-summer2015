/**
 * Terrain
 *
 * A class representing a quad mesh in the xz-plane forming the scene terrain.
 *
 * Based on the 'terrain_cam_controls' tutorial as well as the 'landscape' tutorial.
 * cf. https://github.com/generative-gestaltung/SS2015/tree/master/tutorials
 */

class Terrain {

  PShape terrain;
  PGraphics terrainTexture;
  PShader terrainShader;

  /*
   * Constructor.
   *
   * Creates the quad mesh that forms our terrain and loads the specified shader.
   */
  Terrain() {
    textureMode(NORMAL);
    terrain = createShape();
    //terrain.setTexture(terrainTexture);
    terrain.beginShape(QUADS);
    terrain.fill(255);
    terrain.noStroke();

    float N = 100;
    for (int i=0; i<N; i++) {
      for (int j=0; j<N; j++) {

        float y = 0;
        terrain.vertex (i/N, y, j/N, 0, 0);
        terrain.vertex ((i+1)/N, y, j/N, 1.0, 0);
        terrain.vertex ((i+1)/N, y, (j+1)/N, 1.0, 1.0);
        terrain.vertex (i/N, y, (j+1)/N, 0, 1.0);
      }
    }

    terrain.endShape();

    terrainShader = loadShader("terrain_frag.glsl", "terrain_vert.glsl");
    terrainTexture = createTerrainTexture(1000, 1000, P3D);
  }

  /**
   * Applies the shader, sets the accompanied uniform variables,
   * and draws the terrain shape.
   */
  void render(float dimension, float altitude) {
    pushMatrix();
    shader(terrainShader);
    terrainShader.set("terrainTexture", terrainTexture);
    terrainShader.set("terrainWidth", dimension);
    terrainShader.set("terrainHeight", altitude);
    terrainShader.set("high", high);
    terrainShader.set("low", low);
    terrainShader.set("terrainColorA", terrainColorA);
    terrainShader.set("terrainColorB", terrainColorB);
    shape(terrain);
    popMatrix();
    resetShader();
  }


  /**
   * Generates a noise texture which will be used in the shader to create
   * the displacement of the terrain.
   *
   * The algorithm is borrowed from 'Processing. A Programming Handbook
   * for Visual Designers and Artists.' (page 131) and applied with minor
   * modifications  (e.g. adding noiseDetail()).
   */
  PGraphics createTerrainTexture(int w, int h, String renderer) {
    float xnoise = 0.0;
    float ynoise = 0.0;
    // Increment noise values
    float inc = 0.01;
    float noiseFalloff0 = 0.3;
    float noiseFalloff1 = 0.4;
    float noiseFalloff2 = 0.1;
    int noiseOctaves = 8;
    // We create the offscreen surface for 3D rendering.
    terrainTexture = createGraphics(w, h, renderer);
    terrainTexture.beginDraw();
    for (int y = 0; y <= h; y++) {
      for (int x = 0; x <= w; x++) {
        // Calculate RED color component based on noise value
        noiseDetail(noiseOctaves, noiseFalloff0);
        float r = noise(xnoise, ynoise) * 255;
        // Calculate GREEN color component based on noise value
        noiseDetail(noiseOctaves, noiseFalloff1);
        float g = noise(xnoise, ynoise) * 255;
        // Calculate BLUE color component based on noise value
        noiseDetail(noiseOctaves, noiseFalloff2);
        float b = noise(xnoise, ynoise) * 255;

        // Color the texture with the calculated values
        terrainTexture.stroke(r, g, b);
        // Draw the texture
        terrainTexture.point(x, y);
        xnoise = xnoise + inc;
      }
      xnoise = 0;
      ynoise = ynoise + inc;
    }
    terrainTexture.endDraw();
    //terrainTexture.save("noise.png");

    return terrainTexture;
  }
}
