/**
 * Constrained Frame.
 * by Jean Pierre Charalambos.
 * 
 * This example illustrates how to add constrains (see Constraint related classes)
 * to your frames to limit their motion. All possible constraints are tested here
 * and they can be defined respect to the local, world or camera frames. Try all the
 * possibilities following the on screen helping text.
 * 
 * Press 'h' to display the global shortcuts in the console.
 * Press 'H' to display the current camera profile keyboard shortcuts
 * and mouse bindings in the console.
 */

import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;
import remixlab.dandelion.constraint.*;
import remixlab.proscene.*;

Scene scene;
PFont myFont;
private int transDir;
private int rotDir;
private int sclDir=4;
InteractiveFrame frame;
AxisPlaneConstraint constraints[] = new AxisPlaneConstraint[3];
int activeConstraint;
boolean wC = true;

public void setup() {
  size(640, 360, P3D);
  // size(640, 360, OPENGL);
  myFont = loadFont("FreeSans-13.vlw");
  textFont(myFont);

  scene = new Scene(this);
  // press 'i' to switch the interaction between the camera frame and the
  scene.setCameraType(Camera.Type.ORTHOGRAPHIC);
  scene.setAxisVisualHint(true);

  constraints[0] = new LocalConstraint();
  // Note that a CameraConstraint(camera) would produce the same results:
  // A CameraConstraint is a LocalConstraint when applied to the camera
  // frame !
  constraints[1] = new WorldConstraint();
  constraints[2] = new CameraConstraint(scene.camera());
  transDir = 0;
  rotDir = 0;
  activeConstraint = 0;

  frame = new InteractiveFrame(scene);
  frame.translate(new Vec(20f, 20f, 0));
  frame.setConstraint(constraints[activeConstraint]);
}

public static AxisPlaneConstraint.Type nextTranslationConstraintType(
AxisPlaneConstraint.Type type) {
  AxisPlaneConstraint.Type rType;
  switch (type) {
  case FREE:
    rType = AxisPlaneConstraint.Type.PLANE;
    break;
  case PLANE:
    rType = AxisPlaneConstraint.Type.AXIS;
    break;
  case AXIS:
    rType = AxisPlaneConstraint.Type.FORBIDDEN;
    break;
  case FORBIDDEN:
    rType = AxisPlaneConstraint.Type.FREE;
    break;
  default:
    rType = AxisPlaneConstraint.Type.FREE;
  }
  return rType;
}

public static AxisPlaneConstraint.Type nextRotationConstraintType(AxisPlaneConstraint.Type type) {
  AxisPlaneConstraint.Type rType;
  switch (type) {
  case FREE:
    rType = AxisPlaneConstraint.Type.AXIS;
    break;
  case AXIS:
    rType = AxisPlaneConstraint.Type.FORBIDDEN;
    break;
  case PLANE:
  case FORBIDDEN:
    rType = AxisPlaneConstraint.Type.FREE;
    break;
  default:
    rType = AxisPlaneConstraint.Type.FREE;
  }
  return rType;
}

private void changeConstraint() {
  int previous = activeConstraint;
  activeConstraint = (activeConstraint + 1) % 3;

  constraints[activeConstraint]
    .setTranslationConstraintType(constraints[previous]
    .translationConstraintType());
  constraints[activeConstraint]
    .setTranslationConstraintDirection(constraints[previous]
    .translationConstraintDirection());
  constraints[activeConstraint]
    .setRotationConstraintType(constraints[previous]
    .rotationConstraintType());
  constraints[activeConstraint]
    .setRotationConstraintDirection(constraints[previous]
    .rotationConstraintDirection());

  frame.setConstraint(constraints[activeConstraint]);
}

public void draw() {
  background(0);
  pushMatrix();
  frame.applyTransformation();
  scene.drawAxis(40);
  fill(204, 102, 0);
  box(30, 30, 30);
  popMatrix();

  fill(0, 0, 255);
  scene.beginScreenDrawing();
  displayText();
  scene.endScreenDrawing();
}

