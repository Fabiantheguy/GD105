PImage[] cardImages = new PImage[2]; // Array to store card images
String[] cardImageNames = {"Clay.jpg", "Greed.png"};
void draw(){
  // Load Images
  for (int i = 0; i < cardImages.length; i++) {
    cardImages[i] = loadImage(cardImageNames[1]);
    cardImages[i].resize(336, 468);
    image(cardImages[i] + "\n", 0,0);
  }
}
