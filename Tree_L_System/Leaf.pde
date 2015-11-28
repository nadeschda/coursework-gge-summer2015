/**
 * Leaf
 * 
 * A class to describe the shape of a simple leaf in 3D.
 *
 * Based on the example in 'Processing. A Programming Handbook 
 * for Visual Designers and Artists.' (pages 191-192).
 */

class Leaf {
  PShape l;
  float leafSize;
  float direction;

  Leaf(float size, float dir) {
    leafSize = size;
    direction = dir;

    textureMode(NORMAL);
    colorMode(RGB, 1);

    l = createShape();
    l.beginShape();

    /* Creates the shape of a leaf as described in the Processing handbook. */
    //l.vertex(1.0*direction, -0.7, 0.0); //starting anchor point
    //l.bezierVertex(1.0*direction, -0.7, 0.0, 0.4*direction, -1.0, 0.0, 0.0, 0.0, 0.0);
    //l.bezierVertex(0.0, 0.0, 0.0, 1.0*direction, 0.4, 0.0, 1.0*direction, -0.7, 0.0);

    /* Creates the shape of a leaf. Slightly modified version of the leaf shape
     * provided in the Processing handbook.
     */
    // starting anchor point
    l.vertex(1.0*direction, 0.7, 0.0);
    // blue-ish color and ambient material
    l.fill(0, 0.15, 0.2);
    l.ambient(0.05, 0.13, 0.25);
    l.bezierVertex(1.0*direction, 0.7, 0.0, 0.4*direction, 1.0, 0.0, 0.0, 0.0, 0.0);
    // green-ish color and ambient material
    l.fill(0, 0.25, 0);
    l.ambient(0.25, 0.63, 0.25);
    l.bezierVertex(0.0, 0.0, 0.0, 1.0*direction, 0.4, 0.0, 1.0*direction, 0.7, 0.0);
    l.endShape();
  }

  void render() {
    pushMatrix();
    scale(leafSize);
    shape(l);
    popMatrix();
  }

  void drawLeaves() {
    float angle = PI/2;
    
    // We draw the shape of a stem.
    beginShape();
    fill(0.21, 0.09, 0.0078);
    ambient(0.25, 0.33, 0.25);
    vertex(direction*leafSize*1.03, leafSize * 1, 0.0);
    bezierVertex(direction*leafSize*1.03, leafSize*0.1, 0.0, -0.44*leafSize, 0.17*leafSize, 0.0, -0.24*leafSize, -1.33*leafSize, 0.0);
    endShape();

    // We put 2 leaves to the right of the stem
    pushMatrix();
    render(); // bottom right leaf
    translate(leafSize/2, -leafSize, 0);
    render(); // top right leaf
    popMatrix();

    // We put 2 leaves to the left of the stem
    pushMatrix();
    translate(-leafSize*1.43, -leafSize*0.9, 0);
    rotateZ(-PI/2);
    render(); // bottom left leaf
    popMatrix();

    pushMatrix();
    translate(-leafSize*1.1, -leafSize*1.8, 0);
    rotateZ(-PI/2);
    render(); // top left leaf
    popMatrix();
  }
}

