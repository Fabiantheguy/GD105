PImage img;

void setup() {
  background(255, 255, 255);
  size(510, 270);
  img = loadImage("Boros.jpg");
}

void draw() {
  image(img, 0, 0);
  //image(img, 255, 0);
  strokeWeight(1);

  strokeWeight(170);
  stroke(0, 0, 0);
  line(385, 150, 385, 150);
  strokeWeight(5);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  quad(315, 245, 340, 260, 350, 205, 335, 200);
  quad(425, 260, 450, 245, 430, 200, 410, 205);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  quad(340, 260, 350, 205, 410, 205, 425, 260);
  quad(435, 160, 400, 180, 410, 210, 425, 190);
  fill(255, 0, 0);
  quad(327, 171, 410, 180, 400, 210, 350, 200);
  fill(0, 255, 255);
  quad(370, 165, 410, 180, 400, 210, 335, 165);
  fill(255, 255, 255);
  stroke(0,0,0);
  quad(360, 158, 387, 158, 387, 90, 360, 90); // Middle Finger
  quad(320, 160, 380, 160, 380, 135, 320, 135);
  stroke(255, 255, 255);
  quad(325, 167, 345, 167, 345, 160, 325, 160);
  fill(255, 255, 255);
  stroke(0,0,0);
  quad(330, 135, 360, 135, 360, 100, 330, 100); // Thumb
  quad(330, 135, 360, 135, 360, 100, 330, 100); // Index Finger
  quad(388, 158, 415, 158, 415, 100, 388, 100); // Ring Finger
  quad(388, 158, 415, 158, 415, 100, 388, 100); // Pinky Finger
  save("replicapiece.png");
}
