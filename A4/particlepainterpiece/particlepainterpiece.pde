/*
  The goal of this piece is to replicate the animation of shards landing in the
  pile in (the) Gnorp Apologue. Random shapes will drop which represents the 
  shard

*/
import processing.sound.*;
import java.util.ArrayList;

// Array for button labels
String[] buttonLabels = {"Spawn UP", "Value UP", "Click UP"};
int[] buttonCosts = {30, 50, 50}; // Initial cost for "Spawn UP" set to 30
int[] buttonYs = {150, 250, 350}; // Y positions for each button
int buttonWidth = 300; // Button width
int buttonHeight = 50; // Button height

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  color originalColor; // Store the original color
  color col; // Current color (may change to white for landed particles)
  float angle;        // Current angle for spinning
  float angularSpeed; // Speed of rotation
  int shapeType;      // 0: Circle, 1: Rectangle, 2: Triangle, 3: Square (Landed)
  float size;

  Particle(float x, float y, color c) {
    position = new PVector(x, y);
    velocity = new PVector(0, random(1, 3)); // Fall speed
    acceleration = new PVector(0, 0.1);     // Gravity-like force
    angle = random(TWO_PI);
    angularSpeed = random(-0.1, 0.1); // Random spin
    originalColor = c;  // Store the original color
    col = originalColor; // Initially, the color is the original color
    shapeType = int(random(3));       // Random shape (circle, rectangle, triangle)
    size = random(10, 20);            // Random size
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    angle += angularSpeed; // Rotate as it falls
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    noStroke();
    fill(col);
    drawShape();
    popMatrix();
  }

  void drawShape() {
    switch (shapeType) {
      case 0:
        ellipse(0, 0, size, size);
        break;
      case 1:
        rectMode(CENTER);
        rect(0, 0, size, size / 2);
        break;
      case 2:
        triangle(-size / 2, size / 2, size / 2, size / 2, 0, -size / 2);
        break;
      case 3:
        rectMode(CENTER);
        rect(0, 0, size, size); // Draw as a square
        break;
    }
  }

  boolean hasLanded(ArrayList<Particle> pileParticles) {
    for (Particle other : pileParticles) {
      // Check if particles are close enough on the x-axis and the shard is falling
      if (abs(position.x - other.position.x) < (size + other.size) / 2 &&
          position.y + size / 2 >= other.position.y - other.size / 2) {
        
        // Align the new shard directly above the one it lands on
        position.y = other.position.y - (size / 2 + other.size / 2); // Adjust Y position to sit on top of the other

        // Align the x position so that all shards form a straight line
        position.x = other.position.x; // Align the x position exactly

        return true; // The particle has landed
      }
    }
    
    // If the shard reaches the bottom of the screen, stop it
    if (position.y + size / 2 >= height) {
      position.y = height - size / 2;
      return true;
    }
    
    return false;
  }

  void stop() {
    velocity.set(0, 0);
    acceleration.set(0, 0);
  }

  void transformToSquare() {
    shapeType = 3; // Change shape to square
    angle = 0;     // Reset the rotation angle
  }

  void turnWhite() {
    col = color(255); // Turn the color to white
  }
}

ArrayList<Particle> particles;
ArrayList<Particle> pileParticles;
SoundFile[] sounds; // Array to hold sound effects
int shard = 0; // Initialize shard
PFont arcadelFont; // Font object to hold ARCADECLASSIC.TTF
int spawnRateInterval = 100; // Initial spawn rate interval

void setup() {
  fullScreen();
  particles = new ArrayList<Particle>();
  pileParticles = new ArrayList<Particle>();
  
  sounds = new SoundFile[7];
  for (int i = 0; i < 7; i++) {
    sounds[i] = new SoundFile(this, "Bit(" + (i + 1) + ").wav");
    sounds[i].amp(0.2); // Set the volume for each sound
  }

  arcadelFont = createFont("ARCADECLASSIC.TTF", 64); // Load the custom font with a larger size
}

