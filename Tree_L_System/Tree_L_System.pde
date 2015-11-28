/**
 * Tree_L_System
 *
 * by Nadja Zollo.
 * Beuth Hochschule fuer Technik Berlin - University of Applied Sciences.
 * (Master degree course 'Computer Science and Media')
 *
 * This project is the final exercise and assignment in the course
 * 'Generative Gestaltung (Sommersemester 2015)'.
 *
 * The central theme of this program is to generate a tree using an L-system.
 * A detailed description of an L-system and how it works is given in the 'LSystem'
 * class (see LSystem.pde). A tree is composed of branches and leaves.
 * By default, the tree is generated and rendered as a bare tree. The leaves
 * can be toggled on/off using the 'Control Panel' which is a user interface created
 * with the 'ControlP5' library.
 *
 * A branch is a cylindrical shape drawn using QUAD_STRIPs. A noise-generated
 * texture is applied to give the branch shape the color pattern and look of a bark.
 * In the applied shader we sample the texture and calculate the final color and simple
 * lighting (based on the 'Processing shader tutorial').
 *
 * To draw the shape of a leaf we simply use bezierVertex().
 *
 * Furthermore, the rendered scene includes a noise-generated terrain
 * (mainly following the examples and tutorials from the lecture) as well
 * as a textured sphere, that is rendered with disabled depth test in order to
 * imitate horizon and sky.
 *
 * A camera is also implemented, based on the examples and tutorials provided
 * during the lectures.
 *
 * The control panel allows the user to modify various settings of the
 * objects in the scene and to arrange the scene to his or her liking.
 * For example, at program start it is most unlikely that the positions of the
 * terrain and the tree match. Therefore, the user has to move the tree around
 * in the scene to find a proper location. On the other hand, a more interesting
 * structure can be applied to the terrain by tweaking its parameters, such as
 * dimension, height, or color blending.
 *
 * The basic idea of this L-system implementation was taken from the 2D example provided by
 * Daniel Shiffman in his book "The Nature of Code" (http://natureofcode.com).
 */

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;


// The controlP5 interface class
ControlP5 cp5;

// The separate window for control panel UI
ControlFrame cf;


/* ------------------------------------------------------- */
// Global parameters to be set using the control panel UI:
// camera modifiers are put into the tab "Camera"
float camSpeed;
int camRadius;
float camHeight;

// terrain modifiers are put into the tab "Terrain"
float terrainWidth = 1600;
float terrainHeight = terrainWidth * 0.5;
float high, low;
PVector terrainColorA = new PVector(0.623529, 0.623529, 0.372549);
PVector terrainColorB = new PVector(0.556863, 0.419608, 0.137255);

// tree modifiers are put into the tab "Tree"
float treeY;
float treeX;
float treeZ;
float branchingAngle;
boolean toggleLeaves;
/* ------------------------------------------------------- */


// Other global parameters
PShape universe;
PShape horizon;
PGraphics horizonTexture;
Terrain terrain;

LSystem treeSystem;
LSystem treeLeavesSystem;
Turtle turtle;

int N = 32;
float HORIZON_RADIUS = 2000;

// Branch features
float branchRadius1 = 7;
float branchRadius2 = 5;
float branchLength = 110;

PVector camPos;
float fov;
float cameraZ;

float FRAMERATE = 25.0;

