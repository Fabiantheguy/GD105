/* This piece is a reimagined version of my previous personal piece.
   Rather than make guesses on if a card is good, this quiz aims to
   see if the player knows how to compare power. I made use of 
   arrays and for loops in order to keep the code more concise and less
   redundant. The game tells the player if they're doing well and I plan
   to make the game give reasons why one card is better in the future.
*/
// Load the necessaly libraries
import processing.sound.*;

// Declare SoundFile Variables
SoundFile ambience, paper, drum, sad, okay, nice, cheer, grayt, ding, buzz;
  // The Card In The Array That Are Better
  int[] betterCards = {1, 2, 5, 6, 9, 11, 13, 15, 16, 19, 21};
// Declares The Name Of Games
String[] gameNames = {"MTG", "MTG", "Po-ké-mon!", "Po-ké-mon!", "MTG", "Unstable Unicorns", "Yu-Gi-Oh!", "Yu-Gi-Oh!", "Hearthstone", "MTG", "Yu-Gi-Oh!", "Yu-Gi-Oh!",
  "MTG", "MTG","MTG", "MTG", "MTG", "MTG", "UNO", "UNO", "Unstable Unicorns", "UNO", "MTG", "MTG"};
// Declares The Name Of Cards 
String[] cardNames = {"Raider.jpg", "Orcs.jpg", "Young.png", "Main.png", "Essence.jpg", "Neigh.png", "Rai.png", "Hole.png", "Intel.png", "Arch.jpg", 
  "Neg.png", "Threat.jpg", "Basari.jpg", "Raid.jpg",  "Thrill.jpg", "Demand.jpg", "Recall.jpg", "Mise.jpg",
  "Wild.jpg", "+4.jpg", "Hang.png", "Skip.jpg", "Counsel.jpg", "Tutor.jpg", "Needle.png", "Ignoble.jpg", "Shinka.jpg",
  "Shira.jpg", "Ordine.png", "Feebas.png", "Sentry.png", "Haunt.jpg", "Nope.jpg", "Rag.jpg", "Greed.png", "Research.png",  "Skip.jpg", "Sun.png" };
PImage[] cardImages = new PImage[cardNames.length];

// Set Target Areas For Cards;
float ltargetx, ltargety, rtargetx, rtargety;
String lgame, rgame;
PFont bel;
int lx = 100, rx = 800, yx = 430, ly = 750, ry = 750, yy = 750, bw = 420, bh = 100;
// Handles The Current Card, & Current Score
int card = 1, score = 0;
int amazing, great, good, poor, uhm;
float textSize = 1, redScoreColor;
int colorCycle, timer;
boolean saved, resultsSound = false, canDraw = true, firstSet = true, correct = false, wrong = false;
int setsSeen = 1;
boolean[] canChoose = new boolean[cardNames.length];

// Sets The Last Set To Be Right After The Last Set Of Cards Is Shown
int last = (gameNames.length / 2) + 1;
void setup() {
  size(1300, 1000);
  // Set Score Ranges
  amazing = (last / 1) - (last / 4);
  great = (amazing / 1) - (amazing / 5);
  good = (great / 1) - (great / 2);
  poor = (good / 1) - (good / 2);
  uhm = 0;
  card = 0;
  
  // Load Sounds
  ambience = new SoundFile(this, "data/Ambience.mp3");
  drum = new SoundFile(this, "data/Drum.mp3");
  paper = new SoundFile(this, "data/Paper.mp3");
  sad = new SoundFile(this, "data/Sad.mp3");
  okay = new SoundFile(this, "data/Okay.mp3");
  nice = new SoundFile(this, "data/Nice.mp3");
  cheer = new SoundFile(this, "data/Cheer.mp3");
  grayt = new SoundFile(this, "data/Great.mp3");
  ding = new SoundFile(this, "data/Ding.mp3");
  buzz = new SoundFile(this, "data/Wrong.mp3");
  
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
  
  
  // Play Background Ambience
  ambience.loop();
  paper.play();
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
  if(setsSeen == last){
    resultsText();
}}

void mouseClicked() {
  if ((timer > 80 && setsSeen == last - 1) && (onButton(lx, ly, bw, bh) || onButton(rx, ry, bw, bh))) {
     drum.play(); // Drum sound
  }

  // Handle button clicks for scoring
  if (onButton(lx, ly, bw, bh) && timer > 80 && setsSeen != last) updateScoreAndCards("left");
  if (onButton(rx, ry, bw, bh) && timer > 80 && setsSeen != last) updateScoreAndCards("right");
  if (onButton(yx, yy, bw, bh) && timer > 200 && setsSeen == last) resetGame();
}

