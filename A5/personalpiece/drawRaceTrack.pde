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
