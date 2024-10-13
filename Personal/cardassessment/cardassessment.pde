//This piece aims to be a card assessment quiz on the strength of cards in card games
//and gives players results dependant on their scores. I pulled from a variety of
//sources and randomized the cards shown. GOOD LUCK!

//I plan on fleshing out the results screen with more color, sounds, and descriptions.
//Maybe even adding more cards.

// Grab The Sound Library
import processing.sound.*;
//Declare SoundFile Variables
SoundFile ambience;
SoundFile paper;
SoundFile drum;
SoundFile sad;
SoundFile okay;
SoundFile nice;
SoundFile cheer;
SoundFile grayt;
// Declare Image Variables
PImage clay;
PImage cold;
PImage leech;
PImage lotus;
PImage one;
PImage pea;
PImage report;
PImage slow;
PImage tutor;
PImage shudder;
PImage magma;
PImage plus;
PImage board;
PImage joker;
PImage neigh;
PImage leaf;
PImage jail;
PImage needle;
PImage ignoble;
PImage shinka;
PImage shira;
PImage ordine;
PImage feebas;
PImage sentry;
PImage haunt;
PImage hang;
PImage nope;
PImage rag;
PImage greed;
PImage research;

// Set Card Target Areas To Move To
float targetx = 330;
float targety = 900;
// Declare Font Name
PFont bel;
// Declare Button Vectors (r = red, g = green)
int rx = 40;
int gx = 710;
int yx = 375;
int ry = 525;
int gy = 525;
int yy = 550;
// Declare Button Sizes
int bw = 250;
int bh = 100;
// Tracks The Current Card Number
int card = 1;
//Tracks The Amount Of Cards Pulled Up (Must Be 8 Or Greater To Function Correctly)
int last = 21;
// Tracks The Player's Score
int score = 0;

// Tracks Score Brackets
int amazing;
int great;
int good;
int poor;
int uhm;
// Growing Text Size For Final Results
float textSize = 1;
// Colors For Perfect Text
int colorCycle;

// A Rising Timer For Cooldowns
int timer;
// Checks If The Score's Already Been Saved
boolean saved;
// Checks If Results Sound Has Played
boolean resultsSound = false;
// Checks To See If A Random Card Can Be Drawn
boolean canDraw = true;
// Checks The Amount Of Cards Seen
int cardsSeen = 1;
// Declares What Cards Can't Be Drawn
boolean[] canChoose = new boolean[30];
void setup() {
  size(1000, 700);
// Set Score Brackets (Last Must Be 4 Or Greater To Function As Intended)
 amazing = (last/1) - (last/4);
 great = (amazing/1) - (amazing/5);
 good = (great/1) - (great/2);
 poor = (good/1) - (good/2);
 uhm = 0;
 print(amazing,great,good,poor,uhm);
// Define Font Variable
  bel = createFont("Beleren2016-Bold.ttf", 1);
// Define Image Variables
  clay = loadImage("Clay.jpg");
  cold = loadImage("Cold.jpg");
  leech = loadImage("Leech.jpg");
  lotus = loadImage("Lotus.png");
  one = loadImage("One.jpg");
  pea = loadImage("Pea.jpg");
  report = loadImage("Report.jpg");
  slow = loadImage("Slow.jpg");
  tutor = loadImage("Tutor.jpg");
  shudder = loadImage("Shudder.png");
  magma = loadImage("Magma.png");
  plus = loadImage("+4.jpg");
  board = loadImage("Board.jpg");
  joker = loadImage("Joker.jpg");
  neigh = loadImage("Neigh.png");
  leaf = loadImage("Leaf.jpg");
  jail = loadImage("Jail.jpg");
  needle = loadImage("Needle.png");
  ignoble = loadImage("Ignoble.jpg");
  shinka = loadImage("Shinka.jpg");
  shira = loadImage("Shira.jpg");
  ordine = loadImage("Ordine.png");
  feebas = loadImage("Feebas.png");
  sentry = loadImage("Sentry.png");
  haunt = loadImage("Haunt.jpg");
  hang = loadImage("Hang.png");
  nope = loadImage("Nope.jpg");
  rag = loadImage("Rag.jpg");
  greed = loadImage("Greed.png");
  research = loadImage("Research.png");
// Define SoundFile Variables
  ambience = new SoundFile(this, "data/Ambience.mp3");
  drum = new SoundFile(this, "data/Drum.mp3");
  paper = new SoundFile(this, "data/Paper.mp3");
  sad = new SoundFile(this, "data/Sad.mp3");
  okay = new SoundFile(this, "data/Okay.mp3");
  nice = new SoundFile(this, "data/Nice.mp3");
  cheer = new SoundFile(this, "data/Cheer.mp3");
  grayt = new SoundFile(this, "data/Great.mp3");
// Set Stroke Size
  stroke(255);
// Set Font & Align
  textFont(bel);
  textAlign(CENTER);
// Play Ambience
  ambience.loop();
// Play First Draw Sound
  paper.play();
  

// Resize Images
  clay.resize(336, 468);
  cold.resize(336, 468);
  leech.resize(336, 468);
  lotus.resize(336, 468);
  one.resize(336, 468);
  pea.resize(336, 468);
  report.resize(336, 468);
  slow.resize(336, 468);
  tutor.resize(336, 468);
  shudder.resize(336, 468);
  magma.resize(336, 468);
  plus.resize(336, 468);
  board.resize(336, 468);
  joker.resize(336, 468);
  neigh.resize(336, 468);
  leaf.resize(336, 468);
  jail.resize(336, 468);
  needle.resize(336, 468);
  ignoble.resize(336, 468);
  shinka.resize(336, 468);
  shira.resize(336, 468);
  ordine.resize(336, 468);
  feebas.resize(336, 468);
  sentry.resize(336, 468);
  haunt.resize(336, 468);
  hang.resize(336, 468);
  nope.resize(336, 468);
  rag.resize(336, 468);
  greed.resize(336, 468);
  research.resize(336, 468);
// Makes All Cards Given Accessible
  for(int i = 0; i < canChoose.length; i++){
    canChoose[i] = true;
  }
  canChoose[0] = false;
}