boolean onButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height);
}

void updateScoreAndCards(String side) {
  timer = 0;
  if ((side == "left" && isCorrect(card)) || side == "right" && isCorrect(card + 1)){ding.play(); score++; correct = true;}
  else{
  correct = false;
  buzz.play();
  }
  
  paper.play();
  print(card);
  setsSeen += 1;
  canDraw = true;
}

void resetGame() {
  ambience.loop();
  card = 0;
  setsSeen = 1;
  score = 0;
  textSize = 1;
  timer = 0;
paper.play();
  resultsSound = false;
  for (int i = 0; i < canChoose.length; i++) canChoose[i] = true;
}

void cycleCards() {
  if (!canDraw && setsSeen < last) {
    lgame = gameNames[card];
    rgame =  gameNames[card + 1];;
    image(cardImages[card], ltargetx, ltargety);
    image(cardImages[card + 1], rtargetx, rtargety);
    canChoose[card] = false;
  }
}

void drawButtons() {
  if (timer > 60 && setsSeen != last) {
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
  if(timer < 50 && setsSeen > 1){
    if(correct){
    fill(0, 255, 0);
    }
    else{
    fill(255,0,0);
    }
  }
  else{
    fill(255,255,255);
  }
  textSize(40);
  text("Score: " + score, width/2, 50);
  if (timer > 60 && setsSeen != last) {
    fill(255);
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
  if (firstSet) {
    firstSet = false;
    canDraw = false;
  }
  else{canDraw = false;; card += 2;
}
}
boolean isCorrect(int card) {
  return contains(betterCards, card);
}

boolean contains(int[] array, int value) {
  for (int i : array) if (i == value) return true;
  return false;
}

void resultsText(){
colorCycle = frameCount%360;
textSize(40); 
textLeading(30);
fill(255);
text("Your card assessment skills are", width/2, 150);
textSize(textSize);
if(score >= uhm && score < poor){
fill(21,71,34);
if(timer > 140){
text("uhm...", width/2,230);
}
fill(255);
if(timer > 160 && resultsSound == false){
  sad.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("To be completely honest, I\n don't even know if you tried...", width/2,375);
}
}
if(score >= poor && score < good){
if(timer > 140){
text("Poor", width/2,230);
}
if(timer > 160 && resultsSound == false){
  okay.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You don't seem to understand what\n makes a card strong, but you have\nwhat it takes to start learning.\n Playing more card games is the best\n way to build this instinct.", width/2,290);
}
}
if(score >= good && score < great){
if(timer > 140){
text("Nice!", width/2,230);
}
if(timer > 160 && resultsSound == false){
  nice.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You seem to understand a bit of what\n makes a card strong, but still have \nroom to understand more. Try \nagain and see if you can do better.", width/2,325);
}
}
if(score >= great && score < amazing){
if(timer > 140){
text("Great!", width/2,230);
}
if(timer > 160 && resultsSound == false){
  grayt.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You have a great grasp on what\n makes a card strong, and most likely\n have a solid understanding of card\n games as a form of play. You likely\ndon't struggle to pick up new ones.", width/2,290);
}
}
if(score >= amazing && score + 1 < last){
fill(255,255,0);
if(timer > 140){
text("AMAZING!", width/2,230);
}

fill(255);
if(timer > 160 && resultsSound == false){
  cheer.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You are excellent at\n evaluating a card's strengths, and\n are more often than not, great\n at picking up new ones.", width/2,300);
}}
if(score + 1 >= last){
colorMode(HSB,360,100,100);
fill(color(colorCycle, 100, 100));
if(timer > 140){
text("PERFECT!!!", width/2,230);
}
colorMode(RGB,255,255,255);
fill(255,255,255);
if(timer > 160 && resultsSound == false){
  cheer.play();
  resultsSound = true;
}if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You have S-Tier judgement abilities!\n There wasn't a single misstep in your \njudgement or knowledge! Stand pround!\n YOU ARE STRONG!", width/2, 290);
}}
if(timer > 140 && textSize < 59){
textSize += 4;}
if(timer > 300){
  save("results.png");
// Draw Retry Button
  if(onButton(yx,yy,bw,bh)){
  fill(220,220,0);
  }
else{
  fill(255,255,0);
}
  rect(yx,yy,bw,bh);
  fill(255);
  text("Retry?", width/2, yy + 70);

}
}
