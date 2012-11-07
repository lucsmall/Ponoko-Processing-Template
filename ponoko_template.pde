/*
 Processing+Ponoko
 A template for creating laser cut designs suitable for the 
 Ponoko service (http://www.ponoko.com) programmatically using 
 Processing (http://processing.org).
 
 For full details on how to use see:
 http://lucsmall.com/2012/11/06/processingponoko/
 Created by Luc Small on 7 November 2012

 Feel free to adapt and modify for your own projects
*/
import processing.pdf.*;

// Global that determines if guidelines and annotations are shown (ie. design mode)
// or hidden (ie. production mode)
boolean production_flag = false;

void setup() {
  println("Processing design...");
  // Select your target Ponoko template size
  // P1 sizing 181x181 mm
  size(513, 513, PDF, "output.pdf");
  // P2 sizing 384x384 mm
  //size(1088, 1088, PDF, "output.pdf");
  // P3 sizing 790x384 mm
  //size(2239, 1088, PDF, "output.pdf");
  // A4 sizing, 210x297, 10mm margins (eg 190x277)
  //size(538, 785, PDF, "output.pdf"); 

  // Set up an example font - font size will be 4mm
  textMode(SHAPE);
  PFont myfont;
  myfont = createFont("Calibri", 4, false); 
  textFont(myfont);
 
  // Change parameter to "true" when design ready for production
  // then re-run the sketch
  production(false);

  // Change background to white when in design mode
  if (!production_flag) {
    background(255,255,255); 
  }
  // Set stroke weight
  // 0.01 mm = thin lines for production
  // 0.1  mm = thicker lines for clear printing in design mode
  strokeWeight((production_flag ? 0.01 : 0.1));

  // No file on shapes
  noFill();
}

void draw() {
  int i;
  // Scale all units from mm to points
  // All coordinates (x, y) and widths and heights are henceforth in mm
  scale(72/25.4);
 
  /* YOUR DESIGN STARTS HERE */

  // Position at 1mm, 1mm in top-left
  translate(1, 1);

  // First object
  // 60x60 mm square with rounded corners
  cut_rect(0, 0, 60, 60, 2);
  // 20mm diameter circle at centre of object
  cut_ellipse(30, 30, 20, 20);
  // M3 holes in each corner
  hole_m3( 5,  5);
  hole_m3( 5, 55);
  hole_m3(55,  5);
  hole_m3(55, 55);
  // Guideline at centre
  guide_crosshair(30, 30, 15);
  // Shape identifier
  note("Part A", 10, 6);  
  
  // Second object
  pushMatrix();
  // Move 65 mm to the right, 25mm down
  translate(65, 25);
  cut_rect(0, 0, 110, 10, 2);
  translate(5, 2);
  for(i=0; i<=100; i++) {
    engrave_line(0, 0 , 0 , (i % 10 == 0 ? 6 : (i % 5 == 0 ? 4 : 2)));
    translate(1, 0);  
  }
  popMatrix();
  
  // Third object
  pushMatrix();
  // Move 10 mm right, 80 mm down
  translate(10, 80);
  // 8 x circles 20mm diameter with centre M3 holes
  for(i=0; i<8; i++) {
    cut_ellipse(0, 0, 20, 20);
    hole_m3(0,0);
    // Move along 21 mm
    translate(20+1, 0);
  }
  popMatrix();
  
  /* YOUR DESIGN ENDS HERE */
  
  // Exit the program 
  println("Finished.");
  exit();
}


// "LIBRARY" FUNCTIONS
// Not a complete set of functions, just enough stuff to get 
// what I needed to accomplish done

// Use this method to set the global production flag
void production(boolean v) 
{
 production_flag = v;
}

// Set the Ponoko cut colour, blue 
void cut_mode() {
  // blue for laser cut
  stroke(0,0,255);
}

// Set the colour of the guide lines to orange
void guide_mode() {
  stroke(0xff,0x66,0);
}

// Set the colour for Ponoko vector engrave mode
void vector_engrave_mode() {
  // red == heavy
  //stroke(255, 0, 0);
  // medium == green
  stroke(0, 255, 0);
  // light = magenta
  //stroke(255, 0, 255);
}

// Draw an hole to suit an M3 screen, centred at (x,y)
void hole_m3(float x, float y)
{
  guide_crosshair(x, y, 2);
  
  ellipseMode(CENTER);
  cut_ellipse(x, y, 3, 3); 
}

// Draw a line to be cut
void cut_line(float x1, float y1, float x2, float y2)
{
  cut_mode();
  line(x1, y1, x2, y2);
}

// Draw an ellipse to be cut
void cut_ellipse(float a, float b, float c, float d) {
  cut_mode();
  ellipse(a, b, c, d);
}

// Draw a rectangle to be cut
void cut_rect(float a, float b, float c, float d)
{
  cut_mode();
  rect(a, b, c, d); 
}

// Draw a rounded rectangle to be cut
void cut_rect(float a, float b, float c, float d, float r)
{
  cut_mode();
  rect(a, b, c, d, r); 
}

// Draw an arc to be cut
void cut_arc(float a, float b, float c, float d, float start, float stop)
{
  cut_mode();
  arc(a, b, c, d, start, stop);  
}

// Draw a line to be vector engraved
void engrave_line(float x1, float y1, float x2, float y2)
{
  vector_engrave_mode();
  line(x1, y1, x2, y2);
}

// Draw a rectangle to be vector engraved
void engrave_rect(float a, float b, float c, float d)
{
  vector_engrave_mode();
  rect(a, b, c, d); 
}

// Engrave text using heavy raster fill engraving
void engrave_text(String c, float x, float y)
{
  // Set black fill
  fill(0, 0, 0);
  text(c, x, y);
  noFill();
}

// Draw a guideline
// It will be hidden in production mode
void guide_line(float x1, float y1, float x2, float y2)
{
  if (production_flag) return;
  guide_mode();
  line(x1, y1, x2, y2);
}

// Draw a guide rectangle
// It will be hidden in production mode
void guide_rect(float a, float b, float c, float d)
{
  if (production_flag) return;
  guide_mode();
  rect(a, b, c, d); 
}

// Draw a guide cross hair centred at (x,y) and with a radius of rad
// It will be hidden in produciton mode
void guide_crosshair(float x, float y, float rad)
{
    guide_line(x, y - rad, x, y + rad);
    guide_line(x - rad, y, x + rad, y); 
}

// Print an annotation in string c at (x,y)
// It will be hidden in produciton mode
void note(String c, float x, float y)
{
  if (production_flag) return;
  fill(0xff,0x66,0);
  text(c, x, y);
  noFill();
}
