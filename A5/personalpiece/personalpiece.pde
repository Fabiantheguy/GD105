Car car;
ArrayList<Coin> coins;
int collectedCoins = 0;
PGraphics trackMask; // Mask to define the race track
int tileSize = 20;   // Smaller size for tiles
int timer = 15;      // Timer starts at 15 seconds
boolean gameOver = false; // Game state tracker
int lastTime;        // Track time for timer updates

void setup() {
  fullScreen(); // Fullscreen mode
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
    fill(255,0,0);
    textSize(20);
    text("Coins Collected: " + collectedCoins, 10, 20);
    text("Time Left: " + timer, 10, 50);
  } else {
    // Game over screen
    background(0);
    fill(255, 0, 0);
    textSize(40);
    text("You Lose!", width / 2 - 100, height / 2 - 20);

    // Retry button
    fill(255);
    rect(width / 2 - 75, height / 2 + 20, 150, 50);
    fill(0);
    textSize(20);
    text("Retry", width / 2 - 30, height / 2 + 55);
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

// Draw the race track
void drawRaceTrack() {
  trackMask.beginDraw();
  trackMask.background(255); // White background (drivable)

  trackMask.fill(0); // Black areas are impassable
  trackMask.noStroke();

  int tileMargin = tileSize * 2; // Margin size for the outer wall

  // Outer border (impassable)
  trackMask.rect(0, 0, width, tileMargin); // Top
  trackMask.rect(0, height - tileMargin, width, tileMargin); // Bottom
  trackMask.rect(0, 0, tileMargin, height); // Left
  trackMask.rect(width - tileMargin, 0, tileMargin, height); // Right

  // Center block (impassable)
  int centerMargin = 6 * tileSize;
  trackMask.rect(centerMargin, centerMargin, width - 2 * centerMargin, height - 2 * centerMargin);

  // Create square obstacles around the track edges
  int obstacleSize = 4 * tileSize;
  int gapSize = 6 * tileSize; // Gaps between obstacles to ensure connectivity

  // Top row obstacles
  for (int x = tileMargin; x < width - tileMargin; x += obstacleSize + gapSize) {
    trackMask.fill(0); // Black obstacles
    trackMask.rect(x, tileMargin, obstacleSize, obstacleSize);
  }

  // Bottom row obstacles
  for (int x = tileMargin; x < width - tileMargin; x += obstacleSize + gapSize) {
    trackMask.fill(0);
    trackMask.rect(x, height - tileMargin - obstacleSize, obstacleSize, obstacleSize);
  }

  // Left column obstacles
  for (int y = tileMargin; y < height - tileMargin; y += obstacleSize + gapSize) {
    trackMask.fill(0);
    trackMask.rect(tileMargin, y, obstacleSize, obstacleSize);
  }

  // Right column obstacles
  for (int y = tileMargin; y < height - tileMargin; y += obstacleSize + gapSize) {
    trackMask.fill(0);
    trackMask.rect(width - tileMargin - obstacleSize, y, obstacleSize, obstacleSize);
  }

  // Create square gaps in the outer border for entry/exit points
  int holeSize = 4 * tileSize;

  trackMask.fill(255); // Ensure entry/exit points are passable
  // Top border hole
  trackMask.rect(width / 2 - holeSize / 2, tileMargin, holeSize, tileMargin);

  // Bottom border hole
  trackMask.rect(width / 2 - holeSize / 2, height - tileMargin, holeSize, tileMargin);

  // Left border hole
  trackMask.rect(tileMargin, height / 2 - holeSize / 2, tileMargin, holeSize);

  // Right border hole
  trackMask.rect(width - tileMargin, height / 2 - holeSize / 2, tileMargin, holeSize);

  trackMask.endDraw();
}







class Car {
  float x, y;
  float speed = 1.5; // Adjusted for smaller scale
  float size = tileSize - 4; // Slightly smaller than a tile for visibility

  Car() {
    x = tileSize * 10; // Start on the track
    y = tileSize * 10;
  }

  void update() {
    float nextX = x;
    float nextY = y;

    // Handle diagonal movement first
    if (keysPressed.contains('w') && keysPressed.contains('a')) {
      if (isOnTrack(x - speed, y)) nextX -= speed;
      if (isOnTrack(x, y - speed)) nextY -= speed;
    } else if (keysPressed.contains('w') && keysPressed.contains('d')) {
      if (isOnTrack(x + speed, y)) nextX += speed;
      if (isOnTrack(x, y - speed)) nextY -= speed;
    } else if (keysPressed.contains('s') && keysPressed.contains('a')) {
      if (isOnTrack(x - speed, y)) nextX -= speed;
      if (isOnTrack(x, y + speed)) nextY += speed;
    } else if (keysPressed.contains('s') && keysPressed.contains('d')) {
      if (isOnTrack(x + speed, y)) nextX += speed;
      if (isOnTrack(x, y + speed)) nextY += speed;
    } else {
      // Handle non-diagonal movement
      if (keysPressed.contains('w') && isOnTrack(x, y - speed)) nextY -= speed;
      if (keysPressed.contains('s') && isOnTrack(x, y + speed)) nextY += speed;
      if (keysPressed.contains('a') && isOnTrack(x - speed, y)) nextX -= speed;
      if (keysPressed.contains('d') && isOnTrack(x + speed, y)) nextX += speed;
    }

    x = nextX;
    y = nextY;
  }

  void display() {
    fill(255, 0, 0);
    rect(x, y, size, size);
  }

  boolean collects(Coin c) {
    float d = dist(x + size / 2, y + size / 2, c.x, c.y);
    return d < size / 2 + c.size / 2;
  }

  boolean isOnTrack(float px, float py) {
    // Check all four corners of the car
    return isPixelOnTrack(px, py) && 
           isPixelOnTrack(px + size, py) && 
           isPixelOnTrack(px, py + size) && 
           isPixelOnTrack(px + size, py + size);
  }

  boolean isPixelOnTrack(float px, float py) {
    // Sample the mask color at the given position
    if (px < 0 || px >= width || py < 0 || py >= height) {
      return false; // Out of bounds
    }
    int c = trackMask.get((int)px, (int)py);
    return c == color(0); // Check if the color is black
  }
}

class Coin {
  float x, y;
  float size = tileSize / 2;

  Coin() {
    // Spawn coins only on black areas of the track
    do {
      x = floor(random(width / tileSize)) * tileSize + tileSize / 2;
      y = floor(random(height / tileSize)) * tileSize + tileSize / 2;
    } while (!isOnTrack(x, y));
  }

  void display() {
    fill(255, 223, 0);
    ellipse(x, y, size, size);
  }

  boolean isOnTrack(float px, float py) {
    int c = trackMask.get((int)px, (int)py);
    return c == color(0); // Check if the color is black
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
