/*
  The goal of this piece is to replicate the animation of shards landing in the
  pile in (the) Gnorp Apologue. Random shapes will drop which represents the 
  shard amount at the top of the screen.

*/
import processing.sound.*;
import java.util.ArrayList;
import java.io.File;
import java.io.PrintWriter;
import processing.data.JSONObject;

// File to store game data
String saveFile = "gameData.json";
JSONObject gameData; // JSON where data is stored
boolean isLoaded = false; // Checks if the player has loaded data
File file = new File(saveFile);

ArrayList<Particle> particles;
ArrayList<Particle> pileParticles;
SoundFile[] sounds; // Array to hold sound effects
int shard = 0; // Initialize shard
PFont arcadelFont; // Font object to hold ARCADECLASSIC.TTF
float spawnRateInterval = 60; // Initial spawn rate interval
float decayRateInterval = 180; // Initial decay rate interval
float decayPercentage = 0.05; // Percentage of shards removed
float criticalChance = 0.5; // Chance to spawn extra shards
float criticalAmount = 2; // Amount of shards spawned off of a critical
float clickAmount = 1; //Amount of shards spawned on click
int randPosition; // The position that shards randomly spawn at
int numToRemove; // Amount of shards to remove
boolean showButtons;
int fadeTimer; // The timer that tracks how long buttons have been fading
int saveTimer = 60; // The timer that lets the save fade
int clickTimer; // The timer that urges the player to click
int clickTextSize = 30; // Text size for urging to click
boolean clickTextFalling = false; // Checks if text size is falling
SoundFile upgrade, deny, click;

// Array for button labels
String[] buttonLabels = {"Spawn Rate UP", "Click UP", "Crit Chance UP", "Crit Amount UP", "Decay Rate Down", "Decay Loss Down" };
int[] buttonCosts = {10, 10, 5, 50, 30, 30}; // Initial cost for "Spawn UP" set to 30
int[] buttonYs = {250, 350, 450, 550, 650, 750}; // Y positions for each button
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
    size = 13;            // Random size
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

// Initialize variables for the bars
float decayBarProgress = 0; // Decay bar progress
float spawnBarProgress = 0; // Spawn bar progress
float decayBarWidth = 300;  // Width of the decay bar
float spawnBarWidth = 300;  // Width of the spawn bar

void setup() {
  fullScreen();
  particles = new ArrayList<Particle>();
  pileParticles = new ArrayList<Particle>();
  
  sounds = new SoundFile[7];
  for (int i = 0; i < 7; i++) {
    sounds[i] = new SoundFile(this, "Bit(" + (i + 1) + ").wav");
    sounds[i].amp(0.2); // Set the volume for each sound
  }
  upgrade = new SoundFile(this, "Upgrade.wav");
  deny = new SoundFile(this, "Deny.wav");
  click = new SoundFile(this, "Click.wav");
  arcadelFont = createFont("ARCADECLASSIC.TTF", 64); // Load the custom font with a larger size
}

