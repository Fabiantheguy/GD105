import gifAnimation.*;

class GIF {
  GifMaker gif;
  GIF(PApplet app, String filename) {
    gif = new GifMaker(app, "white.gif", 100);
    gif.setRepeat(0); // 0 means endless loop
  }

  void addFrame(int delay_in_frames) {
    gif.setDelay(delay_in_frames);
    gif.addFrame();
  }

  void save() {
    gif.finish();
  }
};
PImage white;
GIF w;
int i;

void setup()
{
  w = new GIF(this, "white.gif");
  size(1000,1000);
  white = loadImage("White.png");
  white.resize(1000,1000);
  print("e" + "\n" + "l");

}

void draw()
{
  background(255);
  float speedOfRotation = .0025; // higher values go faster, e.g. .02 is double speed
  float amtToRotate = millis()*speedOfRotation;
  
  int x = 500, y = 500;  // where to place the image
  
  pushMatrix();
  translate(x,y);
  rotate(amtToRotate);
  image(white, -white.width/2, -white.height/2);
  w.addFrame(1);
  if(amtToRotate > 4){
  w.save();
  }
  popMatrix();
}
