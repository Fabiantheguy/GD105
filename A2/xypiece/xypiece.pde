// This piece showcases the colors of magic centering around MTG's with varying speeds 
// with MTGA's Main Theme playing in the background.
// Also, colorless wants to be part of the team, but he's really not :(
import processing.sound.*;
PVector center;
// Angles for each individual color
float anglew;
float angleu;
float angleb;
float angler;
float angleg;
float anglec;
//Grabbing MTG's Logo
PImage mtg;
// Grabbing Color Images (colorless too, we just don't talk about it)
PImage white;
PImage blue;
PImage black;
PImage red;
PImage green;
PImage colorless;
// Grab MTGA theme
SoundFile arena;
// Radii for each individual color (and colorless)
float radiusw;
float radiusu;
float radiusb;
float radiusr;
float radiusg;
float radiusc;
void setup(){
 size(1000, 1000);
  // Set color images
  mtg = loadImage("MTG.png");
  mtg.resize(this.width/20, this.height/10);
  white = loadImage("White.png");
  white.resize(this.width/12, this.height/12);
  blue = loadImage("Blue.png");
  blue.resize(this.width/12, this.height/12);
  black = loadImage("Black.png");
  black.resize(this.width/12, this.height/12);
  red = loadImage("Red.png");
  red.resize(this.width/12, this.height/12);
  green = loadImage("Green.png");
  green.resize(this.width/12, this.height/12);
  colorless = loadImage("Green.png");
  green.resize(this.width/12, this.height/12);
  colorless = loadImage("Colorless.png");
  colorless.resize(this.width/12, this.height/12);
  // Set & play MTGA theme
  arena = new SoundFile(this, "data/Arena.mp3");
  arena.loop();
  center = new PVector(width/2, height/2);
  //Set the initial space away from the center for each color (and colorless)
  PVector pointw = new PVector(575, 575);
  PVector pointu = new PVector(640, 640);
  PVector pointb = new PVector(705, 705);
  PVector pointr = new PVector(770, 770);
  PVector pointg = new PVector(835, 835);
  PVector pointc = new PVector(900, 900);
  // Finds the radius of the color
  radiusw = dist(center.x, center.y, pointw.x, pointw.y);
  radiusu = dist(center.x, center.y, pointu.x, pointu.y);
  radiusb = dist(center.x, center.y, pointb.x, pointb.y);
  radiusr = dist(center.x, center.y, pointr.x, pointr.y);
  radiusg = dist(center.x, center.y, pointg.x, pointg.y);
  radiusc = dist(center.x, center.y, pointc.x, pointc.y);

  ellipseMode(RADIUS);
}
void draw() {
  background(50,50,50);

  //Draw the MTG/Planeswalker symbol
  image(mtg, center.x-24, center.y-44);
  //Finds the colors next point based on its current angle
  float xw = center.x + cos(anglew)*radiusw;
  float yw = center.y + sin(anglew)*radiusw;
  float xu = center.x + cos(angleu)*radiusu;
  float yu = center.y + sin(angleu)*radiusu;
  float xb = center.x + cos(angleb)*radiusb;
  float yb = center.y + sin(angleb)*radiusb;
  float xr = center.x + cos(angler)*radiusr;
  float yr = center.y + sin(angler)*radiusr;
  float xg = center.x + cos(angleg)*radiusg;
  float yg = center.y + sin(angleg)*radiusg;
  float xc = center.x + cos(angleu)*radiusu;
  float yc = center.y + cos(anglec)*radiusc;

  // Draws each color
  image(white, xw-50, yw-50);
  image(blue, xu-50, yu-50);
  image(black, xb-50, yb-50);
  image(red, xr-50, yr-50);
  image(green, xg-50, yg-50);
  // HEY LOOK AT ME!!!
  image(colorless, xc-50, yc-50);

  // Increments the angles to move the next point (speed is determined by the speed
  // of the color in gameplay)
  anglew += PI/80;
  angleu += PI/90;
  angleb += PI/60;
  angler += PI/20;
  angleg += PI/50;
  anglec += PI/20;
  save("xypiece.png");
}
