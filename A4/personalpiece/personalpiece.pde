/* 
  This code aims to have particles that follow the player's mouse if the
  player is not clicking. When the player clicks/holds the mouse down, the particles
  instead, repel away.
  
*/

ArrayList<AetherParticle> particles;
color[] palette = {
  color(255, 122, 229),  // Pink
  color(255, 93, 18),    // Bright orange
  color(102, 255, 227),  // Cyan
  color(193, 255, 48),   // Sussy green
  color(255, 255, 53),   // Gold
  color(52, 194, 252)    // Baby blue
};

void setup() {
  fullScreen(); // Set the canvas to fullscreen
  particles = new ArrayList<AetherParticle>();
  for (int i = 0; i < 15000; i++) { // More particles!
    particles.add(new AetherParticle(random(width), random(height)));
  }
}

void draw() {
  fill(0, 35); // Semi-transparent black for fade
  rect(0, 0, 1000000, 1000000); // Fade effect covering the screen
  for (AetherParticle p : particles) {
    p.update();
    p.checkEdges(); // Bounce off walls
    p.display();
  }

  // Continuous pulsing while mouse is pressed
  if (mousePressed) {
    for (AetherParticle p : particles) {
      PVector pulse = PVector.sub(p.position, new PVector(mouseX, mouseY));
      pulse.normalize();
      p.applyForce(pulse.mult(100)); // Stronger pulse effect
    }
  }
}

class AetherParticle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  color col;

  AetherParticle(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    acceleration = new PVector();
    maxSpeed = 4;
    col = palette[int(random(palette.length))]; // Randomly select a color from the palette
  }

  void update() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector attraction = PVector.sub(mouse, position);
    float distance = attraction.mag(); // Calculate distance from mouse
    float strength = map(distance, 0, width, 0.3, 0.5); // Adjust attraction strength based on distance
    attraction.setMag(strength); // Apply the correct magnitude
    applyForce(attraction);

    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0); // Reset acceleration
  }

  void applyForce(PVector force) {
    acceleration.add(force.add(PVector.random2D().mult(.3)));
  }

  void checkEdges() {
    // Bounce off the left or right edge
    if (position.x <= 0) {
      position.x = 0; // Correct position at the left edge
      velocity.x *= -1; // Reverse velocity on x-axis
    } 
    else if (position.x >= width) {
      position.x = width; // Correct position at the right edge
      velocity.x *= -1; // Reverse velocity on x-axis
    }
    
    // Bounce off the top or bottom edge
    if (position.y <= 0) {
      position.y = 0; // Correct position at the top edge
      velocity.y *= -1; // Reverse velocity on y-axis
    }
    else if (position.y >= height) {
      position.y = height; // Correct position at the bottom edge
      velocity.y *= -1; // Reverse velocity on y-axis
    }
  }

  void display() {
    noStroke();
    fill(col, 200);
    ellipse(position.x, position.y, 10, 10); // Slightly larger particles
  }
}