void draw() {
  // Draw Background
  background(0);
// Increase Timer
  timer += 1;
// Creates The Red & Green Buttons & Explainer Text
  drawButtons();
  explainerText();
  if(canDraw == true){
    randomDraw();}
// Move Card After Cooldown
  if(timer > 5){
  // Cycle Between Cards
  cycleCards();
  targetx = lerp(targetx, 330, 0.4);
  targety = lerp(targety, 50, 0.4);
  }
  else{
  targetx = 330;
  targety = 900;
  }
if(cardsSeen == last){
  resultsText();
}
}
void mouseClicked(){
  // Wait For Buttons To Spawn In Game To Be Reset
   if((timer > 80 && cardsSeen == last - 1) && (onButton(rx,ry,bw,bh) || (onButton(gx,gy,bw,bh)))){
     ambience.stop();
     drum.play();
    }
        if(onButton(rx,ry,bw,bh) && timer > 80 && cardsSeen != last) {
    timer = 0;
    // Increase Score If Trash Was Chosen Correctly
    if(card == 2 || card == 4 || card == 6 || card == 8 || card == 9 || card == 10 || card == 13 || card == 19 || card == 21 || card == 22 || card == 25 || card == 26 || card == 27 || card == 30){
      score += 1;
    }
    if(cardsSeen < last - 1){
      paper.play();
    }
    cardsSeen += 1;
    canDraw = true;
    } 
  if(onButton(gx,gy,bw,bh) && timer > 80 && cardsSeen != last) {
    timer = 0;
    // Increase Score If Goated! Was Chosen Correctly
      if(card == 1 || card == 3 ||  card == 5 ||  card == 7 || card == 11 || card == 12|| card == 14 || card == 15 || card == 16 || card == 17 || card == 18 || card == 20 || card == 23 || card == 24 || card == 28 || card == 29 || card == 31 || card == 32){
      score += 1;
    }
    if(cardsSeen < last - 1){
       paper.play();
    }
    cardsSeen += 1;
    canDraw = true;
    }
    if(onButton(yx,yy,bw,bh) && timer > 200){
    // Reset All Values
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
boolean onButton(int x, int y, int width, int height)  
// Checks if the mouse is inside the given coordinates and returns a boolean
{
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
void cycleCards(){
  if(canDraw == false && cardsSeen < last){
   if(card == 1){
     image(clay, targetx, targety);
     canChoose[1] = false;
   };
   if(card == 2){
     image(cold, targetx, targety);
     canChoose[2] = false;
   }
   if(card == 3){
     image(greed, targetx, targety);
     canChoose[3] = false;
   }
    if(card == 4){
     image(leech, targetx, targety);
     canChoose[4] = false;
   }
    if(card == 5){
     image(lotus, targetx, targety);
     canChoose[5] = false;
   }
    if(card == 6){
     image(one, targetx, targety);
     canChoose[6] = false;
   }
    if(card == 7){
     image(research, targetx, targety);
     canChoose[7] = false;
   }
    if(card == 8){
     image(pea, targetx, targety);
     canChoose[8] = false;
   }
    if(card == 9){
     image(report, targetx, targety);
     canChoose[9] = false;
   }
    if(card == 10){
     image(slow, targetx, targety);
     canChoose[10] = false;
   }
    if(card == 11){
     image(tutor, targetx, targety);
     canChoose[11] = false;
   }
    if(card == 12){
     image(shudder, targetx, targety);
     canChoose[12] = false;
   }    
    if(card == 13){
     image(magma, targetx, targety);
     canChoose[13] = false;
   }
    if(card == 14){
     image(plus, targetx, targety);
     canChoose[14] = false;
   }
    if(card == 15){
     image(board, targetx, targety);
     canChoose[15] = false;
   }
    if(card == 16){
     image(joker, targetx, targety);
     canChoose[16] = false;
   }
    if(card == 17){
     image(neigh, targetx, targety);
     canChoose[17] = false;
   }
    if(card == 18){
     image(leaf, targetx, targety);
     canChoose[18] = false;
   }
    if(card == 19){
     image(jail, targetx, targety);
     canChoose[19] = false;
   }
    if(card == 20){
     image(needle, targetx, targety);
     canChoose[20] = false;
   }
    if(card == 21){
     image(ignoble, targetx, targety);
     canChoose[21] = false;
   }
    if(card == 22){
     image(shinka, targetx, targety);
     canChoose[22] = false;
   }
    if(card == 23){
     image(shira, targetx, targety);
     canChoose[23] = false;
   }
    if(card == 24){
     image(ordine, targetx, targety);
     canChoose[24] = false;
   }
    if(card == 25){
     image(feebas, targetx, targety);
     canChoose[25] = false;
   }
    if(card == 26){
     image(sentry, targetx, targety);
     canChoose[26] = false;
   }
    if(card == 27){
     image(haunt, targetx, targety);
     canChoose[27] = false;
   }
    if(card == 28){
     image(hang, targetx, targety);
     canChoose[28] = false;
   }
    if(card == 29){
     image(nope, targetx, targety);
     canChoose[29] = false;
   }
    if(card == 30){
     image(rag, targetx, targety);
     canChoose[30] = false;
   }
  }
}

void drawButtons(){
// Wait For Card To Settle
if(timer > 60 && cardsSeen != last){
// Set Red Color Depending On If Mouse Is On The Button
if(onButton(rx,ry,bw,bh)) {
  
  fill(220,0,0);
  } 
else{
  fill(255,0,0);
}
// Draw Red Button
  rect(rx,ry,bw,bh);

// Set Green Color Depending On If Mouse Is On The Button
if(onButton(gx,gy,bw,bh)){
  fill(0,220,0);
  }
else{
  fill(0,255,0);
}
// Draw Green Button
  rect(gx,gy,bw,bh);
  
// Write Button Text
fill(255);
textSize(45); 
text("Trash", 170, 590);
text("Goated", 830, 590);
}}
void explainerText(){
textSize(25); 
textLeading(20);
if(timer > 60 && cardsSeen != last){
text("Numbers and symbols\n at the top of a card\n tend to show its cost.", 835, 150);
text("While judging these\n cards, treat them as \nif you just drew them.", 180, 150);
text("The text at the \nbottom of a card tend to\nshow the card's effect.", 180, 400);
text("Different games have\n different objectives. Use your \nbest judgement to identify\n them as well as cards\n that get closer to them.", 835, 400);
textSize(20);
text("(At Face Value)", 500, 550);
textSize(25);
text("This card is...", 500, 600);
}}

void randomDraw(){
  int rand = (int)(random(1,30));
  if(canChoose[rand] == true){
     card = rand;
     print(score);
     canDraw = false;
  }}
  

void resultsText(){
colorCycle = frameCount%360;
textSize(40); 
textLeading(30);
text("Your card assessment skills are", 500, 150);
textSize(textSize);
if(score >= uhm && score < poor){
fill(21,71,34);
if(timer > 140){
text("uhm...", 500,230);
}
fill(255);
if(timer > 160 && resultsSound == false){
  sad.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("To be completely honest, I\n don't even know if you tried...", 500,375);
}
}
if(score >= poor && score < good){
if(timer > 140){
text("Poor", 500,230);
}
if(timer > 160 && resultsSound == false){
  okay.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You don't seem to understand what\n makes a card strong, but you have\nwhat it takes to start learning.\n Playing more card games is the best\n way to build this instinct.", 500,290);
}
}
if(score >= good && score < great){
if(timer > 140){
text("Nice!", 500,230);
}
if(timer > 160 && resultsSound == false){
  nice.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You seem to understand a bit of what\n makes a card strong, but still have \nroom to understand more. Try \nagain and see if you can do better.", 500,325);
}
}
if(score >= great && score < amazing){
if(timer > 140){
text("Great!", 500,230);
}
if(timer > 160 && resultsSound == false){
  grayt.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You have a great grasp on what\n makes a card strong, and most likely\n have a solid understanding of card\n games as a form of play. You likely\ndon't struggle to pick up new ones.", 500,290);
}
}
if(score >= amazing && score + 1 < last){
fill(255,255,0);
if(timer > 140){
text("AMAZING!", 500,230);
}

fill(255);
if(timer > 160 && resultsSound == false){
  cheer.play();
  resultsSound = true;
}
if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You are excellent at\n evaluating a card's strengths, and\n are more often than not, great\n at picking up new ones.", 500,300);
}}
if(score + 1 >= last){
colorMode(HSB,360,100,100);
fill(color(colorCycle, 100, 100));
if(timer > 140){
text("PERFECT!!!", 500,230);
}
colorMode(RGB,255,255,255);
fill(255,255,255);
if(timer > 160 && resultsSound == false){
  cheer.play();
  resultsSound = true;
}if(timer > 240){
  textSize(60);
  textLeading(60);
  text("You have S-Tier assessment abilities!\n There wasn't a single misstep in your \njudgement or knowledge! Be sure to\n play again to see how well you\n fare against other cards.", 500, 290);
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
  text("Retry?", 500, 615);

}
}
