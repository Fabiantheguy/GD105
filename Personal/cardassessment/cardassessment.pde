/*
    ambience.loop();
    cardsSeen = 1;
    score = 0;
    textSize = 1;
    targetx = 330;
    targety = 900;
    timer = 0;
    paper.play();
    resultsSound = false;
    for(int i = 0; i < canChoose.length; i++){
      canChoose[i] = true;
    }}}
*/
// This piece aims to be a card assessment quiz on the strength of cards in card games
// and gives players results dependent on their scores. GOOD LUCK!

// Import Sound Library
import processing.sound.*;

// Declare SoundFile Variables
SoundFile ambience, paper, drum, sad, okay, nice, cheer, grayt;

// Declare Image Variables
PImage[] cardImages = new PImage[30]; // Array to store card images
String[] cardImageNames = {"Clay.jpg", "Cold.jpg", "Greed.png", "Leech.jpg", "Lotus.png", 
                           "One.jpg", "Research.png", "Pea.jpg", "Report.jpg", "Slow.jpg", 
                           "Tutor.jpg", "Shudder.png", "Magma.png", "+4.jpg", "Board.jpg", 
                           "Joker.jpg", "Neigh.png", "Leaf.jpg", "Jail.jpg", "Needle.png", 
                           "Ignoble.jpg", "Shinka.jpg", "Shira.jpg", "Ordine.png", "Feebas.png", 
                           "Sentry.png", "Haunt.jpg", "Hang.png", "Nope.jpg", "Rag.jpg"};

// Set Card Target Areas To Move To
float targetx = 330, targety = 900;

// Declare Font and Button Variables
PFont bel;
int rx = 40, gx = 710, yx = 375, ry = 525, gy = 525, yy = 550, bw = 250, bh = 100;

// Trackers and Score Brackets
int card = 1, last = 21, score = 0;
int amazing, great, good, poor, uhm;
float textSize = 1;
int colorCycle, timer;
boolean saved, resultsSound = false, canDraw = true;
int cardsSeen = 1;
boolean[] canChoose = new boolean[30];

void setup() {
  size(1000, 700);
  
  // Initialize Score Brackets
  amazing = (last/1) - (last/4);
  great = (amazing/1) - (amazing/5);
  good = (great/1) - (great/2);
  poor = (good/1) - (good/2);
  uhm = 0;
  
  // Load Font
  bel = createFont("Beleren2016-Bold.ttf", 1);
  
  // Load Images
  for (int i = 0; i < cardImages.length; i++) {
    cardImages[i] = loadImage(cardImageNames[i]);
    cardImages[i].resize(336, 468);
  }

  // Load Sounds
  ambience = new SoundFile(this, "data/Ambience.mp3");
  drum = new SoundFile(this, "data/Drum.mp3");
  paper = new SoundFile(this, "data/Paper.mp3");
  sad = new SoundFile(this, "data/Sad.mp3");
  okay = new SoundFile(this, "data/Okay.mp3");
  nice = new SoundFile(this, "data/Nice.mp3");
  cheer = new SoundFile(this, "data/Cheer.mp3");
  grayt = new SoundFile(this, "data/Great.mp3");
  
  // Set Stroke Size, Font, and Text Alignment
  stroke(255);
  textFont(bel);
  textAlign(CENTER);

  // Play Background Ambience
  ambience.loop();
  paper.play();

  // Initialize Card Accessibility
  for (int i = 0; i < canChoose.length; i++) {
    canChoose[i] = true;
  }
  canChoose[0] = false; // Example of blocking first image if needed
}

void draw() {
  background(0);
  timer += 1;

  drawButtons();
  explainerText();

  if (canDraw) {
    randomDraw();
  }

  if (timer > 5) {
    cycleCards();
    targetx = lerp(targetx, 330, 0.4);
    targety = lerp(targety, 50, 0.4);
  } else {
    targetx = 330;
    targety = 900;
  }

  if (cardsSeen == last) {
    resultsText();
  }
}

