/**
 * Turtle
 * 
 * A class to describe the geometrical and graphical interpretation
 * of the strings produced by the L-System.
 *
 * This implementation relies on the example provided by
 * Daniel Shiffman in his book "The Nature of Code" (http://natureofcode.com).
 */

class Turtle {

  float radius1;
  float radius2;
  float stepSize;
  float theta;

  Branch branch;
  Leaf leaf;

  Turtle(float r1, float r2, float step, float angle) {
    radius1 = r1;
    radius2 = r2;
    stepSize = step;
    theta = radians(angle);
    branch = new Branch(radius1, radius2, stepSize);
    leaf = new Leaf(radius2*5, -1);
  } 


  void setStepSize(float step) {
    stepSize = step;
  } 

  void changeStepSize(float percent) {
    //stepSize /= 1.2;
    stepSize *= percent;
    radius1 = radius2;
    radius2 *= percent;
  }


  void drawBranch() {
    //branch = new Branch(radius1, radius2, stepSize, detail);
    branch.render();
    translate(0, -stepSize, 0);
  }

  void drawLeaf() {
    //leaf.render();
    translate(leaf.leafSize, -leaf.leafSize*0.2, 0);
    leaf.drawLeaves();
    translate(-leaf.leafSize*0.7, 0, 0);
    rotateZ(-PI/4);
    leaf.drawLeaves();
  }

  void turnLeft(float angle) {
    rotateY(angle);
  }

  void turnRight(float angle) {
    rotateY(-angle);
  }

  void pitchDown(float angle) {
    rotateX(angle);
  }

  void pitchUp(float angle) {
    rotateX(-angle);
  }

  void rollRight(float angle) {
    rotateZ(angle);
  }

  void rollLeft(float angle) {
    rotateZ(-angle);
  }

  void turnAround() {
    rotateY(PI);
  }

  void saveCurrentState() {
    pushMatrix();
    scale(0.7);
  }

  void restorePriorState() {
    popMatrix();
  }
}

