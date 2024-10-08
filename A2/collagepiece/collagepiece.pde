// Everything in this collage shares a theme. Here's a hint, it's MAGICal.

// Declare Image Variables
PImage plain;
PImage sol;
PImage tef;
PImage chan;
PImage plat;
PImage jace;
PImage lot;
PImage grol;
PImage sim;
PImage grey;
PImage sig;
PImage pink;
PImage fort;
PImage tam;

void setup() {
  size(1000, 700);
// Define Image Variables
  plain = loadImage("Plain.jpg");
  sol = loadImage("Sol.png");
  tef = loadImage("Tef.png");
  chan = loadImage("Chan.png");
  plat = loadImage("Plat.png");
  jace = loadImage("Jace.png");
  lot = loadImage("Lot.png");
  grol = loadImage("Grol.png");
  sim = loadImage("Sim.png");
  grey = loadImage("Grey.png");
  sig = loadImage("Sig.png");
  pink = loadImage("Pink.png");
  fort = loadImage("Fort.png");
  tam = loadImage("Tam.png");
// Resize Images
  plain.resize(1000,700);
  sol.resize(sol.width / 2, sol.height / 2);
  tef.resize(tef.width / 2, tef.height / 2);
  chan.resize(chan.width / 4, chan.height / 4);
  plat.resize(plat.width / 2, plat.height / 2);
  jace.resize(jace.width / 2, jace.height / 2);
  lot.resize(lot.width / 15, lot.height / 15);
  grol.resize(grol.width / 2, grol.height / 2);
  sim.resize(sim.width / 10, sim.height / 10);
  grey.resize(grey.width / 2, grey.height / 2);
  sig.resize(sig.width / 2, sig.height / 2);
  pink.resize(pink.width / 3, pink.height / 3);
  fort.resize(fort.width / 1, fort.height / 1);
  tam.resize(tam.width / 4, tam.height / 4);

}

void draw() {
// Draw Images
  image(plain, 0, 0);
  image(sol, -100, 0);
  image(tef, 800, 400);
  image(chan, 570, 230);
  image(plat, 400, 100);
  image(jace, 750, 200);
  image(lot, 380, 335);
  image(grol, 0, 400);
  image(sim, 455, 410);
  image(grey, 150, 500);
  image(sig, 180, 420);
  image(pink, 240, 270);
  image(fort, 579, 379);
  image(tam, 700, 80);
  // Save PNG
  save("collagepiece.png");
}