protected void displayType(AxisPlaneConstraint.Type type, int x, int y, char c) {
  String textToDisplay = new String();
  switch (type) {
  case FREE:
    textToDisplay = "FREE (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case PLANE:
    textToDisplay = "PLANE (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case AXIS:
    textToDisplay = "AXIS (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case FORBIDDEN:
    textToDisplay = "FORBIDDEN (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  }

  text("CONSTRAINT SCALING :", 85, height - 30);
  displayDir(sclDir, (150 + 90), height - 30, 'O');

  text(textToDisplay, x, y);
}

protected void displayDir(int dir, int x, int y, char c) {
  String textToDisplay = new String();
  switch (dir) {
  case 0:
    textToDisplay = "X (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case 1:
    textToDisplay = "Y (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case 2:
    textToDisplay = "Z (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case 3:
    textToDisplay = "All (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  case 4:
    textToDisplay = "None (";
    textToDisplay += c;
    textToDisplay += ")";
    break;
  }
  text(textToDisplay, x, y);
}

public void displayText() {
  text("TRANSLATION :", 350, height - 30);
  displayDir(transDir, (350 + 105), height - 30, 'D');
  displayType(constraints[activeConstraint].translationConstraintType(), 
  350, height - 60, 'T');

  text("ROTATION :", width - 120, height - 30);
  displayDir(rotDir, width - 40, height - 30, 'B');
  displayType(constraints[activeConstraint].rotationConstraintType(), 
  width - 120, height - 60, 'R');

  switch (activeConstraint) {
  case 0:
    text("Constraint direction defined w/r to LOCAL (U)", 350, 20);
    break;
  case 1:
    text("Constraint direction defined w/r to WORLD (U)", 350, 20);
    break;
  case 2:
    text("Constraint direction defined w/r to CAMERA (U)", 350, 20);
    break;
  }
}

public void keyPressed() {
  if (key == 'b' || key == 'B') {
    rotDir = (rotDir + 1) % 3;
  }
  if (key == 'd' || key == 'D') {
    transDir = (transDir + 1) % 3;
  }
  if (key == 'o' || key == 'O') {
    sclDir = (sclDir + 1) % 5;
  }
  if (key == 'u' || key == 'U') {
    changeConstraint();
  }
  if (key == 't' || key == 'T') {
    constraints[activeConstraint]
      .setTranslationConstraintType(nextTranslationConstraintType(constraints[activeConstraint]
      .translationConstraintType()));
  }
  if (key == 'r' || key == 'R') {
    constraints[activeConstraint]
      .setRotationConstraintType(nextRotationConstraintType(constraints[activeConstraint]
      .rotationConstraintType()));
  }

  Vec dir = new Vec(0.0f, 0.0f, 0.0f);
  switch (transDir) {
  case 0:
    dir.setX(1.0f);
    break;
  case 1:
    dir.setY(1.0f);
    break;
  case 2:
    dir.setZ(1.0f);
    break;
  }
  constraints[activeConstraint].setTranslationConstraintDirection(dir);

  dir.set(0.0f, 0.0f, 0.0f);
  switch (rotDir) {
  case 0:
    dir.setX(1.0f);
    break;
  case 1:
    dir.setY(1.0f);
    break;
  case 2:
    dir.setZ(1.0f);
    break;
  }
  constraints[activeConstraint].setRotationConstraintDirection(dir);

  switch (sclDir) {
  case 0:
    dir.set(1.0f, 0.0f, 0.0f);
    break;
  case 1:
    dir.set(0.0f, 1.0f, 0.0f);
    break;
  case 2:
    dir.set(0.0f, 0.0f, 1.0f);
    break;
  case 3:
    dir.set(1.0f, 1.0f, 1.0f);
    break;
  case 4:
    dir.set(0.0f, 0.0f, 0.0f);
    break;
  }
  println(sclDir);
  constraints[activeConstraint].setScalingConstraint(dir);
}