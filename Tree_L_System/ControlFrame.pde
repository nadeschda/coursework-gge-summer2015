/**
 * The control frame class.
 *
 * Based on the 'terrain_cam_controls' tutorial.
 * cf. https://github.com/generative-gestaltung/SS2015/tree/master/tutorials/terrain_cam_controls
 */
 
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  int labelColor = color(0, 0, 0);
  Textarea treeDescription;
  RadioButton colorA;
  RadioButton colorB;
  PVector brown = new PVector(0.647059, 0.164706, 0.164706);
  PVector khaki = new PVector(0.623529, 0.623529, 0.372549);
  PVector wheat = new PVector(0.847059, 0.847059, 0.74902);
  PVector sienna = new PVector(0.556863, 0.419608, 0.137255);



  /**
   *  Constructor
   *
   * @param theParent -
   */
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    labelColor = cp5.getTab("default").getColor().getBackground();


    // We create UI elements and arrange them inside tabs.
    // We need plugTo(parent), to have them accessible in the main window.

    // The tab 'default' is provided by default.
    // We can change its name using the 'setLabel()' method.
    cp5.getTab("default")
      .setLabel("tree")
        .setWidth(100)
          .setHeight(20)
            .getCaptionLabel().align(CENTER, CENTER)
              ;

    cp5.addTab("terrain")
      .setColorLabel(color(255))
        .setWidth(100)
          .setHeight(20)
            .getCaptionLabel().align(CENTER, CENTER)
              ;

    cp5.addTab("camera")
      .setColorLabel(color(255))
        .setWidth(100)
          .setHeight(20)
            .getCaptionLabel().align(CENTER, CENTER)
              ;


    /* -------- TREE SETTINGS -------- */

    cp5.addSlider("x_position")
      .plugTo(parent, "treeX")
        .setRange(-terrainWidth, terrainWidth)
          .setValue(terrainWidth/2)
            .setPosition(25, 50)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("default");

    cp5.addSlider("y_position")
      .plugTo(parent, "treeY")
        .setRange(-terrainHeight, terrainHeight)
          .setValue(100)
            .setPosition(25, 100)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("default");

    cp5.addSlider("z_position")
      .plugTo(parent, "treeZ")
        .setRange(-terrainWidth, terrainWidth)
          .setValue(terrainWidth/2 - 100)
            .setPosition(25, 150)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("default");

    cp5.addSlider("branching_angle")
      .plugTo(parent, "branchingAngle")
        .setRange(20, 75)
          .setValue(23.5)
            .setPosition(25, 200)
              .setWidth(250)
                .setHeight(20)
                  .setHandleSize(40)
                    .setSliderMode(Slider.FLEXIBLE)
                      .moveTo("default")
                        ;

    cp5.addToggle("toggle_leaves")
      .plugTo(parent, "toggleLeaves")
        .setPosition(25, 250)
          .setSize(50, 20)
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                .moveTo("default")
                  ;

    treeDescription = cp5.addTextarea("txt")
      .setPosition(25, 300)
        .setSize(250, 240)
          .setFont(createFont("menlo", 11))
            .setLineHeight(14)
              .setColor(color(255))
                .setColorBackground(labelColor)
                  .setColorForeground(color(255, 100))
                    ;
    treeDescription.setText("L-system used to produce ternary branching tree:\n"
      +" F[&F][^>F][^<F]\n"
      +"The leafy version uses just one additional symbol:\n"
      +" F[&F*][^>F*][^<F*]\n"
      +"The L-system can process the following symbols/commands:\n"
      +" F: Draw branch, move to its top\n"
      +" &: Pitch down by given angle\n"
      +" ^: Pitch up by given angle\n"
      +" <: Roll left by given angle\n"
      +" >: Roll right by given angle\n"
      +" +: Turn left by given angle\n"
      +" -: Turn right by given angle\n"
      +" |: Turn around\n"
      +" [: Push current state to stack\n"
      +" ]: Pop a state from stack\n"
      +" *: Draw leave at current position\n"
      );



    /* -------- TERRAIN SETTINGS -------- */
    cp5.addSlider("low")
      .plugTo(parent, "low")
        .setRange(0.1, 1.0)
          .setValue(0.5)
            .setPosition(25, 50)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("terrain");

    cp5.addSlider("high")
      .plugTo(parent, "high")
        .setRange(0.05, 0.5)
          .setValue(0.15)
            .setPosition(25, 100)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("terrain");

    cp5.addSlider("dimension")
      .plugTo(parent, "terrainWidth")
        .setRange(1600, 3000)
          .setPosition(25, 150)
            .setSize(250, 20)
              .setHandleSize(40)
                .setSliderMode(Slider.FLEXIBLE)
                  .moveTo("terrain");

    cp5.addSlider("height")
      .plugTo(parent, "terrainHeight")
        .setRange(0, 1500)
          .setValue(100)
            .setPosition(25, 200)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("terrain");


    colorA = cp5.addRadioButton("radioA")
      .setPosition(25, 260)
        .setSize(40, 40)
          .setColorLabel(color(255))
            .setItemsPerRow(4)
              .setSpacingColumn(30)
                .addItem("brown", 0)
                  .addItem("khaki", 1)
                    .addItem("wheat", 2)
                      .addItem("sienna", 3)
                        .activate(1)
                          .moveTo("terrain")
                            ;

    colorB = cp5.addRadioButton("radioB")
      .setPosition(25, 320)
        .setSize(40, 40)
          .setItemsPerRow(4)
            .setSpacingColumn(30)
              .addItem("brownB", 0)
                .addItem("khakiB", 1)
                  .addItem("wheatB", 2)
                    .addItem("siennaB", 3)
                      .activate(3)
                        .moveTo("terrain")
                          ;

    /*
     * We adjust the styling of the labels of the upper radio button group 'radioA'.
     * The labels can be used to address also the second radio button group 'radioB'
     * so we position them at the bottom of the upper controller 'radioA',
     * i.e. in between 'radioA' and 'radioB'.
     */
    for (Toggle t : colorA.getItems ()) {
      t.captionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingY(5);
      t.captionLabel().style().moveMargin(-6, 0, 0, -6);
      t.captionLabel().style().movePadding(6, 0, 0, 6);
      t.captionLabel().style().backgroundWidth = 34;
      t.captionLabel().style().backgroundHeight = 14;
    }

    /*
     * We use the labels of 'radioA' so we do not want the labels of
     * 'radioB' to be visible.
     */
    for (Toggle t : colorB.getItems ()) {
      t.captionLabel().hide();
    }

    /*
     * We set the background of the labels to the respecting color.
     * For example, the label reading 'khaki' gets a khaki-colored background.
     * HEADS UP: the 'khaki' label needs additional margin-settings since it
     * has less characters.
     */
    colorA.getItem(0).captionLabel().setColorBackground(color(0.647059*255, 0.164706*255, 0.164706*255));
    colorA.getItem(1).captionLabel()
      .setColorBackground(color(0.623529*255, 0.623529*255, 0.372549*255))
        .style()
          .moveMargin(0, 0, 0, -3)
            ;
    colorA.getItem(2).captionLabel().setColorBackground(color(0.847059*255, 0.847059*255, 0.74902*255));
    colorA.getItem(2).captionLabel().setColor(labelColor);
    colorA.getItem(3).captionLabel().setColorBackground(color(0.556863*255, 0.419608*255, 0.137255*255));


    cp5.addTextlabel("label")
      .setText("BLEND TERRAIN COLORS")
        .setPosition(165, 365)
          .moveTo("terrain")
            ;



    /* -------- CAMERA SETTINGS -------- */
    cp5.addSlider("camera_height")
      .plugTo(parent, "camHeight")
        .setRange(-200, 200 )
          .setValue(0 )
            .setPosition(25, 50)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("camera")
                      ;

    cp5.addSlider("camera_speed")
      .plugTo(parent, "camSpeed")
        .setRange(0, 1.0)
          .setPosition(25, 100)
            .setSize(250, 20)
              .setHandleSize(40)
                .setSliderMode(Slider.FLEXIBLE)
                  .moveTo("camera");

    cp5.addSlider("camera_radius")
      .plugTo(parent, "camRadius")
        .setRange(100, 1500)
          .setValue(500)
            .setPosition(25, 150)
              .setSize(250, 20)
                .setHandleSize(40)
                  .setSliderMode(Slider.FLEXIBLE)
                    .moveTo("camera");




    //    cp5.getTooltip().setDelay(500);
    //    cp5.getTooltip().register("toggle_leaves", "Toggle between a bare tree and a tree with leaves.");
    //    cp5.getTooltip().register("branching_angle", "Changes the angle between the branches.");


    // We reposition the labels for all Slider controllers
    for (Slider s : cp5.getAll (Slider.class)) {
      cp5.getController(s.getName()).getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
      cp5.getController(s.getName()).getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    }
  } // end setup()) {


  // Handles the events for the radio button group 'radioA'.
  // We switch the components of the terrain color.
  void radioA(int theC) {
    switch(theC) {
      case(0):
      terrainColorA = brown;
      break;
      case(1):
      terrainColorA = khaki;
      break;
      case(2):
      terrainColorA = wheat;
      break;
      case(3):
      terrainColorA = sienna;
      break;
    default:
      terrainColorA = khaki;
      break;
    }
  }

  // Handles the events for the second radio button group 'radioB'.
  // We switch the components of the terrain color.
  void radioB(int theC) {
    switch(theC) {
      case(0):
      terrainColorB = brown;
      break;
      case(1):
      terrainColorB = khaki;
      break;
      case(2):
      terrainColorB = wheat;
      break;
      case(3):
      terrainColorB = sienna;
      break;
    default:
      terrainColorB = sienna;
      break;
    }
  }

  void draw() {
    background(170);
  }


  public ControlP5 control() {
    return cp5;
  }
}

/**
 * Function to create a control frame instance
 */
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
