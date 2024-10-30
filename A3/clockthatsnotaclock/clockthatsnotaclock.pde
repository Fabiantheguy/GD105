/*
 This is a slider that uses symbols to represent numbers on the clock. Each
 symbol has its own dedicated length and is easily remembered without the key
 by referring to WUBRG order.
 */
// Setting Variables
int cx, cy;
float symbolsRadius;
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
PGraphics pg;
// AM Symbol Positions
float awSymPos;
float auSymPos;
float abSymPos;
float arSymPos;
float agSymPos;
// PM Symbol Positions
float pwSymPos;
float puSymPos;
float pbSymPos;
float prSymPos;
float pgSymPos;

void setup() {
  background(202, 195, 192);
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
  symbolsRadius = radius * 1.25;
  // Grabs The Center Of The Screen
  cx = width / 2;
  cy = height / 2;
  
  PVector point = new PVector(random(width), random(height));
  float deltaX = cx - point.x;
  float deltaY = cy - point.y;
  angle = atan2(deltaX, deltaY);
  
  colorMode(HSB, 255);
  fill(10);
  //noStroke();
  //ellipse(cx, cy, clockDiameter, clockDiameter);

  
  fill(212,21,21);
}

void draw() {
  awSymPos = map(((hour()) + norm(minute(), 0, 60)), 10, 12, (cx/2) - (symbolSize / 2), (cx * 1.5));
  auSymPos = map(hour() + norm(minute(), 0, 60), 0, 2, (cx/2), (cx * 1.5));
  abSymPos = map(hour() + norm(minute(), 0, 60), 2, 4, (cx/2), (cx * 1.5));
  arSymPos = map(hour() + norm(minute(), 0, 60), 4, 8, (cx/2), (cx * 1.5));
  agSymPos = map(hour() + norm(minute(), 0, 60), 8, 10, (cx/2), (cx * 1.5));
  pwSymPos = map(hour() + norm(minute(), 0, 60), 22, 24, (cx/2) - (symbolSize / 2), (cx * 1.5));
  puSymPos = map(hour() + norm(minute(), 0, 60), 12, 14, (cx/2), (cx * 1.5));
  pbSymPos = map(hour() + norm(minute(), 0, 60), 14, 16, (cx/2), (cx * 1.5));
  prSymPos = map(hour() + norm(minute(), 0, 60), 20, 22, (cx/2), (cx * 1.5));
  pgSymPos = map(hour() + norm(minute(), 0, 60), 20, 22, (cx/2), (cx * 1.5));
  background(0, 0, 0);
  
  print(hour() + norm(minute(), 0, 60) + "\n");
  //print(awSymPos + "\n");
  //print(hour() + "\n");
  //print(minute() + "\n");
  //print(norm(minute(), 0, 60) + "\n");
  textFont(bel);
  // Draw The Background Matching Colorless
  colorMode(RGB);
  colorMode(HSB, 255);
  fill(10);
  noStroke();
  
  
  // Draw The MTG Mana Symbols
 // image(mtg, (cx - ((symbolSize - 35) /2)), cy / 3);
    //draw the center point


  //Write The Legend
  textSize(50);
  textAlign(CENTER);
  fill(255);
  image(white, cx - (symbolSize/2), 10);
  text("10-12", cx - 0, 125);
  image(blue, ((cx * 1.4) - (symbolSize / 2)), cy / 4);
  text("12-2", cx * 1.4, (cy / 4) + 115);
  image(black, ((cx * 1.4) - (symbolSize / 2)), cy * 1.45);
  text("2-4", (cx * 1.4), (cy * 1.45) + 115);
  image(red, ((cx / 1.65) - (symbolSize / 2)), cy * 1.45);
  text("4-8", (cx / 1.65), (cy * 1.45) + 115);
  image(green, ((cx / 1.65) - (symbolSize / 2)), cy / 4);
  text("8-10", (cx / 1.65), (cy / 4) + 115);
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
  
  // Draw The Second Hand Of The Clock With Milliseconds To Make Them Smooth~ (I Swear)
  colorMode(RGB);
  strokeWeight(40);
  /* Draw & Leave A Trace Behind The Symbols
  if (h < 2311){
    print(h);
  }
  line(cx, cy, cx + cos(bh) * (handRadius), cy + sin(bh) * (handRadius));
  ellipse(cx, cy, clockDiameter, clockDiameter);
  image(white, (cx - (symbolSize / 2)) + (cos(h) * symbolsRadius), (cy - (symbolSize / 2)) + sin(h) * symbolsRadius);
  */
  //image(white, (cx - (symbolSize / 2)) + (cos(ms) * symbolsRadius), cy - (symbolSize / 2));
  float changeTime = hour() + norm(minute(), 0, 60);
  
  if((changeTime > 10 && changeTime < 12) || (changeTime > 22 && changeTime < 24)){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(white, awSymPos);
}
  if(changeTime > 22 && changeTime < 24){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(white, pwSymPos);
}
  if(changeTime > 0 && changeTime < 2){ 
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(blue, abSymPos);
}
  if(changeTime > 12 && changeTime < 14){ 
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(blue, abSymPos);
}
  if(changeTime > 2 && changeTime < 4){ 
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, abSymPos);
}
  if (changeTime > 14 && changeTime < 16){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, pbSymPos);
}
  if(changeTime > 4 && changeTime < 8){ 
  MakeSymbols(red, arSymPos);
}
  if(changeTime > 16 && changeTime < 20){ 
  MakeSymbols(red, prSymPos);
}
  if(changeTime > 8 && changeTime < 10){ 
  MakeSymbols(green, agSymPos);
}
  if(changeTime > 20 && changeTime < 22){ 
  MakeSymbols(green, pgSymPos);
}
  if(changeTime > 2 && changeTime < 4){
  stroke(202, 195, 192);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, abSymPos);
}
  if(changeTime > 14 && changeTime < 16){
  stroke(202, 195, 192);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, pbSymPos);
}
  // Says Whether Its AM OR PM
  fill(255);
  if(changeTime < 12){ 
  text("AM", cx, (cy / 4) + 115);
}
  else{
  text("PM", cx, (cy / 4) + 115);
}
}
void MakeSymbols(PImage img, float col){
  image(img, col, cy - (symbolSize / 2));
  

}
