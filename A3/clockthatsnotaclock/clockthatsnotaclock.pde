/*
 This is a clock that uses symbols to represent numbers on the clock. The hands of the clock
 each respective a different color symbol.
 */

int cx, cy;
float symbolsRadius;
float handRadius;
float hoursRadius;
float clockDiameter;
int symbolSize = 75;
PImage white;
PImage blue;
PImage black;
PImage red;
PImage green;
PImage colorless;
PImage mtg;
PImage phyrexian;

PFont bel;

float angle;

void setup() {
  //background(202, 195, 192);
   background(202, 195, 255);
  size(960, 720);
  bel = createFont("Beleren2016-Bold.ttf", 1);
  white = loadImage("White.png");
  white.resize(symbolSize,symbolSize);
  blue = loadImage("Blue.png");
  blue.resize(symbolSize,symbolSize);
  black = loadImage("Black.png");
  black.resize(symbolSize,symbolSize);
  red = loadImage("Red.png");
  red.resize(symbolSize,symbolSize);
  green = loadImage("Green.png");
  green.resize(symbolSize,symbolSize);
  colorless = loadImage("Colorless.png");
  colorless.resize(symbolSize,symbolSize);
  mtg = loadImage("MTG.png");
  mtg.resize(40,symbolSize);
  phyrexian = loadImage("Phyrexian.png");
  phyrexian.resize(40 ,symbolSize);
  int radius = min(width / 2, height / 2) / 2;
  symbolsRadius = radius * 0.72;
  handRadius = radius * 0.9;
  hoursRadius = radius * 0.80;
  clockDiameter = radius * 1.8;
  cx = width / 2;
  cy = height / 2;
  
  PVector point = new PVector(random(width), random(height));
  float deltaX = cx - point.x;
  float deltaY = cy - point.y;
  angle = atan2(deltaX, deltaY);
  
  colorMode(HSB, 255);
  fill(10);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);
  
}

void draw() {
  textFont(bel);
  // Draw The Background Matching Colorless
  colorMode(RGB);
  colorMode(HSB, 255);
  fill(10);
  noStroke();


  
  // Draw The MTG Mana Symbols
 // image(mtg, (cx - ((symbolSize - 35) /2)), cy / 3);
    //draw the center point
  //find the point based on the angle
  float x = (cx - (symbolSize / 2)) - cos(angle) * symbolsRadius;
  float y = (cy - (symbolSize / 2)) + sin(angle) * symbolsRadius;
  float ux = (cx - (symbolSize / 2)) - cos(angle - 10) * symbolsRadius;
  float uy = (cy - (symbolSize / 2)) + sin(angle - 10) * symbolsRadius;


  //Write The Legend
  textSize(50);
  textAlign(CENTER);
  
  image(white, cx - (symbolSize/2), 0);
  text("12-2", cx - 0, 115);
  image(blue, ((cx * 1.4) - (symbolSize / 2)), cy / 4);
  text("2-4", cx * 1.4, (cy / 4) + 115);
  image(black, ((cx * 1.4) - (symbolSize / 2)), cy * 1.45);
  text("4-8", (cx * 1.4), (cy * 1.45) + 115);
  image(red, ((cx / 1.65) - (symbolSize / 2)), cy * 1.45);
  text("8-10", (cx / 1.65), (cy * 1.45) + 115);
  image(green, ((cx / 1.65) - (symbolSize / 2)), cy / 4);
  text("10-12", (cx / 1.65), (cy / 4) + 115);
  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a += 18) {
    float angle = radians(a);
    //Draw The Symbols Moving
    stroke(230);
  }
    // Covers The Jitters
  strokeWeight(30);
  fill(0,0,0,0);
  stroke(10);
  endShape();
  DrawHands();

  //increment the angle to move the point
  angle += PI/120;
}

void DrawHands(){
  // Set The Time Values
  float ms = (map(millis(), 0, 1000, 0, TWO_PI) - HALF_PI);
  float s = (map(second(), 0, 60, 0, TWO_PI) - HALF_PI);
  // A Few Seconds Behind A Second
  float bs = ((map(second(), 0, 60, 0, TWO_PI) - .4) - HALF_PI); 
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  float bh = (map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - .4) - HALF_PI;
  
  // Draw The Second Hand Of The Clock With Milliseconds To Make Them Smooth~ (I Swear)
  colorMode(RGB);
  stroke(255,251,214,255);
  strokeWeight(40);
  // Draw & Leave A Trace Behind The Symbols
  if (h < 2311){
    print(h);
  }
  line(cx, cy, cx + cos(ms) * (handRadius), cy + sin(ms) * (handRadius));
  ellipse(cx, cy, clockDiameter, clockDiameter);
  image(white, (cx - (symbolSize / 2)) + (cos(h) * symbolsRadius), (cy - (symbolSize / 2)) + sin(h) * symbolsRadius);

}

float X(float anglex){
  float x = (cx - (symbolSize / 2)) + cos(angle + anglex) * symbolsRadius;
  return x;
}
float Y(float angley){
  float y = (cy - (symbolSize / 2)) + sin(angle + angley) * symbolsRadius;
  return y;
}