void mouseClicked() {
  if ((timer > 80 && cardsSeen == last - 1) && (onButton(rx, ry, bw, bh) || (onButton(gx, gy, bw, bh)))) {
    ambience.stop();
    drum.play();
  }

  int[] trashCards = {2, 4, 6, 8, 9, 10, 13, 19, 21, 22, 25, 26, 27, 30};
  int[] goatedCards = {1, 3, 5, 7, 11, 12, 14, 15, 16, 17, 18, 20, 23, 24, 28, 29, 31, 32};

  if (onButton(rx, ry, bw, bh) && timer > 80 && cardsSeen != last) {
    timer = 0;
    for (int i : trashCards) {
      if (card == i) {
        score += 1;
      }
    }
    if (cardsSeen < last - 1) {
      paper.play();
    }
    cardsSeen += 1;
    canDraw = true;
  }

  if (onButton(gx, gy, bw, bh) && timer > 80 && cardsSeen != last) {
    timer = 0;
    for (int i : goatedCards) {
      if (card == i) {
        score += 1;
      }
    }
    if (cardsSeen < last - 1) {
      paper.play();
    }
    cardsSeen += 1;
    canDraw = true;
  }

  if (onButton(yx, yy, bw, bh) && timer > 200) {
    resetGame();
  }
}

boolean onButton(int x, int y, int width, int height) {
  return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
}

void cycleCards() {
  if (!canDraw && cardsSeen < last) {
    for (int i = 1; i <= 30; i++) {
      if (card == i && canChoose[i]) {
        image(cardImages[i - 1], targetx, targety);
        canChoose[i] = false;
        break;
      }
    }
  }
}

void drawButtons() {
  if (timer > 60 && cardsSeen != last) {
    fill(onButton(rx, ry, bw, bh) ? 220 : 255, 0, 0);
    rect(rx, ry, bw, bh);
    fill(onButton(gx, gy, bw, bh) ? 0 : 255, onButton(gx, gy, bw, bh) ? 220 : 255, 0);
    rect(gx, gy, bw, bh);

    fill(255);
    textSize(45);
    text("Trash", 170, 590);
    text("Goated", 830, 590);
  }
}

void explainerText() {
  textSize(25);
  textLeading(20);
  if (timer > 60 && cardsSeen != last) {
    text("Numbers and symbols\n at the top of a card\n tend to show its cost.", 835, 150);
    text("While judging these\n cards, treat them as \nif you just drew them.", 180, 150);
    text("The text at the \nbottom of a card tends to\nshow the card's effect.", 180, 400);
    text("Different games have\n different objectives. Use your \nbest judgment to identify\n them as well as cards\n that get closer to them.", 835, 400);
    textSize(20);
    text("(At Face Value)", 500, 550);
    textSize(25);
    text("This card is...", 500, 600);
  }
}

void randomDraw() {
  int rand = (int) (random(1, 30));
  if (canChoose[rand]) {
    card = rand;
    canDraw = false;
  }
}

void resultsText() {
  colorCycle = frameCount % 360;
  textSize(40);
  textLeading(30);
  text("Your card assessment skills are", 500, 150);

  if (score >= uhm && score < poor) {
    displayResult("uhm...", sad, "To be completely honest, I\n don't even know if you tried...", 500, 375);
  } else if (score >= poor && score < good) {
    displayResult("Poor", okay, "You don't seem to understand what\n makes a card strong...", 500, 290);
  } else if (score >= good && score < great) {
    displayResult("Nice!", nice, "You seem to understand a bit...", 500, 325);
  } else if (score >= great && score < amazing) {
    displayResult("Great!", grayt, "You have a great grasp on what\n makes a card strong...", 500, 290);
  } else if (score >= amazing && score <= last) {
    displayResult("Amazing!", cheer, "Your understanding of card strengths is top-notch!", 500, 290);
  }
}

void displayResult(String resultText, SoundFile sound, String description, float x, float y) {
  fill(colorCycle, 255, 255);
  if (!resultsSound) {
    sound.play();
    resultsSound = true;
  }
  text(resultText, 500, 210);
  textSize(25);
  fill(255);
  text(description, x, y);
}

void resetGame(){
    ambience.loop();
    cardsSeen = 1;
    score = 0;
    textSize = 1;
    targetx = 330;
    targety = 900;
    timer = 0;
    paper.play();
    resultsSound = false;
    for(int i = 0; i < canChoose.length; i++){
      canChoose[i] = true;  
}
