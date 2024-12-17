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
