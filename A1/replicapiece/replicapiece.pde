//This is the boros (red & white) symbol. Boros is a guild from one of Magic:
//The Gathering's most popular planes, Ravnica! Really proud of this!

PImage img;

void setup() {
  background(245, 245, 245); // Trying to match original back color.
  size(510, 270);
  img = loadImage("Boros.jpg");
}

void draw() {
  image(img, 0, 0); // Original Image
  strokeWeight(1);

  strokeWeight(170);
  stroke(0, 0, 0);
  //Circle Section
  line(385, 150, 385, 150); // Black circle
  strokeWeight(5);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  //Forearm Section
  quad(315, 245, 335, 260, 350, 205, 335, 200); // Left Side
  quad(430, 260, 450, 245, 430, 200, 410, 205); // Right Side
  //Palm Section
  fill(245, 245, 245); 
  stroke(245, 245, 245);
  quad(340, 260, 350, 205, 410, 205, 425, 260);
  quad(434, 163, 400, 180, 410, 205, 425, 190);
  quad(327, 171, 410, 180, 400, 210, 350, 200);
  quad(370, 165, 410, 180, 400, 210, 335, 165);
  fill(245, 245, 245);
  stroke(0,0,0);
  // Fingers Section
  quad(360, 158, 387, 158, 387, 90, 360, 90); // Middle Finger
  quad(320, 160, 380, 160, 380, 135, 320, 135);
  stroke(245, 245, 245);
  quad(325, 167, 345, 167, 345, 160, 325, 160);
  fill(245, 245, 245);
  stroke(0,0,0);
  quad(330, 135, 360, 135, 360, 100, 330, 100); // Thumb
  quad(330, 135, 360, 135, 360, 100, 330, 100); // Index Finger
  quad(388, 158, 415, 158, 415, 100, 388, 100); // Ring Finger
  stroke(245, 245, 245);
  quad(420, 151, 436, 151, 436, 115, 420, 115); // Pinky Finger
  stroke(0,0,0);
  //Triangles Section
  fill(0,0,0);
  MakeTriangle();
  
  save("replicapiece.png");
}
void MakeTriangle()
{
  stroke(0,0,0);
  translate(383,150); // Moved origin to center of circle for smooth rotation
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(-115));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(-23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(-23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(-23));
  triangle(-10, -80, 10, -80, 0, -125);
  rotate(radians(-23));
}