void setup() {
  size(900, 600, P3D);
  frameRate(FRAMERATE);
  noStroke();
  colorMode(RGB, 1);

  cp5 = new ControlP5(this);
  cf = addControlFrame("Control Panel", 300, 600);

  fov = PI/3.0;
  cameraZ = (height/2.0) / tan(fov/2.0);

  terrain = new Terrain();

  horizonTexture = createHorizonTexture(int(HORIZON_RADIUS), int(HORIZON_RADIUS), P3D);

  universe = createShape(SPHERE, 1);
  universe.setTexture(horizonTexture);


  //Production[] rules = new Production[1];
  Production[] tree = new Production[1];
  Production[] treeWithLeaves = new Production[1];

  /*
   * Creates a ternary tree
   */
  tree[0] = new Production('F', "F[&F][^>F][^<F]");


  /*
   * Creates a ternary tree with leaves
   */
  treeWithLeaves[0] = new Production('F', "F[&F*][^>F*][^<F*]");


  /*
   * Creates simple branching structure
   *
   * Values for bottom and top radius should be equal
   */
  //rules[0] = new Production('F', "F[<F*]F[>F*]F");

  /*
   * Creates seaweed-like plant.
   * Based on 2D version: FF-[-F+F+F]+[+F-F-F]
   *
   * Iterate 3 times, max. 4 times.
   * Values for bottom and top radius should be equal. Otherwise the resulting
   * plant looks a little odd.
   */
  //rules[0] = new Production('F', "FF-[&&F^F^F]+[^^F&F&F]+[&&F^F^F]");


  turtle = new Turtle(branchRadius1, branchRadius2, branchLength, branchingAngle);

  treeSystem = new LSystem("F", tree, turtle);
  treeLeavesSystem = new LSystem("F", treeWithLeaves, turtle);

  for (int n=0; n <5; n++) {
    treeSystem.generate();
    treeLeavesSystem.generate();
  }
}

