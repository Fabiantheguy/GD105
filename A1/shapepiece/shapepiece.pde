// Sets the size of the canvas
void setup() {  // setup() runs once
  size(500, 500);
  frameRate(30);
};
void draw()
{
      strokeWeight(6);
      line(mouseX, mouseY, mouseX, mouseY);
}
