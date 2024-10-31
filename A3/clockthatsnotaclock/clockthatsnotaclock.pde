/*
 This piece utilizes slider that uses mana symbols from Magic: The Gathering
 to represent numbers on the clock. Each symbol has its own dedicated length and is
 easily remembered without the key by referring to WUBRG order. The background also
 showcases whether it's AM or PM by alternating between white and black.
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
// Colors For AM & PM
float light;
float dark;
// If The Screen Has Been Shot
boolean saved;

void setup() {
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
  
  saved = false;
}

void draw() {
  // Map Places For Symbols Relative To Their Dedicated Hours
  awSymPos = map(((hour()) + norm(minute(), 0, 60)), 10, 12, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  auSymPos = map(hour() + norm(minute(), 0, 60), 0, 2, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  abSymPos = map(hour() + norm(minute(), 0, 60), 2, 4, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  arSymPos = map(hour() + norm(minute(), 0, 60), 4, 8, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  agSymPos = map(hour() + norm(minute(), 0, 60), 8, 10, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  pwSymPos = map(hour() + norm(minute(), 0, 60), 22, 24, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  puSymPos = map(hour() + norm(minute(), 0, 60), 12, 14, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  pbSymPos = map(hour() + norm(minute(), 0, 60), 14, 16, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  prSymPos = map(hour() + norm(minute(), 0, 60), 16, 20, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
  pgSymPos = map(hour() + norm(minute(), 0, 60), 20, 22, (cx/2) - (symbolSize / 2), (cx * 1.5) - (symbolSize / 2));
 
  // Set Am & PM Colors
  light = map(hour() + norm(minute(), 0, 60), 0, 17, 0, 255);
  dark = map(hour() + norm(minute(), 0, 60), 17, 24, 255, 0);

  // Set Text To Beleren
  textFont(bel);
  fill(10);
  noStroke();
  DrawTime();

  if(saved == false){
    saved = true;
    save("clockthatsnotaclockpiece.png");
  }
}

void DrawTime(){
  colorMode(RGB);
  strokeWeight(40);

  float changeTime = hour() + norm(minute(), 0, 60);
  textSize(50);
  fill(200,55,27);
  // Says Whether Its AM OR PM
  if(changeTime < 12){
  background(light);
  text("AM", cx, (cy / 4) + 115);
}
  else{
  background(dark);
  text("PM", cx, (cy / 4) + 115);
}
  
   //Indicates The Center Of The Line
  image(mtg, (cx - ((symbolSize - 35) /2)), 250);



  //Write The Legend
  textAlign(CENTER);
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

    // Covers The Jitters
  strokeWeight(30);
  fill(0,0,0,0);
  stroke(10);
  endShape();
  if((changeTime >= 10 && changeTime < 12) || (changeTime > 22 && changeTime < 24)){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(white, awSymPos);
}
  if(changeTime >= 22 && changeTime < 24){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(white, pwSymPos);
}
  if(changeTime >= 0 && changeTime < 2){ 
  stroke(170,224,250,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(blue, auSymPos);
}
  if(changeTime >= 12 && changeTime < 14){ 
  stroke(170,224,250,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(blue, auSymPos);
}
  if(changeTime >= 2 && changeTime < 4){ 
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, abSymPos);
}
  if (changeTime >= 14 && changeTime < 16){
  stroke(255,251,214,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, pbSymPos);
}
  if(changeTime >= 4 && changeTime < 8){ 
  stroke(249,172,144,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(red, arSymPos);
}
  if(changeTime >= 16 && changeTime < 20){ 
  stroke(249,172,144,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(red, prSymPos);
}
  if(changeTime >= 8 && changeTime < 10){ 
  stroke(156,212,176,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(green, agSymPos);
}
  if(changeTime >= 20 && changeTime < 22){ 
  stroke(156,212,176,255);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(green, pgSymPos);
}
  if(changeTime >= 2 && changeTime < 4){
  stroke(202, 195, 192);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, abSymPos);
}
  if(changeTime >= 14 && changeTime < 16){
  stroke(202, 195, 192);
  line(cx/2, cy, cx * 1.5, cy);
  MakeSymbols(black, pbSymPos);
}
}
void MakeSymbols(PImage img, float col){
  image(img, col, cy - (symbolSize / 2));
  

}