void draw() {
  rectMode(CENTER);
  fill(0, 35); // Semi-transparent black for fade
  rect(0, 0, 1000000, 1000000); // Fade effect covering the screen

  randPosition = (int(random(1, (int(width) / 13))) * 13);
  // Spawn new particles
  if (frameCount % spawnRateInterval == 0) {
    if (random(100) < criticalChance) {
      // Spawn 30 shards if the random number is less than criticalChance
      for (int i = 0; i < criticalAmount; i++) {
        particles.add(new Particle(randPosition, 0, getGnorpColor()));
      }
    } else {
      // Otherwise, spawn just one shard
      particles.add(new Particle(randPosition, 0, getGnorpColor()));
    }
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
  textSize(50);
  textAlign(CENTER, TOP);
  text("Shards  " + shard, width / 2, 20); // Move down 100 pixels

  // Display the "Upgrades" button
  fill(0, 255, 0); // Green color for the upgrades button
  if (isMouseOverButton(100)) {
    fill(0, 200, 0); // Darker green when hovered
  }
  rectMode(CENTER);
  rect(width / 2, 100, buttonWidth, buttonHeight);
  fill(255);
  textSize(30);
  text("Upgrades", width / 2, 85);

  // Only show other buttons if showButtons is true
  if (showButtons) {
    fadeTimer = 0;
    // Display the other buttons
    for (int i = 0; i < buttonLabels.length; i++) {
      int yPos = buttonYs[i];

      fill(255);
      textSize(32);
      textAlign(CENTER, CENTER);
      text("Cost  " + buttonCosts[i], width / 2, yPos - 50);
      
      // Check if "Spawn UP" is at its max level (spawnRateInterval == 1)
      if ((spawnRateInterval * .95) < 1 && i == 0) {
        buttonLabels[0] = "MAX"; // Change the label to "MAX"
        fill(0, 255, 0); // Make the button appear disabled
      } 
      // Check if "Click Up" is at its max level (clickAmount == 10)
      if (clickAmount == 10 && i == 1) {
        buttonLabels[1] = "MAX"; // Change the label to "MAX"
        fill(0, 255, 0); // Make the button appear disabled
      } 
      if (shard >= buttonCosts[i]) {
        if(isMouseOverButton(yPos)){
          fill(150, 150, 0); // Mouse Not Hovering Over
        }
        else {

          fill(220, 220, 0); //Mouse Hovering Over
        } 
      } 
      
      if ((spawnRateInterval * .95) > 1 && shard < buttonCosts[i]) {
        if(isMouseOverButton(yPos)){         
          fill(140, 0, 0); //Mouse Hovering Over
        }
        else {
          fill(200, 0, 0); // Mouse Not Hovering Over
        }
      }
      rect(width / 2, yPos, buttonWidth, buttonHeight);

      fill(255);
      textSize(20);
      text(buttonLabels[i], width / 2, yPos);
    }
  }
  else{
    fadeTimer++;
  }
// Every 1000 frames, remove 10% of the shards from pileParticles
  if (frameCount % decayRateInterval == 0 && pileParticles.size() > 0) {
    if(decayPercentage * shard < .9){
     numToRemove = int(pileParticles.size() * (decayPercentage * shard)); // 10% of total particles
    }
    else{
     numToRemove = int(pileParticles.size() * .9); // 10% of total particles
    }
    for (int i = 0; i < numToRemove; i++) {
      pileParticles.remove(pileParticles.size() - 1); // Remove from the end of the list
    }
  }


  // Draw the background behind the bars
  fill(80,80,80,10); // Dark grey color for the background
  rect(0, 20, width / 1.5, 50); // Background for the decay bar
  rect(width, 20, width / 1.53, 50); // Background for the spawn bar

  // Draw the "DECAY" bar
  float decayBarWidth = map(frameCount % decayRateInterval, 0, decayRateInterval, 0, width / 3);
  fill(255, 0, 0); // Red color for decay bar
  rect(decayBarWidth / 2, 20, decayBarWidth, 50); // Move down 100 pixels and adjust width

  // Draw the "SPAWN" bar
  float spawnBarWidth = map(frameCount % spawnRateInterval, 0, spawnRateInterval, 0, width / 3);
  fill(0, 255, 0); // Green color for spawn bar
  rect(width - spawnBarWidth / 2, 20, spawnBarWidth, 50); // Move down 100 pixels and adjust width

  // Display text "DECAY" on the left
  fill(255);
  textFont(arcadelFont);
  textAlign(LEFT, TOP);
  textSize(30);
  text("DECAY", 20,  10); // Move down 100 pixels

  // Display text "SPAWN" on the right
  fill(255);
  textFont(arcadelFont);
  textAlign(RIGHT, TOP);
  textSize(28);
  text("SPAWN", width - 20, 10); // Move down 100 pixels

  // ** Display on the Left Side: Decay Info **
  fill(255);
  textSize(27);
  textAlign(LEFT, TOP);
  text("Time Before Decay " + String.format("%.2f", decayRateInterval / 60.0) + " secs", 20, 100);
  text("Decay Rate " + (int)(decayPercentage * 100) + "% per shard" , 20, 150);
  if(decayPercentage * shard < .9){
    text("Current Decay " + (int)((decayPercentage * shard) * 100) + "% (Max = 90%)", 20, 200);
  }
  else{
    text("Current Decay " + (int)(90) + "% (Max = 90%)", 20, 200);
  }
  text("(Shard Decay Is Rounded Down)" , 20, 250);
  // ** Display on the Right Side: Spawn Info **
  fill(255);
  textSize(27);
  textAlign(RIGHT, TOP);
  text(String.format("%.2f", (60 / spawnRateInterval)) + " shards per sec", width - 20, 100);
  text(clickAmount + " shards per click", width - 20, 150);
  text(String.format("%.2f", criticalChance) + "%" + " Crit Chance", width - 20, 200);
  text((int)criticalAmount + "x" + " Shards Spawned On Crit", width - 20, 250);
  if (fadeTimer > 5 && !isLoaded){ // Waits and checks if the game has loaded
      loadGameData(); // Loads in game data
      isLoaded = true;
  }
  saveTimer++;
  clickTimer++;
  if (saveTimer < 60){
    textSize(27);
    textAlign(LEFT, BOTTOM);
    fill(0,255,0);
    text("Game Saved!!!" , 20, 950);
  }
  if (clickTimer > 300){  
    if(clickTextSize < 75 && !clickTextFalling){
      clickTextSize++;
    }else{
      clickTextFalling = true;
    }
    if (clickTextFalling && clickTextSize > 30){
      clickTextSize--;
    }
    if (clickTextSize <= 30){
      clickTextFalling = false;
    }
    textSize(clickTextSize);
    textAlign(CENTER, CENTER);
    fill(255);
    text("Click to drop shards!!!" , width/2, height/2);
  }
  if (frameCount % 200 == 0){
    saveGameData();
    saveTimer = 0;
  }
}





boolean isMouseOverButton(int yPos) {
  return mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 &&
         mouseY > yPos - buttonHeight / 2 && mouseY < yPos + buttonHeight / 2;
}

void mousePressed() {
  clickTimer = 0;
  // Check if the "Upgrades" button is clicked
  if (isMouseOverButton(100)) {
    showButtons = !showButtons; // Toggle the visibility of the other buttons
    click.play();
  }

  // Check if any other buttons are clicked (if visible)
  if (showButtons) {
    if (isMouseOverButton(buttonYs[0])) { // Spawn Up
      if (spawnRateInterval * .95 > 1){
        if (shard >= buttonCosts[0]) {
          upgrade.play();
          shard -= buttonCosts[0]; // Deduct shards
          spawnRateInterval = int(spawnRateInterval * .95); // Increase spawn rate by 5%
  
          // Remove particles from pileParticles
          int numToRemove = buttonCosts[0];
          int removedCount = 0;
  
          for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
            pileParticles.remove(i);
            removedCount++;
          }
          buttonCosts[0] = int(buttonCosts[0] * 1.2); // Increase cost
        } else {
          deny.play();
        }
      }
    }
    if (isMouseOverButton(buttonYs[1])) { // Click Up
      if (clickAmount < 10){
        if (shard >= buttonCosts[0]) {
          upgrade.play();
          shard -= buttonCosts[0]; // Deduct shards
          clickAmount++; // Increase amount dropped when clicked by 1
  
          // Remove particles from pileParticles
          int numToRemove = buttonCosts[1];
          int removedCount = 0;
  
          for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
            pileParticles.remove(i);
            removedCount++;
          }
          buttonCosts[1] = int(buttonCosts[1] * 8); // Increase cost
        } else {
          deny.play();
        }
      }
    }
    if (isMouseOverButton(buttonYs[2])) { // Crit Chance Up
      if (criticalChance < 99.5){
        if (shard >= buttonCosts[2]) {
          upgrade.play();
          shard -= buttonCosts[2]; // Deduct shards
          criticalChance *= 1.05; // Increase amount dropped when clicked by 1
  
          // Remove particles from pileParticles
          int numToRemove = buttonCosts[2];
          int removedCount = 0;
  
          for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
            pileParticles.remove(i);
            removedCount++;
          }
          buttonCosts[2] = int(buttonCosts[2] * 1.25); // Increase cost
        } else {
          deny.play();
        }
      }
    }
  }
  if(!isMouseOverButton(100) && !isMouseOverButton(buttonYs[0])){
    int snappedX = int(mouseX / 13) * 13; // Snap mouseX to the nearest multiple of 13
    if (random(100) < criticalChance) {
      // Spawn 30 shards if the random number is less than criticalChance
      for (int i = 0; i < (criticalAmount * clickAmount); i++) {
        particles.add(new Particle(snappedX, 0, getGnorpColor()));
      }
    }else {
      for (int i = 0; i < clickAmount; i++){
        particles.add(new Particle(snappedX, 0, getGnorpColor()));
      }
    }
  }
}


