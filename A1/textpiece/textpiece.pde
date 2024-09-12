size(600, 600); // Set window size
background(0,0,0); // Make the background black
PFont pixel; // Set font name
pixel = createFont("ARCADECLASSIC.TTF", 128); // Grab font from data
textSize(3);  // Set initial text size
textFont(pixel); // Set font
textAlign(CENTER); // Align text to center

fill(255, 255, 255, 255); // Set text color
textSize(200);  // Set text size
text("Imma", 300, 200);  // Draw text on line

fill(255, 0, 0, 200); // Set text color
textSize(100);  // Set text size
text("slash", 300, 300);  // Draw text on line

fill(255, 255, 255, 150); // Set text color
textSize(50);  // Set text size
text("them", 300, 375);  // Draw text on line

fill(255, 255, 255, 75); // Set text color
textSize(25);  // Set text size
text("silently", 300, 450);  // Draw text on line

fill(255, 255, 255, 25); // Set text color
textSize(15);  // Set text size
text("on jah", 300, 550);  // Draw text on line

save("textpiece.png"); // Make PNG based on output
