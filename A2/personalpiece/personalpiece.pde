//This piece aims to be a card assessment quiz on the strength of Magic cards while
//giving players results dependant on their scores. If I put more time
//into this, I'll make it random and increase the card pool.

//I JUST GOT THE CRAZIEST IDEA!!!
//What if I add other cards? I'll do that when I work on it more.

// Grab The Sound Library
import processing.sound.*;
//Declare SoundFile Variables
SoundFile paper;
SoundFile drum;
SoundFile sad;
SoundFile okay;
SoundFile nice;
SoundFile cheer;
// Declare Image Variables
PImage sol;
PImage one;
PImage leech;
PImage drain;
PImage elves;
PImage sheoldred;
PImage angel;
PImage lotus;
PImage bloom;
PImage tutor;
PImage nicol;
PImage yargle;
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
int yy = 525;
// Declare Button Sizes
int bw = 250;
int bh = 100;
// Tracks The Current Card Number
int card = 1;
//Tracks The Final Card Number
int last = 13;
// Tracks The Player's Score
int score = 0;
// Growing Text Size For Final Results
float textSize = 1;

// A Rising Timer For Cooldowns
int timer;
// Checks If The Score's Already Been Saved
boolean saved;
// Checks If Results Sound Has Played
boolean resultsSound = false;

void setup() {
  size(1000, 700);
// Define Font Variable
  bel = createFont("Beleren2016-Bold.ttf", 1);
// Define Image Variables
  sol = loadImage("Sol.jpg");
  one = loadImage("One.jpg");
  leech = loadImage("Leech.jpg");
  drain = loadImage("Drain.jpg");
  elves = loadImage("Elves.jpg");
  sheoldred = loadImage("Sheoldred.jpg");
  angel = loadImage("Angel.jpg");
  lotus = loadImage("Lotus.png");
  bloom = loadImage("Bloom.jpg");
  tutor = loadImage("Tutor.jpg");
  nicol = loadImage("Nicol.jpg");
  yargle = loadImage("Yargle.jpg");
// Define SoundFile Variables
  drum = new SoundFile(this, "data/Drum.mp3");
  paper = new SoundFile(this, "data/Paper.mp3");
  sad = new SoundFile(this, "data/Sad.mp3");
  okay = new SoundFile(this, "data/Okay.mp3");
  nice = new SoundFile(this, "data/Nice.mp3");
  cheer = new SoundFile(this, "data/Cheer.mp3");
// Set Stroke Size
  stroke(255);
// Set Font & Align
  textFont(bel);
  textAlign(CENTER);
// Play First Draw Sound
  paper.play();
  

// Resize Images
  sol.resize(336, 468);
  one.resize(336, 468);
  leech.resize(336, 468);
  drain.resize(336, 468);
  elves.resize(336, 468);
  sheoldred.resize(336, 468);
  angel.resize(336, 468);
  lotus.resize(336, 468);
  bloom.resize(336, 468);
  tutor.resize(336, 468);
  nicol.resize(336, 468);
  yargle.resize(336, 468);
}

void draw() {
// Draw Background
  background(0);
// Increase Timer
  timer += 1;
// Creates The Red & Green Buttons & Explainer Text
  drawButtons();
  explainerText();
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
if(card == last){
  resultsText();
  print("yuh");
}
}
void mouseClicked(){
  // Wait For Buttons To Spawn In Game To Be Reset
   if((timer > 80 && card == last - 1) && (onButton(rx,ry,bw,bh) || (onButton(gx,gy,bw,bh)))){
    drum.play();
    }
    if(onButton(rx,ry,bw,bh) && timer > 80 && card != last && card != last) {
    timer = 0;
    // Increase Score If Trash Was Chosen Correctly
    if(card == 2 || card == 3 || card == 7 || card == 9 || card == 11 || card == 12){
      score += 1;
    }
    paper.play();
    card += 1;
    } 
    if(onButton(gx,gy,bw,bh) && timer > 80 && card != last && card != last) {
    timer = 0;
    // Increase Score If Goated! Was Chosen Correctly
      if(card == 1 || card == 4 || card == 5 || card == 6 || card == 8 || card == 10){
      score += 1;
    }
    paper.play();
    card += 1;
    }
    if(onButton(yx,yy,bw,bh) && timer > 200){
    // Reset All Values
    card = 1;
    score = 0;
    textSize = 1;
    targetx = 330;
    targety = 900;
    timer = 0;
    paper.play();
    resultsSound = false;
    }
  }
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
   if(card == 1){
     image(sol, targetx, targety);
   };
   if(card == 2){
     image(one, targetx, targety);
   }
   if(card == 3){
     image(leech, targetx, targety);
   }
    if(card == 4){
     image(drain, targetx, targety);
   }
    if(card == 5){
     image(elves, targetx, targety);
   }
    if(card == 6){
     image(sheoldred, targetx, targety);
   }
    if(card == 7){
     image(angel, targetx, targety);
   }
    if(card == 8){
     image(lotus, targetx, targety);
   }
    if(card == 9){
     image(bloom, targetx, targety);
   }
    if(card == 10){
     image(tutor, targetx, targety);
   }
    if(card == 11){
     image(nicol, targetx, targety);
   }
    if(card == 12){
     image(yargle, targetx, targety);
   }
   
}

void drawButtons(){
// Wait For Card To Settle
if(timer > 60 && card != last){
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
if(timer > 60 && card != last){
text("The number and amount\nof symbols at the top right\n shows the cost of the card", 835, 150);
text("The text at the \nbottom-center shows \nthe card's effect", 200, 400);
textSize(20);
text("(At Face Value)", 500, 550);
textSize(25);
text("This card is...", 500, 600);
}

}
void resultsText(){
textSize(40); 
textLeading(30);
text("Your card assesment is", 500, 150);
textSize(textSize);
if(score < 4 && score >= 0){
text("uhm...", 500,230);
if(timer > 160 && resultsSound == false){
  sad.play();
  resultsSound = true;
}}
if(score < 6 && score >= 4){
text("Okay", 500,230);
if(timer > 160 && resultsSound == false){
  okay.play();
  resultsSound = true;
}}
if(score < 9 && score >= 6){
text("Nice!", 500,230);
if(timer > 160 && resultsSound == false){
  nice.play();
  resultsSound = true;
}}
if(score >= 9){
text("AMAZING!", 500,230);
if(timer > 160 && resultsSound == false){
  cheer.play();
  resultsSound = true;
}}
if(timer > 140 && textSize < 59){
textSize += 2;}
if(timer > 200){
  save("personalpiece.png");
// Draw Retry Button
  fill(255,255,0);
  rect(yx,yy,bw,bh);
  fill(255);
  text("Retry", 500, 590);

}
}
