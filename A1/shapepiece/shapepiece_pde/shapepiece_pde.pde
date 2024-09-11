// Sets the size of the canvas
size(2000, 1000);
// Sets the color of the canvas
background(0,0,0);
// Sets the size of the lines
strokeWeight(13);
stroke(250, 250, 0);
rotate(PI/3);
arc(800, 0, 320, 320, 0, PI+HALF_PI, PIE);
rotate(0);
arc(1100, 0, 320, 320, 0, PI+QUARTER_PI+15, PIE);


// Turns the sketch into an image
save("shapepiece.png");
