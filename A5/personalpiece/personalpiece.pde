Car car;
ArrayList<Coin> coins;
PFont arcadelFont; // Font object to hold ARCADECLASSIC.TTF

int collectedCoins = 0;
PGraphics trackMask; // Mask to define the race track
int tileSize = 20;   // Smaller size for tiles
int timer = 15;      // Timer starts at 15 seconds
boolean gameOver = false; // Game state tracker
int lastTime;        // Track time for timer updates

void setup() {
  fullScreen(); // Fullscreen mode
  arcadelFont = createFont("ARCADECLASSIC.TTF", 64); // Load the custom font with a larger size
  textFont(arcadelFont);
  car = new Car();
  coins = new ArrayList<Coin>();
  lastTime = millis(); // Initialize time tracker

  // Create the track mask
  trackMask = createGraphics(width, height);
  drawRaceTrack();

  // Add initial coins
  for (int i = 0; i < 15; i++) { // More coins since the track is larger
    coins.add(new Coin());
  }
}

void draw() {
  if (!gameOver) {
    // Timer logic
    if (millis() - lastTime >= 1000) {
      timer--; // Decrease timer by 1 every second
      lastTime = millis(); // Reset time tracker
    }

    // End game if timer hits 0
    if (timer <= 0) {
      gameOver = true;
    }

    // Draw the track
    image(trackMask, 0, 0);

    // Update and display the car
    car.update();
    car.display();

    // Display and handle coin collection
    for (int i = coins.size() - 1; i >= 0; i--) {
      Coin c = coins.get(i);
      c.display();

      if (car.collects(c)) {
        coins.remove(i);
        collectedCoins++;
        car.speed += 0.25; // Increase car speed
        coins.add(new Coin()); // Add a new coin

        // Reset timer based on collected coins
        timer = 15 - (collectedCoins / 3);
        if (timer < 2){
          timer = 2;
        }
      }
    }

    // Display score and timer
    fill(0,255,0);
    textSize(15);
    textAlign(TOP, LEFT); // Center the text
    text("Coins Collected: " + collectedCoins, 10, 20);
    text("Time Left: " + timer, 10, 35);
  } else {
    // Game over screen
    background(0);
    fill(255, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER); // Center the text
    text("You Lose!", width / 2, height / 2 - 50); // Adjusted to center text
  
    // Retry button
    fill(255);
    rect(width / 2 - 75, height / 2 + 20, 150, 50); // Adjusted to center the button
    fill(0);
    textSize(20);
    text("Retry", width / 2, height / 2 + 45); // Adjusted to center text
  }
}

// Reset game
void resetGame() {
  car = new Car();
  coins.clear();
  collectedCoins = 0;
  timer = 15;
  gameOver = false;

  // Add initial coins
  for (int i = 0; i < 15; i++) {
    coins.add(new Coin());
  }
}

// Track mouse clicks for retry button
void mousePressed() {
  if (gameOver && mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height / 2 + 20 && mouseY < height / 2 + 70) {
    resetGame();
  }
}

// Key press tracking
ArrayList<Character> keysPressed = new ArrayList<Character>();

void keyPressed() {
  if (!keysPressed.contains(key)) {
    keysPressed.add(key);
  }
}

void keyReleased() {
  keysPressed.remove(Character.valueOf(key));
}
