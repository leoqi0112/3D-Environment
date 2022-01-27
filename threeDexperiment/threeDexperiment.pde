import java.awt.Robot;

Robot rbt;
boolean skipFrame;

//color pallette
color black = #000000;    //glass
color white = #FFFFFF;    //empty space
color dullBlue = #7092BE; //mossy bricks

//textures
PImage mossyStone;
PImage glass;
PImage stone;

//map variable
int gridSize;
PImage map;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;
void setup() {
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  glass = loadImage("glass.png");
  stone = loadImage("stone.png");

  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  //initialize map
  map = loadImage("map.png");
  gridSize = 100;

  leftRightHeadAngle = radians(270);
  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;
}

void draw() {
  background(0);
  
  pointLight(255,255,255,eyeX,eyeY,eyeZ);
  
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  drawFloor(-2000, 2000, height, 100);
  drawFloor(-2000, 2000, height-gridSize*4, 100);
  drawFocalPoint();
  drawMap();
  controlCamera();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-2*gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-3*gridSize, y*gridSize-2000, mossyStone, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, glass, gridSize);
        texturedCube(x*gridSize-2000, height-2*gridSize, y*gridSize-2000, glass, gridSize);
        texturedCube(x*gridSize-2000, height-3*gridSize, y*gridSize-2000, glass, gridSize);
      }
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor(int start, int end, int level, int gap) {

  int x = start;
  int z = start;
  stroke(255);
  while (z < end) {
    texturedCube(x, level, z, stone, gap);
    x += gap;
    if (x >= end) {
      x = start;
      z += gap;
    }
  }
}
void drawCeiling() {
  int x = -2000;
  stroke(255);
  while (x <= 2000) {
    line(x, height-3*gridSize, -2000, x, height-3*gridSize, 2000);
    line(-2000, height-3*gridSize, x, 2000, height-3*gridSize, x);
    x += 100;
  }
}

void controlCamera() {
  
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX- pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle+PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle-PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle-PI/2)*10;
  }

  leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
  upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;

  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }

  println(eyeX, eyeX, eyeZ);
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'D' || key == 'd') dkey = true;
  if (key == 'S' || key == 's') skey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'D' || key == 'd') dkey = false;
  if (key == 'S' || key == 's') skey = false;
}
