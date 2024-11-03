// Load the necessaly libraries
import processing.sound.*;

// Declare variables
SoundFile[] sounds = new SoundFile[8];
// Sets The Array For Cards To Grab
PImage[] cardImages = new PImage[37];
// Declares The Name Of Games
String[] gameNames = {"MTG", "MTG", "Yu-Gi-Oh!",  "Po-ké-mon!"};
// Declares The Name Of Cards 
String[] cardNames = {"Raider.jpg", "Orcs.jpg", "Evil.jpg", "Chariz.jpg", "Lotus.png", "One.jpg", "Pea.jpg", "Report.jpg", "Slow.jpg", "Tutor.jpg", 
  "Shudder.png", "Magma.png", "+4.jpg", "Board.jpg", "Joker.jpg", "Neigh.png", "Leaf.jpg", "Jail.jpg", "Needle.png", "Ignoble.jpg", "Shinka.jpg",
  "Shira.jpg", "Ordine.png", "Feebas.png", "Sentry.png", "Haunt.jpg", "Hang.png", "Nope.jpg", "Rag.jpg", "Greed.png", "Research.png", "Raid.jpg", "Basari.jpg", "Essence.jpg", "Skip.jpg", "Sun.png" };

// Sound file names
String[] soundNames = { "Ambience.mp3", "Drum.mp3", "Paper.mp3", "Sad.mp3", "Okay.mp3", "Nice.mp3", "Cheer.mp3", "Great.mp3" };

// Set Target Areas For Cards;
float ltargetx, ltargety, rtargetx, rtargety;
String lgame, rgame;
PFont bel;
int lx = 100, rx = 800, yx = 375, ly = 750, ry = 750, yy = 750, bw = 420, bh = 100;
int card = 1, last = 21, score = 0;
int amazing, great, good, poor, uhm;
float textSize = 1;
int colorCycle, timer;
boolean saved, resultsSound = false, canDraw = true, firstSet = true;
int cardsSeen = 1;
boolean[] canChoose = new boolean[cardNames.length];

void setup() {
  size(1300, 1000);
  // Set Score Ranges
  amazing = (last / 1) - (last / 4);
  great = (amazing / 1) - (amazing / 5);
  good = (great / 1) - (great / 2);
  poor = (good / 1) - (good / 2);
  uhm = 0;
  card = 0;
  
  // Set up font
  bel = createFont("Beleren2016-Bold.ttf", 1);
  textFont(bel);
  textAlign(CENTER);
  
  // Load images and resize them
  for (int i = 0; i < cardNames.length; i++) {
    cardImages[i] = loadImage(cardNames[i]); 
    cardImages[i].resize(420, 585);
    canChoose[i] = true;
  }
  canChoose[0] = false;
  
  // Load sounds
  for (int i = 0; i < soundNames.length; i++) {
    sounds[i] = new SoundFile(this, "data/" + soundNames[i]);
  }
  
  // Start ambience and first sound
  sounds[0].loop();
  sounds[2].play();
}

void draw() {
  background(0);
  timer += 1;
  drawButtons();
  explainerText();
  if (canDraw) Draw();

  if (timer > 5) {
    cycleCards();
    ltargetx = lerp(ltargetx, 100, 0.4);
    ltargety = lerp(ltargety, 100, 0.4);
    rtargetx = lerp(rtargetx, 800, 0.4);
    rtargety = lerp(rtargety, 100, 0.4);
  } else {
    ltargetx = 100;
    ltargety = 2000;
    rtargetx = 800;
    rtargety = 2000;
  }
  if (cardsSeen == last) resultsText();
    print(isCorrect(card) + "\n" + score);
}

void mouseClicked() {
  if ((timer > 80 && cardsSeen == last - 1) && (onButton(lx, ly, bw, bh) || onButton(rx, ry, bw, bh))) {
    sounds[1].play(); // Drum sound
  }

  // Handle button clicks for scoring
  if (onButton(lx, ly, bw, bh) && timer > 80 && cardsSeen != last) updateScoreAndCards("left");
  if (onButton(rx, ry, bw, bh) && timer > 80 && cardsSeen != last) updateScoreAndCards("right");
  if (onButton(yx, yy, bw, bh) && timer > 200) resetGame();
}

boolean onButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height);
}

void updateScoreAndCards(String side) {
  timer = 0;
  if ((side == "left" && isCorrect(card))) score += 1;
  if ((side == "right" && isCorrect(card + 1))) score += 1;
  if (cardsSeen < last - 1) sounds[2].play(); // Paper sound
  cardsSeen += 1;
  canDraw = true;
}

void resetGame() {
  sounds[0].loop();
  cardsSeen = 1;
  score = 0;
  textSize = 1;
  timer = 0;
  sounds[2].play();
  resultsSound = false;
  for (int i = 0; i < canChoose.length; i++) canChoose[i] = true;
}

void cycleCards() {
  if (!canDraw && cardsSeen < last) {
    lgame = gameNames[card];
    rgame =  gameNames[card + 1];;
    image(cardImages[card], ltargetx, ltargety);
    image(cardImages[card + 1], rtargetx, rtargety);
    canChoose[card] = false;
  }
}

void drawButtons() {
  if (timer > 60 && cardsSeen != last) {
    drawButton(lx, ly, "This One!", onButton(lx, ly, bw, bh));
    drawButton(rx, ry, "This One!", onButton(rx, ry, bw, bh));
  }
}

void drawButton(int x, int y, String text, boolean isHovered) {
  fill(isHovered ? color(0, 220, 0) : color(0, 255, 0));
  rect(x, y, bw, bh);
  fill(255);
  textSize(45);
  text(text, x + bw / 2, y + 60);
}

void explainerText() {
  textSize(40);
  if (timer > 60 && cardsSeen != last) {
    textSize(100);
    text("VS.", 650, 400);
    textSize(40);
    text("Which card is", 662.5, 800);
    text("better?", 662.5, 840);
    text(lgame, 315, 90);
    text(rgame, 1015, 90);
  }
}

void Draw() {
  print(score);
  if (firstSet) {
    firstSet = false;
    canDraw = false;
  }
  else{canDraw = false;; card += 2;
}
}
boolean isCorrect(int card) {
  // The Card In The Array That Are Better
  int[] betterCards = {1, 2, 3, 7, 11, 12, 14, 15, 16, 17, 18, 20, 23, 24, 28, 29, 31, 32};
  return contains(betterCards, card);
}

boolean contains(int[] array, int value) {
  for (int i : array) if (i == value) return true;
  return false;
}

void resultsText() {
  // Handle color cycling and display final result based on score ranges
  colorCycle = frameCount % 360;
  if (!resultsSound) {
    int soundIdx = score >= amazing ? 6 : score >= great ? 7 : score >= good ? 5 : score >= poor ? 4 : 3;
    sounds[soundIdx].play();
    resultsSound = true;
  }
  // Display result text based on the score
}
