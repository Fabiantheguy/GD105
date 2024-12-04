// Base Turtle class
class Turtle {
  PVector pos;
  PVector heading;

  Turtle(float x, float y) {
    pos = new PVector(x, y);
    heading = new PVector(1, 0);
  }

  void turn(int turnAmt) {
    heading.rotate(radians(turnAmt));
  }

  void forward(float amount) {
    PVector oldPos = pos.copy();
    pos.add(PVector.mult(heading, amount));
    line(oldPos.x, oldPos.y, pos.x, pos.y);
  }

  void teleport(float x, float y) {
    pos.set(x, y);
  }

  void teleport() {
    pos.set(random(width), random(height));
  }
}

// FlyingTurtle subclass
class FlyingTurtle extends Turtle {
  boolean isFlying;
  color lineColor;

  FlyingTurtle(float x, float y, color c) {
    super(x, y);
    isFlying = false;
    lineColor = c;
  }

  @Override
  void forward(float amount) {
    if (!isFlying) {
      stroke(lineColor);
      super.forward(amount);
    } else {
      pos.add(PVector.mult(heading, amount));
    }
  }

  void toggleFlying() {
    isFlying = !isFlying;
  }

  void setLineColor(color newColor) {
    lineColor = newColor;
  }
}

// Sketch for a simple drawing
FlyingTurtle ft;

void setup() {
  size(800, 800);
  background(255);

  // Initialize the FlyingTurtle
  ft = new FlyingTurtle(width / 2, height / 2, color(0, 0, 255));

  // Draw a central circle
  drawCircle(100);

  // Draw triangles around the circle
  for (int i = 0; i < 6; i++) {
    ft.turn(60); // Turn to space out triangles
    drawTriangle(150);
  }
}

void drawCircle(float radius) {
  int sides = 36; // Approximate a circle with many sides
  float angleStep = 360.0 / sides;
  for (int i = 0; i < sides; i++) {
    ft.forward(radius);
    ft.turn((int) angleStep);
  }
}

void drawTriangle(float sideLength) {
  for (int i = 0; i < 3; i++) {
    ft.forward(sideLength);
    ft.turn(120); // Triangle angles
  }
}

void draw() {
  noLoop(); // Stop after drawing is complete
}