void draw() {
  background(0);

  float time = frameCount / FRAMERATE;

  /*
   * We position the camera to rotate around middle of terrain.
   * At program start the camera's state is idle.
   * We can start rotating around the scene using the control panel.
   *
   * The camera functionality is borrowed from the 'terrain_cam_controls' tutorial.
   */
  camPos = new PVector(0, 0, 0);
  camPos.x =  terrainWidth/2 + camRadius*sin(camSpeed*time);
  camPos.y = camHeight;
  camPos.z =  terrainWidth/2 + camRadius*cos(camSpeed*time);

  beginCamera();
  camera(camPos.x, camPos.y, camPos.z, // position
  terrainWidth/2, 0, terrainWidth/2, // lookAt
  0, 1, 0); // up
  perspective (fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
  endCamera();

  pointLight(0.7, 0.7, 0.7, terrainWidth/2, 0, terrainWidth/2);
  directionalLight(0.4, 0.4, 0.5, -1, 0, -1);
  ambientLight(0.2, 0.4, 0.5);

  hint(DISABLE_DEPTH_TEST);
  pushMatrix();
  /*
   * We center the 'universe'  at the camera's position.
   * In doing this the camera will be inside the universe and we will
   * always look at the horizon of our scene.
   */
  translate(camPos.x, camPos.y, camPos.z);
  scale(HORIZON_RADIUS);

  shape(universe);
  popMatrix();
  hint(ENABLE_DEPTH_TEST);

  /* ------- The Terrain ------- */
  pushMatrix();
  terrain.render(terrainWidth, terrainHeight);
  popMatrix();

  /* ------- The Tree ------- */
  /*
   * At the start of the sketch the default position of the tree
   * won't match with the noise-generated terrain.
   * We can use the control panel to position the tree to our liking.
   * Also, we can change the tree to have leaves.
   */
  pushMatrix();
  translate(treeX, treeY, treeZ);

  if (toggleLeaves == true) {
    treeLeavesSystem.iterate(branchingAngle);
  } else {
    treeSystem.iterate(branchingAngle);
  }
  popMatrix();
}


/**
 * Creates a texture to be applied to the shape that represents the scene's
 * horizon (e.g. a sphere or a cylinder).
 *
 * The lerpColor() function is used to interpolate between colors giving
 * the impression of a night sky. In addition, small ellipses are drawn
 * to the texture as stars.
 */
PGraphics createHorizonTexture(int w, int h, String renderer) {

  color midnight = color(0.184314, 0.184314, 0.309804);
  color steelblue = color(0.137255, 0.419608, 0.556863);
  color golden = color(0.858824, 0.858824, 0.439216);

  color seagreen = color(0.137255, 0.556863, 0.419608);

  float [] starX = new float[h+1];
  float [] starY = new float[h+1];

  // We create the offscreen surface for 3D rendering.
  horizonTexture = createGraphics(w, h, renderer);

  horizonTexture.beginDraw();
  horizonTexture.colorMode(RGB, 1);
  horizonTexture.background(0, 0);
  for (int y = 0; y <= horizonTexture.height; y++) {
    float interAB = map(y, 0, horizonTexture.height, 0, 1);
    float inter = map(y, horizonTexture.height/3, horizonTexture.height/2, 0, 1);
    color aa = lerpColor(midnight, steelblue, interAB);
    color bb = lerpColor(seagreen, golden, interAB);
    color c = lerpColor(aa, bb, inter);
    horizonTexture.stroke(c, 0.9);
    horizonTexture.line(0, y, horizonTexture.width, y);

    starX[y] = random(horizonTexture.width);
    starY[y] = random(horizonTexture.height/2);
    horizonTexture.stroke(1, 0.9);
    horizonTexture.ellipse(starX[y], starY[y], 0.5, 0.5);
  }

  horizonTexture.endDraw();
  //horizonTexture.save("horizon.png");

  return horizonTexture;
}

/* =================================================== */
/*       METHODS BELOW ARE CURRENTLY NOT IN USE
/* =================================================== */

/**
 * Creates a cylindrical shape and applies a texture.
 *
 */
//PShape createHorizon(float r, float h, int detail, PGraphics tex) {
//  textureMode(NORMAL);
//  PShape sh = createShape();
//  sh.setTexture(tex);
//  sh.beginShape(QUAD_STRIP);
//  sh.noStroke();
//  for (int i = 0; i <= detail; i++) {
//    float angle = TWO_PI / detail;
//    float x = sin(i * angle);
//    float z = cos(i * angle);
//    float u = float(i) / detail;
//    sh.normal(x, 0, z);
//    // We give the shape an ambient color.
//    sh.ambient(0, 100, 170);
//    sh.vertex(x * r, -h, z * r, u, 0);
//    sh.vertex(x * r, +h, z * r, u, 1);
//  }
//  sh.endShape();
//
//  return sh;
//}


/**
 * Generates noise to draw clouds to a PGraphics object.
 *
 * Based on the Noise2D example by Daniel Shiffman.
 * The idea for making the transparency height-dependent and
 * stretching the clouds horizontal is borrowed from this sketch:
 * //http://www.openprocessing.org/sketch/179401
 */
//PGraphics createCloudTexture(int w, int h, String renderer) {
//  // Define possible cloud colors
//  color dustyRose = color(0.52, 0.39, 0.39);
//  color goldenrod = color(0.858824, 0.858824, 0.439216);
//  color steelblue = color(0.137255, 0.419608, 0.556863);
//
//  float yOff = 0.0; // Start yOff at 0
//  noiseDetail(8, 0.6);
//
//  // We create the offscreen surface for 3D rendering.
//  cloudTexture = createGraphics(w, h, renderer);
//
//  cloudTexture.beginDraw();
//  cloudTexture.colorMode(RGB, 1);
//  cloudTexture.background(0, 0);
//  for (int y = 0; y <= cloudTexture.height; y++) {
//    yOff += 0.06;   // Increment yOff
//    float xOff = 0.0;   // For every yOff, start xOff at 0
//    for (int x = 0; x <= cloudTexture.width; x++) {
//      xOff += 0.01; // Increment xOff
//
//      // Calculate height-dependent transparency factor.
//      float gauzy = map(y, cloudTexture.height/3, cloudTexture.height, 0.3, 0);
//      // Calculate cloud noise.
//      float noiseValue = noise(35+xOff, 25+yOff);
//      // Map the clouds transparency to the height.
//      noiseValue = map(noiseValue, 0.4, 1, 0, gauzy);
//      noStroke();
//      // Color the clouds.
//      fill(dustyRose, noiseValue);
//      ellipse(x, y, 2, 2);
//    }
//  }
//
//  cloudTexture.endDraw();
//  //cloudTexture.save("clouds_.png");
//
//  return cloudTexture;
//}