void draw() {
  rectMode(CENTER);
  fill(0, 20); // Semi-transparent black for fade
  rect(0, 0, 1000000, 1000000); // Fade effect covering the screen

  // Spawn new particles
  if (frameCount % spawnRateInterval == 0) {
    particles.add(new Particle(random(width), 0, getRandomHotColor()));
  }

  // Update and display all falling particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();

    if (p.hasLanded(pileParticles)) {
      p.stop();
      p.transformToSquare(); // Transform the particle to a square when it lands
      pileParticles.add(p); // Add to pileParticles
      particles.remove(i);
      playRandomSound();
    } else {
      p.display();
    }
  }

  // Resolve overlaps in pileParticles
  resolveOverlap();

  // Display the pile with colors
  for (Particle p : pileParticles) {
    p.display();
  }

  // Update the shard count to match pileParticles
  shard = pileParticles.size();

  // Display shard count
  textFont(arcadelFont);
  fill(255); // White color for the text
  textSize(100);
  textAlign(CENTER, TOP);
  text("Shards  " + shard, width / 2, 20);

  // Display buttons
  for (int i = 0; i < buttonLabels.length; i++) {
    int yPos = buttonYs[i];

    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Cost  " + buttonCosts[i], width / 2, yPos - 50);

    if (isMouseOverButton(yPos)) {
      fill(140, 0, 0);
    } else {
      fill(200, 0, 0);
    }
    rect(width / 2, yPos, buttonWidth, buttonHeight);

    fill(255);
    textSize(32);
    text(buttonLabels[i], width / 2, yPos);
  }
}

boolean isMouseOverButton(int yPos) {
  return mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 &&
         mouseY > yPos - buttonHeight / 2 && mouseY < yPos + buttonHeight / 2;
}

void mousePressed() {
  if (isMouseOverButton(buttonYs[0])) {
    // Check if enough shards are available before decrementing
    if (shard >= buttonCosts[0]) {
      shard -= buttonCosts[0]; // Deduct shards
      spawnRateInterval = int(spawnRateInterval * .95); // Increase spawn rate by 5%

      // Remove particles from pileParticles
      int numToRemove = buttonCosts[0];
      int removedCount = 0;

      // Loop through the pile and remove particles until the required number is removed
      for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
        pileParticles.remove(i);
        removedCount++;
      }
      buttonCosts[0] = int(buttonCosts[0] * 1.1); // Increase cost
    }
  } else {
    particles.add(new Particle(mouseX, 0, getRandomHotColor()));
  }
}

color getRandomHotColor() {
  int colorChoice = int(random(6));
  switch (colorChoice) {
    case 0: return color(255,122,229);
    case 1: return color(255, 93, 18);
    case 2: return color(102, 255, 227);
    case 3: return color(99, 44, 255);
    case 4: return color(251, 145, 51);
    case 5: return color(226, 64, 122);
    default: return color(255,122,229);
  }
}

void playRandomSound() {
  int randomIndex = int(random(sounds.length));
  sounds[randomIndex].play();
}

void resolveOverlap() {
  for (int i = 0; i < pileParticles.size(); i++) {
    Particle p1 = pileParticles.get(i);
    for (int j = i + 1; j < pileParticles.size(); j++) {
      Particle p2 = pileParticles.get(j);

      // Check for overlap
      if (abs(p1.position.x - p2.position.x) < (p1.size + p2.size) / 2 &&
          abs(p1.position.y - p2.position.y) < (p1.size + p2.size) / 2) {
        
        // Resolve overlap by adjusting Y position
        if (p1.position.y < p2.position.y) {
          p1.position.y = p2.position.y - (p1.size / 2 + p2.size / 2);
        } else {
          p2.position.y = p1.position.y - (p1.size / 2 + p2.size / 2);
        }
      }
    }
  }
}
