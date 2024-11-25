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
boolean firstSave = true; // Delays the first save to give shards time to fall
JSONObject gameData; // JSON where data is stored
boolean isLoaded = false; // Checks if the player has loaded data
File file = new File(saveFile);

ArrayList<Particle> particles;
ArrayList<Particle> pileParticles;
SoundFile[] sounds; // Array to hold sound effects
int shard = 0; // Initialize shard
PFont arcadelFont; // Font object to hold ARCADECLASSIC.TTF
float spawnRateInterval = 60; // Initial spawn rate interval
int decayRateInterval = 180; // Initial decay rate interval
float decayPercentage = 0.05; // Percentage of shards removed
float criticalChance = 0.5; // Chance to spawn extra shards
float criticalAmount = 2; // Amount of shards spawned off of a critical
float clickAmount = 1; //Amount of shards spawned on click
int shardWorth = 1;
int randPosition; // The position that shards randomly spawn at
int numToRemove; // Amount of shards to remove
boolean showButtons; // Checks if upgrades are visible
boolean showStats; // Checks if stats are visible
boolean sfxOn = true; // Checks if sfx can play
boolean musicOn = true; // Checks if music can play
int fadeTimer; // The timer that tracks how long buttons have been fading
boolean sfxPressed; // Tracks if the SFX can be switched on/off
boolean musicPressed; // Tracks if the music can be switched on/off
int clickTimer; // The timer that urges the player to click
int clickTextSize = 30; // Text size for urging to click
boolean clickTextFalling = false; // Checks if text size is falling
SoundFile upgrade, deny, click, music;

// Array for button labels
String[] buttonLabels = {"Spawn Rate UP", "Click UP", "Crit Chance UP", "Crit Amount UP", "Decay Speed Down", "Decay Loss Down", "Rebirth" };
int[] buttonCosts = {10, 50, 5, 25, 20, 30, 100}; // Initial cost for "Spawn UP" set to 30
boolean[] greenTexts = {false, false, false, false, false, false, false}; // Flag to control green text
int[] greenTextTimers = {0, 0, 0, 0, 0, 0, 0};        // Timer for how long text stays green
boolean redShards = false; // Flag to control green text
int redShardTimer = 60;        // Timer for how long text stays green
int[] buttonYs = {250, 350, 450, 550, 650, 750, 950}; // Y positions for each button
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
    if(file.exists()){
      print("e");
    }
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
      // Check if particles are close enough on the x-axis and the  is falling
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
  gameData = loadJSONObject(saveFile);
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
  music = new SoundFile(this, "Shard Bard.wav");
  click = new SoundFile(this, "Click.wav");
  arcadelFont = createFont("ARCADECLASSIC.TTF", 64); // Load the custom font with a larger size

  music.loop();
  music.amp(0);
}

