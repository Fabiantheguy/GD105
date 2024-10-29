//This piece aims to be a card contest on the strength of cards in card games
//and gives players results dependant on their scores. I pulled from a variety of
//sources and randomized the cards shown. GOOD LUCK!

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
PImage orcs;
PImage raider;
PImage raid;
PImage basari;
PImage evil;
PImage chariz;
PImage essence;
PImage skip;
PImage sun;


// Set Card Target Areas To Move To Left & Right
float ltargetx;
float ltargety;
float rtargetx;
float rtargety;

// Set Game Text
String lgame;
String rgame;
// Declare Font Name
PFont bel;
// Declare Button Vectors (r = red, g = green, y = yellow)
int rx = 100;
int gx = 800;
int yx = 375;
int ry = 750;
int gy = 750;
int yy = 750;
// Declare Button Sizes
int bw = 420;
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
  size(1300, 1000);
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
  orcs = loadImage("Orcs.jpg");
  raider = loadImage("Raider.jpg");
  raid = loadImage("Raid.jpg");
  basari = loadImage("Basari.jpg");
  evil = loadImage("Evil.jpg");
  chariz = loadImage("Chariz.jpg");
  essence = loadImage("Essence.jpg");
  skip = loadImage("Skip.jpg");
  sun = loadImage("Sun.png");
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
  clay.resize(420, 585);
  cold.resize(420, 585);
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
  neigh.resize(420, 585);
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
  rag.resize(420, 585);
  greed.resize(420, 585);
  research.resize(336, 468);
  orcs.resize(420, 585);
  raider.resize(420, 585);
  raid.resize(420, 585);
  basari.resize(420, 585);
  evil.resize(420, 585);
  chariz.resize(420, 585);
  essence.resize(420, 585);
  skip.resize(420, 585);
  sun.resize(420, 585);
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
  // Card Target Locations
  ltargetx = lerp(ltargetx, 100, 0.4);
  ltargety = lerp(ltargety, 100, 0.4);
  rtargetx = lerp(rtargetx, 800, 0.4);
  rtargety = lerp(rtargety, 100, 0.4);
  }
  else{
  ltargetx = 100;
  ltargety = 2000;
  rtargetx = 800;
  rtargety = 2000;
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
     lgame = "Magic: The Gathering";
     rgame = "Magic: The Gathering";
     image(raider, ltargetx, ltargety);
     image(orcs, rtargetx, rtargety);
     canChoose[1] = false;
   };
   if(card == 2){
     lgame = "Flesh And Blood";
     rgame = "Yu-Gi-Oh!";
     image(rag, ltargetx, ltargety);
     image(greed, rtargetx, rtargety);
     canChoose[2] = false;
   }
   if(card == 3){
     lgame = "Yu-Gi-Oh!";
     rgame = "Po-ké-mon!";
     image(evil, ltargetx, ltargety);
     image(chariz, rtargetx, rtargety);
     canChoose[3] = false;
   }
    if(card == 4){
     lgame = "Magic: The Gathering";
     rgame = "Unstable Unicorns";
     image(essence, ltargetx, ltargety);
     image(neigh, rtargetx, rtargety);
     canChoose[4] = false;
   }
    if(card == 5){
     lgame = "UNO";
     rgame = "The Binding of Isaac: Four Souls";
     image(skip, ltargetx, ltargety);
     image(sun, rtargetx, rtargety);
     canChoose[5] = false;
   }
    if(card == 6){
     image(one, ltargetx, ltargety);
     canChoose[6] = false;
   }
    if(card == 7){
     image(research, ltargetx, ltargety);
     canChoose[7] = false;
   }
    if(card == 8){
     image(pea, ltargetx, ltargety);
     canChoose[8] = false;
   }
    if(card == 9){
     image(report, ltargetx, ltargety);
     canChoose[9] = false;
   }
    if(card == 10){
     image(slow, ltargetx, ltargety);
     canChoose[10] = false;
   }
    if(card == 11){
     image(tutor, ltargetx, ltargety);
     canChoose[11] = false;
   }
    if(card == 12){
     image(shudder, ltargetx, ltargety);
     canChoose[12] = false;
   }    
    if(card == 13){
     image(magma, ltargetx, ltargety);
     canChoose[13] = false;
   }
    if(card == 14){
     image(plus, ltargetx, ltargety);
     canChoose[14] = false;
   }
    if(card == 15){
     image(board, ltargetx, ltargety);
     canChoose[15] = false;
   }
    if(card == 16){
     image(joker, ltargetx, ltargety);
     canChoose[16] = false;
   }
    if(card == 17){
     image(neigh, ltargetx, ltargety);
     canChoose[17] = false;
   }
    if(card == 18){
     image(leaf, ltargetx, ltargety);
     canChoose[18] = false;
   }
    if(card == 19){
     image(jail, ltargetx, ltargety);
     canChoose[19] = false;
   }
    if(card == 20){
     image(needle, ltargetx, ltargety);
     canChoose[20] = false;
   }
    if(card == 21){
     image(ignoble, ltargetx, ltargety);
     canChoose[21] = false;
   }
    if(card == 22){
     image(shinka, ltargetx, ltargety);
     canChoose[22] = false;
   }
    if(card == 23){
     image(shira, ltargetx, ltargety);
     canChoose[23] = false;
   }
    if(card == 24){
     image(ordine, ltargetx, ltargety);
     canChoose[24] = false;
   }
    if(card == 25){
     image(feebas, ltargetx, ltargety);
     canChoose[25] = false;
   }
    if(card == 26){
     image(sentry, ltargetx, ltargety);
     canChoose[26] = false;
   }
    if(card == 27){
     image(haunt, ltargetx, ltargety);
     canChoose[27] = false;
   }
    if(card == 28){
     image(hang, ltargetx, ltargety);
     canChoose[28] = false;
   }
    if(card == 29){
     image(nope, ltargetx, ltargety);
     canChoose[29] = false;
   }
    if(card == 30){
     image(rag, ltargetx, ltargety);
     canChoose[30] = false;
   }
  }
}

void drawButtons(){
// Wait For Card To Settle
if(timer > 60 && cardsSeen != last){
// Set Red Color Depending On If Mouse Is On The Button
if(onButton(rx,ry,bw,bh)) {
  
  fill(0,220,0);
  }
else{
  fill(0,255,0);
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
text("This One!", 315, 810);
text("This One!", 1015, 810);
}}
void explainerText(){
textSize(25); 
textLeading(20);
if(timer > 60 && cardsSeen != last){
textSize(40);
text(lgame, 315, 90);
text(rgame, 1015, 90);
textSize(100);
text("VS.", 650, 400);
textSize(40);
textLeading(40);
text("Which card is \nbetter?", 662.5, 800);
}}

void randomDraw(){
  int rand = (int)(random(1,30));
  if(canChoose[rand] == true){
     card = 1;
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