color getGnorpColor() {
  // Hot pink, bright orange, cyan, lime green
  int colorChoice = int(random(6));
  switch (colorChoice) {
    case 0: return color(255,122,229);  // Pink
    case 1: return color(255, 93, 18);  // Bright orange
    case 2: return color(102, 255, 227); // Cyan
    case 3: return color(193, 255, 48); // Sussy green
    case 4: return color(255,255,53);   // Gold
    case 5: return color(52,194,252); // Baby Blue
    default: return color(255,122,229); // Pink
  }
}


void playRandomSound() {
  int randomIndex = int(random(sounds.length));
  sounds[randomIndex].play();
}

void resolveOverlap() {
  // Sort the pile by Y-position (bottom to top)
  pileParticles.sort((p1, p2) -> Float.compare(p2.position.y, p1.position.y));

  // Reset all shard colors to original
  for (Particle p : pileParticles) {
    p.col = p.originalColor; 
  }

  // Resolve overlap by adjusting positions
  for (int i = 0; i < pileParticles.size(); i++) {
    Particle currentShard = pileParticles.get(i);

    for (int j = 0; j < pileParticles.size(); j++) {
      if (i == j) continue; // Skip self-check
      Particle otherShard = pileParticles.get(j);

      // Check overlap
      if (abs(currentShard.position.x - otherShard.position.x) < (currentShard.size + otherShard.size) / 2 &&
          abs(currentShard.position.y - otherShard.position.y) < (currentShard.size + otherShard.size) / 2) {
        // Adjust Y position to remove overlap
        if (currentShard.position.y < otherShard.position.y) {
          currentShard.position.y = otherShard.position.y - (currentShard.size / 2 + otherShard.size / 2);
        } else {
          otherShard.position.y = currentShard.position.y - (currentShard.size / 2 + otherShard.size / 2);
        }
      }
    }
  }

  // Determine "stacked-on" relationships
  for (int i = 0; i < pileParticles.size(); i++) {
    Particle currentShard = pileParticles.get(i);

    for (int j = i + 1; j < pileParticles.size(); j++) { 
      Particle aboveShard = pileParticles.get(j);

      // Check if the shard is directly on top
      if (abs(currentShard.position.x - aboveShard.position.x) < (currentShard.size + aboveShard.size) / 2 &&
          abs(currentShard.position.y - aboveShard.position.y) <= (currentShard.size + aboveShard.size) / 2) {
        currentShard.turnWhite(); // Mark the current shard as white
        break; // Stop checking other shards above
      }
    }
  }
}
void loadGameData() {

  println("Save file found. Loading data...");
  gameData = loadJSONObject(saveFile);
  spawnRateInterval = gameData.getFloat("spawnRateInterval");
  decayRateInterval = gameData.getFloat("decayRateInterval");
  decayPercentage = gameData.getFloat("decayPercentage");
  criticalChance = gameData.getFloat("criticalChance");
  criticalAmount = gameData.getFloat("criticalAmount");
  clickAmount = gameData.getFloat("clickAmount");
  print(gameData.getFloat("shard"));
  for(int i = 0; i < gameData.getFloat("shard"); i++){
      print("e");
      randPosition = (int(random(1, (int(width) / 13))) * 13);
      particles.add(new Particle(randPosition, 0, getGnorpColor()));
  }

  
  println("Welcome back!");
  println("Loaded settings:");
  println(gameData.toString());
}


void saveGameData() {
  if(saveFile != null){
  gameData.setFloat("spawnRateInterval", spawnRateInterval);
  gameData.setFloat("decayRateInterval", decayRateInterval);
  gameData.setFloat("decayPercentage", decayPercentage);
  gameData.setFloat("criticalChance", criticalChance);
  gameData.setFloat("criticalAmount", criticalAmount);
  gameData.setFloat("clickAmount", clickAmount);
  gameData.setFloat("shard", shard);
  saveJSONObject(gameData, saveFile);
  }
  else{
    gameData = new JSONObject();
  }
}

void keyPressed() {
  // Allow exit and save on key press
  if (key == 'q' || key == 'Q') {
    println("Saving game and exiting...");
    print(shard);
    saveGameData();
    exit();
  }
  if (key == 'e' || key == 'E') {
    loadGameData();
  }

}
