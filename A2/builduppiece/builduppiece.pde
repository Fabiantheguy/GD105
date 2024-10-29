//I have drops of various colors falling and raising with randomized colors.
// SEIZURE/EPILEPTIC WARNING!!!

// Declaring floats that are raised (U)
Float RU;
Float GU;
Float BU;
//Declaring floats that are lowered (D)
Float RD;
Float BD;
int RandomColor;

void setup() {
  background(245, 245, 245);
  size(320, 270);
  // Defining the value of the floats
  RU = 0.0;
  GU = 0.0;
  BU = 0.0;
  RD = 0.0;
  BD = 0.0;
  RandomColor = 0;
  frameRate(30);
}

void draw() {
  drawRed();
  drawGreen();
  drawBlue();
  RandomColor = int(random(0,255));
  save("buildduppiece.png");
}

void drawRed(){
  colorMode(RGB);
  //Setting the color 
  fill(255,0,0);
  // Randomizing the stroke
  colorMode(HSB);
  if((frameCount % 5 == 0)){
      stroke(RandomColor,255,200);
  }
  strokeWeight(30);
  // Drawing the circles
  circle(80,RU,RU);
  circle(200,RD+245,RD);
  //Raise and decrease the variables that define the position of the circles
  RU += 0.1;
  RD -= 0.1;
}
void drawGreen(){
  colorMode(RGB);
  //Setting the color 
  fill(0,255,0);
  // Drawing the circles
  circle(160,GU,GU);
  //Raise and decrease the variables that define the position of the circles
  GU += 0.1;
}
void drawBlue(){
  colorMode(RGB);
  //Setting the color 
  fill(0,0,255);
  // Drawing the circles
  circle(240,BU,BU);
  circle(120,RD+245,RD);
  //Raise and decrease the variables that define the position of the circles
  BU += 0.1;
  BD -= 0.1;
}
