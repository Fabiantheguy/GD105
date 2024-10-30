/*
  This is my Moiré Piece, which randomly shows a frantic sharp corner in
  motion in direct contrast with a still image. The amount of lines
  and darkness of the image (as well as how much it makes your CPU
  explode) is randomly generated at runtime.
*/
// Random Small Number
float randSmall;
// Random Big Number
float randBig;
// Random Number Of Lines
float randLin;
void setup()
{
  size(400, 400);
  // Sets The Random Number
  randLin = random(1,10);
}

void draw()
{
  background( 255 );

  noFill();
  stroke( 0 );
  // Makes Lines Until They Reach A Certain Length With An Amount Dictated
  // By randLin
  for ( int lin = 0; lin <= width; lin = lin + int(randLin)) {
    // Set randSmall & randBig
    randSmall = random(0,5);
    randBig = random(0,400);
    // Draw The Crazy Lines
    line(randSmall, randBig, lin, 0); 
    // Draw The Still Lines
    line(width, 0, lin, height); 
  }}
