// Sets the size of the canvas
size(1500, 1000);
// Sets the color of the canvas
background(0,0,0);
// Sets the size of the lines
strokeWeight(13);
stroke(250, 250, 0);
rotate(PI/3);
arc(800, 0, 320, 320, 0, PI+HALF_PI, PIE);
rotate(radians(-60));
arc(800, 690, 320, 320, 0, PI+QUARTER_PI+15, PIE);
rotate(PI/3);
arc(1200, -700, 320, 320, 0, PI+HALF_PI, PIE);
strokeWeight(150);
rotate(radians(-60));
stroke(20, 0, 255);
line(0, 350, 2000, 350);
line(0,1000,2000, 1000);
// Turns the sketch into an image
save("shapepiece.png");
