/*
  This is my Moiré Piece, which randomly shows a frantic sharp corner in
  motion in direct contrast with still lines. The amount of lines
  the color, and the darkness of the image (as well as how much it makes your CPU
  explode) is randomly generated at runtime.
*/
// Random Small Number
float randSmall;
// Random Big Number
float randBig;
// Random Number Of Lines
float randLin;
// If A PNG Was Saved
boolean saved;
// Random Colors
float randR;
float randG;
float randB;
// The Size Of The Eye's Iris (Get It)
float iSize;
// The Degree Of Eye Vibration
float vibrate;
void setup()
{
  randR = random(150,255);
  randG = random(150,255);
  randB = random(150,255);
  size(400, 400);
  // Sets The Random Number
  randLin = random(1,5);
  saved = false;
  iSize = 1;
}

void draw()
{
  // Sets The Background To A Random Color
  background(randR,randG,randB, 255);

  // Draws The Outer Ring Of The Eye With The Color Being The Same As The Background

  if(iSize < 50){
      fill(randR,randG,randB);
      ellipse(width/2, height/2, 50, 50);  
    }

  noFill();
  stroke(0);
  // Makes Lines Until They Reach A Certain Length With An Amount Dictated
  // By randLin
  for ( int lin = 0; lin <= width; lin = lin + int(randLin)) {
    // Set randSmall & randBig
    randSmall = random(0,5);
    randBig = random(0,400);

    // Draw The Still Lines
    line(width, 0, lin, height); 
    // Draw The Crazy Lines
    line(randSmall, randBig, lin, 0); 
    // Draw The Curvy Corners
    line(width, lin, lin, 0); 
    line(0, lin, lin, width); 
    
    // Draws The Iris With It Slowly Getting Larger And Eventually Vibrating
  
  }
    if(iSize < 50){
      fill(0);
      ellipse(width/2, height/2, iSize, iSize);
      iSize += .3;

      print(iSize + "\n");
    }
    else{
      vibrate +=0.4;
      float v = noise(vibrate) * 5;
      fill(0);
      ellipse((width/2) + (v * 2), (height/2) - (v / 4), 55, 55);
    }
    // Saves The PNG After It Starts
    if(frameCount >= 1 && saved == false){
      print("yuh");
      save("moirepiece.png");
      saved = true;
      
  }
}
  
  
  
  
  
  
  
  
  
  
  
  
//ICU