void draw() {
  rectMode(CENTER);
  fill(0, 35); // Semi-transparent black for fade
  rect(0, 0, 1000000, 1000000); // Fade effect covering the screen
  fill(255);
  textAlign(RIGHT, TOP);
  textSize(10);
  text("Press Q to Mute/Unmute SFX", width - 20, 50);
  text("Press E to Mute/Unmute Music", width - 20, 60);
  if (keyPressed) {
    if (key == 'q' || key == 'Q' && !sfxPressed){
      sfxOn = !sfxOn;
      sfxPressed = true;
    }
    if (key == 'e' || key == 'E' && !musicPressed){
      musicOn = !musicOn;
      musicPressed = true;
    } 
    }else{
      sfxPressed = false;
      musicPressed = false;
  }
  if (musicOn){
    music.amp(0);
  } else{
    music.amp(.3);
  }
  
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
  shard = pileParticles.size() * shardWorth;

  // Display shard count
  textFont(arcadelFont);
  textSize(50);
  textAlign(CENTER, TOP);
  ////
  
  if (redShards) {
    fill(255, 0, 0); // Green color
  }else {
    fill(255); // Default text color
  }
  if (redShardTimer > 0) {
    redShardTimer--;
    if (redShardTimer == 0) {
      redShards = false; // Stop showing green text
        }
  }  
   text("Shards  " + shard, width / 2, 20);
   ShowButtons();
// Every 1000 frames, remove 10% of the shards from pileParticles
  if (frameCount % decayRateInterval == 0 && pileParticles.size() > 0) {
    if((decayPercentage * shard) / shardWorth < .9){
      numToRemove = int((pileParticles.size()) * (decayPercentage * (shard / shardWorth))); // 10% of total particles
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
  ShowStats();
 

  if (fadeTimer > 5 && !isLoaded){ // Waits and checks if the game has loaded
      loadGameData(); // Loads in game data
      isLoaded = true;
  }
  clickTimer++;
  if (clickTimer > 300){  
    if(clickTextSize < 65 && !clickTextFalling){
      clickTextSize++;
    }else{
      clickTextFalling = true;
    }
    if (clickTextFalling && clickTextSize > 45){
      clickTextSize--;
    }
    if (clickTextSize <= 45){
      clickTextFalling = false;
    }
    textSize(clickTextSize);
    textAlign(CENTER, CENTER);
    fill(255);
    text("Click to drop more shards!!!" , width/2, height/2);
  }
  if (!firstSave && frameCount % 60 == 0){ // Time until game saves
      saveGameData();
    }
    else if (frameCount % 300 == 0){
      saveGameData();
      print("e");
      firstSave = false;
    
  }
}





boolean isMouseOverButton(int yPos) {
  return mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 &&
         mouseY > yPos - buttonHeight / 2 && mouseY < yPos + buttonHeight / 2;
}

void mousePressed() {
  clickTimer = 0;
  if (mouseButton == LEFT) {
    // Check if the "Upgrades" button is clicked
    if (isMouseOverButton(100)) {
      showButtons = !showButtons; // Toggle the visibility of the other buttons
      if (sfxOn){
        click.play();
      }
    }
    // Check if the "Stats" button is clicked
    if (isMouseOverButton(150)) {
      showStats = !showStats; // Toggle the visibility of the stats
      if (sfxOn){
        click.play();
      }
    }
  
    // Check if any other buttons are clicked (if visible)
    if (showButtons) {
      if (isMouseOverButton(buttonYs[0])) { // Spawn Up
        if (spawnRateInterval * .95 > 1){
          if (shard >= buttonCosts[0]) {
            if (sfxOn){
              upgrade.play();
            }
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
            greenTexts[0] = true;
            greenTextTimers[0] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[1])) { // Click Up
        if (clickAmount < 10){
          if (shard >= buttonCosts[1]) {
            if (sfxOn){
              upgrade.play();
            }
            shard -= buttonCosts[1]; // Deduct shards
            clickAmount++; // Increase amount dropped when clicked by 1
    
            // Remove particles from pileParticles
            int numToRemove = buttonCosts[1];
            int removedCount = 0;
    
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[1] = int(buttonCosts[1] * 8); // Increase cost
            greenTexts[1] = true;
            greenTextTimers[1] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[2])) { // Crit Chance Up
        if (criticalChance < 80){
          if (shard >= buttonCosts[2]) {
            if (sfxOn){
              upgrade.play();
            }
            criticalChance *= 1.25; // Increase amount dropped when clicked by 1
            if(criticalChance > 80){
              criticalChance = 80;
            }
             // Remove particles from pileParticles
            int numToRemove = buttonCosts[2];
            int removedCount = 0;
    
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[2] = int(buttonCosts[2] * 1.35); // Increase cost
            greenTexts[2] = true;
            greenTextTimers[2] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[3])) { // Crit Amount Up
        if (criticalAmount < 5){
          if (shard >= buttonCosts[3]) {
            if (sfxOn){
              upgrade.play();
            }
            shard -= buttonCosts[3]; // Deduct shards
            criticalAmount++; // Increase amount dropped when clicked by 1
    
            // Remove particles from pileParticles
            int numToRemove = buttonCosts[3];
            int removedCount = 0;
    
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[3] = int(buttonCosts[3] * 3); // Increase cost
            greenTexts[3] = true;
            greenTextTimers[3] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[4])) { // Decay Speed Down
        if (decayRateInterval < 1800){
          if (shard >= buttonCosts[4]) {
            if (sfxOn){
              upgrade.play();
            }
            shard -= buttonCosts[4]; // Deduct shards
            decayRateInterval *= 1.3; // Increase amount dropped when clicked by 1
            if (decayRateInterval > 1800) {
              decayRateInterval = 1800;
            }
    
            // Remove particles from pileParticles
            int numToRemove = buttonCosts[4];
            int removedCount = 0;
    
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[4] = int(buttonCosts[4] * 1.5); // Increase cost
            greenTexts[4] = true;
            greenTextTimers[4] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[5])) { // Decay Loss Down
        if (decayPercentage > .01){
          if (shard >= buttonCosts[5]) {
            if (sfxOn){
              upgrade.play();
            }
            shard -= buttonCosts[5]; // Deduct shards
            decayPercentage /= 1.3; // Increase amount dropped when clicked by 1
            if (decayPercentage < .01) {
                decayPercentage = .01;
            }
    
            // Remove particles from pileParticles
            int numToRemove = buttonCosts[5];
            int removedCount = 0;
    
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[5] = int(buttonCosts[5] * 1.15); // Increase cost
            greenTexts[5] = true;
            greenTextTimers[5] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
      if (isMouseOverButton(buttonYs[6])) { // Rebirth
        if (shardWorth < 10){
          if (shard >= buttonCosts[6]) {
            if (sfxOn){
              upgrade.play();
            }
            shard -= buttonCosts[6]; // Deduct shards
            shardWorth++; // Increase worth of shards
            // Reset everything
            buttonCosts[0] = 10;
            buttonCosts[1] = 50;
            buttonCosts[2] = 5;
            buttonCosts[3] = 25;
            buttonCosts[4] = 20;
            buttonCosts[5] = 30;
            
            spawnRateInterval = 60; // Initial spawn rate interval
            decayRateInterval = 180; // Initial decay rate interval
            decayPercentage = 0.05; // Percentage of shards removed
            criticalChance = 0.5; // Chance to spawn extra shards
            criticalAmount = 2; // Amount of shards spawned off of a critical
            clickAmount = 1; //Amount of shards spawned on click
            if (shardWorth > 10) {
                shardWorth = 10;
            }
    
            // Remove particles from pileParticles
            int numToRemove = pileParticles.size();
            int removedCount = 0;
            // Remove all particles  
            for (int i = pileParticles.size() - 1; i >= 0 && removedCount < numToRemove; i--) {
              pileParticles.remove(i);
              removedCount++;
            }
            buttonCosts[6] = int(buttonCosts[6] * 3); // Increase cost
            greenTexts[6] = true;
            greenTextTimers[6] = 60;
          } else {
            if (sfxOn){
              deny.play();
            }
            redShards = true;
            redShardTimer = 60;
          }
        }
      }
    }
    if(!isMouseOverButton(100) && !isMouseOverButton(buttonYs[0])){
      randPosition = (int(random(1, (int(width) / 13))) * 13);
      int snappedX = int(mouseX / 13) * 13; // Snap mouseX to the nearest multiple of 13
      if (random(100) < criticalChance) {
        // Spawn 30 shards if the random number is less than criticalChance
        for (int i = 0; i < (criticalAmount * clickAmount); i++) {
          particles.add(new Particle(randPosition, 0, getGnorpColor()));
        }
      }else {
        for (int i = 0; i < clickAmount; i++){
          particles.add(new Particle(randPosition, 0, getGnorpColor()));
        }
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
  if (sfxOn){
    int randomIndex = int(random(sounds.length));
    sounds[randomIndex].play();
  }
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
  if(gameData != null){
    println("Save file found. Loading data...");
    spawnRateInterval = gameData.getFloat("spawnRateInterval");
    buttonCosts[0] =   gameData.getInt("spawnRateIntervalCost");
    decayRateInterval = gameData.getInt("decayRateInterval");
    buttonCosts[1] =   gameData.getInt("decayRateIntervalCost");
    decayPercentage = gameData.getFloat("decayPercentage");
    buttonCosts[2] =   gameData.getInt("decayPercentageCost");
    criticalChance = gameData.getFloat("criticalChance");
    buttonCosts[3] =   gameData.getInt("criticalChanceCost");
    criticalAmount = gameData.getFloat("criticalAmount");
    buttonCosts[4] = gameData.getInt("criticalAmountCost");
    clickAmount = gameData.getFloat("clickAmount");
    buttonCosts[5] = gameData.getInt("clickAmountCost");
    shardWorth = gameData.getInt("shardWorth");
    buttonCosts[6] = gameData.getInt("shardWorthCost");
    sfxOn = gameData.getBoolean("sfx");
    musicOn = gameData.getBoolean("music");    
    print(gameData.getFloat("shard"));
    for(int i = 0; i < gameData.getFloat("shard"); i++){
        print("e");
        randPosition = (int(random(1, (int(width) / 13))) * 13);
        particles.add(new Particle(randPosition, 0, getGnorpColor()));
    }
  
    
    println("Welcome back!");
    println("Loaded settings:");
    println(gameData.toString());
  }else{
    gameData = new JSONObject();
  }
}


void saveGameData() {
  if(gameData != null){
  gameData.setFloat("spawnRateInterval", spawnRateInterval);
  gameData.setFloat("spawnRateIntervalCost", buttonCosts[0]);
  gameData.setFloat("decayRateInterval", decayRateInterval);
  gameData.setFloat("decayRateIntervalCost", buttonCosts[1]);
  gameData.setFloat("decayPercentage", decayPercentage);
  gameData.setFloat("decayPercentageCost", buttonCosts[2]);
  gameData.setFloat("criticalChance", criticalChance);
  gameData.setFloat("criticalChanceCost", buttonCosts[3]);
  gameData.setFloat("criticalAmount", criticalAmount);
  gameData.setFloat("criticalAmountCost", buttonCosts[4]);
  gameData.setFloat("clickAmount", clickAmount);
  gameData.setFloat("clickAmountCost", buttonCosts[5]);
  gameData.setFloat("shardWorth", shardWorth);
  gameData.setFloat("shardWorthCost", buttonCosts[6]);
  gameData.setFloat("shard", shard);
  gameData.setBoolean("sfx", sfxOn);
  gameData.setBoolean("music", musicOn);
  saveJSONObject(gameData, saveFile);
  }
  else{
    gameData = new JSONObject();
  }
}

void ShowStats(){
     int colorCycle = frameCount%360;
  if (showStats){
      // ** Display on the Left Side: Decay Info **
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    if (greenTexts[4]) {
      fill(0, 255, 0); // Green color
    }else {
      fill(255); // Default text color
    }
    if (greenTextTimers[4] > 0) {
    greenTextTimers[4]--;
      if (greenTextTimers[4] == 0) {
        greenTexts[4] = false; // Stop showing green text
      }
    }
    text("Time Before Decay = " + String.format("%.2f", decayRateInterval / 60.0) + " secs", 20, 100);
    if (greenTexts[5]) {
      fill(0, 255, 0); // Green color
    }else {
      fill(255); // Default text color
    }
    if (greenTextTimers[5] > 0) {
    greenTextTimers[5]--;
      if (greenTextTimers[5] == 0) {
        greenTexts[5] = false; // Stop showing green text
      }
    }    
    text("Decay Rate = " + String.format("%.2f", decayPercentage * 100) + "% per shard" , 20, 150);
    fill(255);
    if(decayPercentage * (shard / shardWorth) < .9){
      text("Current Decay = " + String.format("%.2f", (decayPercentage * (shard / shardWorth)) * 100) + "% (Max = 90%)", 20, 200);
    }
    else{
      text("Current Decay " + (int)(90) + "% (Max = 90%)", 20, 200);
    }
    text("(Shard Decay Is Rounded Down)" , 20, 250);
    // ** Display on the Right Side: Spawn Info **
    textSize(27);
    textAlign(RIGHT, TOP);
    if (greenTexts[0]) {
      fill(0, 255, 0); // Green color
    }else {
      fill(255); // Default text color
    }
      if (greenTextTimers[0] > 0) {
      greenTextTimers[0]--;
        if (greenTextTimers[0] == 0) {
          greenTexts[0] = false; // Stop showing green text
        }
      }
    text(String.format("%.2f", (60 / spawnRateInterval)) + " shards per sec", width - 20, 100);
    if (greenTexts[1]) {
      fill(0, 255, 0); // Green color
    }else {
      fill(255); // Default text color
    }
      if (greenTextTimers[1] > 0) {
      greenTextTimers[1]--;
        if (greenTextTimers[1] == 0) {
          greenTexts[1] = false; // Stop showing green text
        }
      }
    text((int)clickAmount + " shards per click", width - 20, 150);
    if (greenTexts[2]) {
      fill(0, 255, 0); // Green color
    }else {
      fill(255); // Default text color
    }
    if (greenTextTimers[2] > 0) {
    greenTextTimers[2]--;
      if (greenTextTimers[2] == 0) {
        greenTexts[2] = false; // Stop showing green text
      }
    }
    text(String.format("%.2f", criticalChance) + "%" + " Crit Chance", width - 20, 200);
      if (greenTexts[3]) {
      fill(0, 255, 0); // Green color
      }else {
        fill(255); // Default text color
      }
      if (greenTextTimers[3] > 0) {
      greenTextTimers[3]--;
        if (greenTextTimers[3] == 0) {
          greenTexts[3] = false; // Stop showing green text
        }
    }
    text((int)criticalAmount + "x" + " Shards Spawned On Crit", width - 20, 250);
          if (greenTexts[6]) {
            fill(0, 255, 0); // Green color
          }else {
            fill(255); // Default text color
          }
          if (greenTextTimers[6] > 0) {
            greenTextTimers[6]--;
            if (greenTextTimers[6] == 0) {
              greenTexts[6] = false; // Stop showing green text
            }
    }
    text((int)shardWorth + "x" + " Shard Value", width - 20, 300);
  }
}
void ShowButtons(){
  colorMode(RGB,255,255,255);
  int colorCycle = frameCount%360;
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
  
    // Display the "Stats" button
  fill(235, 235, 0); // Green color for the upgrades button
  if (isMouseOverButton(150)) {
    fill(200, 200, 0); // Darker green when hovered
  }
  rect(width / 2, 150, buttonWidth, buttonHeight);
  fill(255);
  text("Stats", width / 2, 135);

  // Only show other buttons if showButtons is true
  if (showButtons) {
    fadeTimer = 0;
    // Display the other buttons
    for (int i = 0; i < buttonLabels.length; i++) {
      int yPos = buttonYs[i];

      fill(255);
      textSize(31);
      textAlign(CENTER, CENTER);
      text("Cost  " + buttonCosts[i], width / 2, yPos - 50);
      if (shard < buttonCosts[i]) {
        if(isMouseOverButton(yPos)){         
          fill(140, 0, 0); //Mouse Hovering Over
        }
        else {
          fill(200, 0, 0); // Mouse Not Hovering Over
        }
      }
      
      // Check if "Spawn UP" is at its max level (spawnRateInterval == 1)
      if ((spawnRateInterval * .95) < 1 && i == 0) {
        buttonLabels[0] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if (clickAmount == 10 && i == 1) {
        buttonLabels[1] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if (criticalChance == 80 && i == 2) {
        buttonLabels[2] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if (criticalAmount == 5 && i == 3) {
        buttonLabels[3] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if (decayRateInterval == 1800 && i == 4) {
        buttonLabels[4] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if (decayPercentage == .01 && i == 5) {
        buttonLabels[5] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      }
      if (shardWorth == 10 && i == 6) {
        buttonLabels[6] = "MAX"; // Change the label to "MAX"
        fill(30,30,30); // Make the button appear disabled
      } 
      if ( i != 6){         
        if (shard >= buttonCosts[i] && buttonLabels[i] != "MAX") {
          if(isMouseOverButton(yPos)){
            fill(150, 150, 0); // Mouse Not Hovering Over
          }
          else {
            fill(220, 220, 0); //Mouse Hovering Over            
          } 
        }         
      }    
      else if(shard >= buttonCosts[6] && buttonLabels[6] != "MAX") {
          if(isMouseOverButton(yPos)){

            colorMode(HSB,360,100,100);
            fill(color(colorCycle, 100, 100)); // Mouse Not Hovering Over
          }
          else {
            colorMode(HSB,360, 50, 50);
            fill(color(colorCycle, 100, 100)); // Mouse Hovering Over
          } 
      }
        
        
        rect(width / 2, yPos, buttonWidth, buttonHeight);
        
        colorMode(RGB,255,255,255);
        fill(255);
        textSize(19);
        text(buttonLabels[i], width / 2, yPos);
      }
  }
  else{
    fadeTimer++;
  }
}
