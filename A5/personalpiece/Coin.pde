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
