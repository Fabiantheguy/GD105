Car car;
ArrayList<Coin> coins;
int collectedCoins = 0;
int backgroundColor = color(135, 206, 235);
ArrayList<Character> keysPressed = new ArrayList<Character>(); // Track pressed keys

void setup() {
  size(800, 600);
  car = new Car();
  coins = new ArrayList<Coin>();

  // Add initial coins
  for (int i = 0; i < 10; i++) {
    coins.add(new Coin());
  }
}

void draw() {
  // Change background color based on coins collected
  backgroundColor = color(135 - collectedCoins * 10, 206 - collectedCoins * 10, 235 - collectedCoins * 10);
  background(backgroundColor);

  car.update();
  car.display();

  for (int i = coins.size() - 1; i >= 0; i--) {
    Coin c = coins.get(i);
    c.display();

    // Check if the car collects a coin
    if (car.collects(c)) {
      coins.remove(i);
      collectedCoins++;
      car.speed += 0.5; // Increase car speed

      // Add a new coin
      coins.add(new Coin());
    }
  }

  // Display score
  fill(255);
  textSize(20);
  text("Coins Collected: " + collectedCoins, 10, 20);
}

class Car {
  float x, y;
  float speed = 2;
  float size = 40;

  Car() {
    x = width / 2;
    y = height - 100;
  }

  void update() {
    // Check the latest pressed key
    if (!keysPressed.isEmpty()) {
      char currentKey = keysPressed.get(keysPressed.size() - 1); // Get the most recent key
      if (currentKey == 'w') y -= speed;
      if (currentKey == 's') y += speed;
      if (currentKey == 'a') x -= speed;
      if (currentKey == 'd') x += speed;
    }

    // Keep car on screen
    x = constrain(x, 0, width - size);
    y = constrain(y, 0, height - size);
  }
void display() {
    fill(255, 0, 0);
    rect(x, y, size, size);
  }

  boolean collects(Coin c) {
    float d = dist(x + size / 2, y + size / 2, c.x, c.y);
    return d < size / 2 + c.size / 2;
  }
}

class Coin {
  float x, y;
  float size = 20;

  Coin() {
    x = random(width);
    y = random(height);
  }

  void display() {
    fill(255, 223, 0);
    ellipse(x, y, size, size);
  }
}

// Track key presses in order
void keyPressed() {
  if (!keysPressed.contains(key)) {
    keysPressed.add(key);
  }
}

void keyReleased() {
  keysPressed.remove(Character.valueOf(key));
}
