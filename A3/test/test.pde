PImage[] cardImages = new PImage[30]; // Array to store card images
String[] cardImageNames = {"Clay.jpg"};
void draw(){
  // Load Images
  for (int i = 0; i < cardImages.length; i++) {
    cardImages[i] = loadImage(cardImageNames[i]);
    cardImages[i].resize(336, 468);
    print(cardImages[i] + "\n");
  }
}
