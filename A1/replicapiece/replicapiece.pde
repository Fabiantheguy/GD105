PImage img;

void setup() {
  size(600,600);
  img = loadImage("Damnation.jpg");
}

void draw() {
  image(img, 0, 0);
  save("replicapiece.png");
}
