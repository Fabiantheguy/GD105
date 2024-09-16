// I had two roads with this piece. I was gonna make it about cats or caps. I could choose the latter in the future if the oppurtunity presents itself.

PImage temp;
PImage mat;
PImage tap;
void setup() {
size(750, 1050); // Set window size
background(0,0,0); // Make the background black
PFont bel; // Set font name
bel = createFont("Beleren2016-Bold.ttf", 1); // Grab font from data
temp = loadImage("Template.png");
mat = loadImage("Mattew.png");
tap = loadImage("Tap.png");
textFont(bel); // Set font
textAlign(CENTER); // Align text to center
}

void draw(){
temp.resize(750, 1050);
mat.resize(634, 460);
tap.resize(30, 30);
image(temp, 0, 0);
image(mat, 58, 119);
image(tap, 610, 705);
fill(0, 0, 0, 255); // Set text color

// Name
textSize(45);  // Set name text size
text("Mattew, Databender", 260, 95);  // Card Name

// Type-Line
textSize(30);  // Set text size
textAlign(LEFT); // Align text to center
text("                                        - Human Illusion", 60, 630);


// Cap-bearer Skill
text("Whenever Mattew, Databender enters or", 60, 700);
text("attacks, create a Cap artifact token with \"     :", 60, 730);
text("Target creature phases out.''", 60, 760);

// Assignment Skill
text("Whenever Mattew, Databender or another", 60, 820);
text("creature you control phases in, you may return", 60, 850);
text("target creature an opponent controls to their", 60, 880);
text("owner's hand.", 60, 910);

textAlign(CENTER); // Align text to center
save("personalpiece.png"); // Make PNG based on output
}
