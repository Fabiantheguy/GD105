PImage temp;
PImage mat;
void setup() {
size(750, 1050); // Set window size
background(0,0,0); // Make the background black
PFont bel; // Set font name
PFont bet; // Set font name
bel = createFont("Beleren2016-Bold.ttf", 1); // Grab font from data
bet = createFont("Beleren2016SmallCaps-BoldItalic.ttf", 1); // Grab font from data
temp = loadImage("Template.png");
mat = loadImage("Mattew.png");
textFont(bel); // Set font
textAlign(CENTER); // Align text to center
}
//<i>Cap-bearer</i> {dash} Whenever Mattew, Databender enters or attacks, create a Cap artifact token with "{t}: Target creature phases out."

//<i>Assign</i> {dash} Whenever Mattew, Databender or another creature you control phases in, you may return target creature an opponent controls to their owner's hand.
void draw(){
temp.resize(750, 1050);
mat.resize(634, 525);
image(temp, 0, 0);
image(mat, 58, 150);
fill(0, 0, 0, 255); // Set text color
textSize(45);  // Set initial text size
text("Mattew, Databender", 260, 95);  // Card Name
save("personalpiece.png"); // Make PNG based on output
}
