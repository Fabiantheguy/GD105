/*
 This is a clock that uses symbols to represent even numbers. The hands of the clock
 lerp between the primary colors of each symbol.
 */

int cx, cy;
float secondsRadius;
float minutesRadius;
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

float angle;

void setup() {
  size(960, 720);
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
  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.80;
  hoursRadius = radius * 0.80;
  clockDiameter = radius * 1.8;
  cx = width / 2;
  cy = height / 2;
  
  PVector point = new PVector(random(width), random(height));
  float deltaX = cx - point.x;
  float deltaY = cy - point.y;
  angle = atan2(deltaX, deltaY);
  
  
}

void draw() {
  // Draw The Background Matching Colorless
  colorMode(RGB);
  background(202, 195, 192);
  colorMode(HSB, 255);
  fill(10);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);


  
  // Draw The MTG Mana Symbols
  image(mtg, (cx - ((symbolSize - 35) /2)), cy / 3);
    //draw the center point
  //find the point based on the angle
  float x = (cx - (symbolSize / 2)) - cos(angle) * secondsRadius;
  float y = (cy - (symbolSize / 2)) + sin(angle) * secondsRadius;
  float ux = (cx - (symbolSize / 2)) - cos(angle - 10) * secondsRadius;
  float uy = (cy - (symbolSize / 2)) + sin(angle - 10) * secondsRadius;


  //increment the angle to move the point
  angle += PI/120;
  image(white, ((cx * 1.3) - (symbolSize / 2)), cy / 2);
  image(blue, ((cx * 1.4) - (symbolSize / 3)), cy - symbolSize / 2);
  image(colorless, ((cx * 1.3) - (symbolSize / 2)), cy * 1.3);
  image(black, cx - symbolSize / 2.05, (cy * 1.45) + 5);
  image(phyrexian, ((cx / 1.3) - (symbolSize / 2)), cy * 1.3);
  image(red, ((cx / 1.8) - (symbolSize / 3)), cy - symbolSize / 2);
  image(green, ((cx / 1.45) - (symbolSize / 2)), cy / 2);
  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a += 18) {
    float angle = radians(a);
    //Draw The Symbols Moving
    stroke(230);
    image(white, X(0), Y(0));
    image(blue, X(10), Y(10));
    image(black, x, y);
    image(red, x, y);
  }
    // Covers The Jitters
  strokeWeight(30);
  fill(0,0,0,0);
  stroke(10);
  endShape();
  

  //increment the angle to move the point
  angle += PI/120;
}

void DrawHands(){
  // Set The Values
  float ms = (map(millis(), 0, 1000, 0, TWO_PI) - HALF_PI);
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  
  // Draw The Second Hand Of The Clock With Milliseconds To Make Them Smooth~ (I Swear)
  stroke(190, 400, 400);
  strokeWeight(10);
  line(cx, cy, cx + cos(ms/60) * secondsRadius, cy + sin(ms/60) * secondsRadius);
  strokeWeight(6);
  stroke(240);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(2);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
}

float X(float anglex){
  float x = (cx - (symbolSize / 2)) - cos(angle + anglex) * secondsRadius;
  return x;
}
float Y(float angley){
  float y = (cy - (symbolSize / 2)) + sin(angle + angley) * secondsRadius;
  return y;
}
