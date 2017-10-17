class Colony {

/* The Colony class does the following:
*  1) Starts a colony by spawning a given number of cells (using DNA from the genepool) in a predetermined spawn-pattern //<>// //<>//
*  2) Runs the colony
*/

  // VARIABLES
  ArrayList<Cell> population;    // An arraylist for all the cells //<>// //<>//
  
  PVector vel;
  PVector pos;
  PVector origin;
  
  float a;

  float w = width * 0.001;  // For convinience
  float c = w * 5; // Scaling factor

  // CONSTRUCTOR: Create a 'Colony' object containing an initial population of cells
  Colony() {
    population = new ArrayList<Cell>();
    
    if (gs.patternSelector == 0) {center_pattern();}
    else
    if (gs.patternSelector == 1) {random_pattern();}
    else
    if (gs.patternSelector == 2) {cartesian_pattern();}
    else
    if (gs.patternSelector == 3) {cartesian_pattern_alt();}
    
    else {phyllotaxic_pattern();}
  }

  // 0) Spawn cells at the center of the screen
  void center_pattern() {
    // Here is the code which fills the 'cells' arraylist with cells at the center of the screen
    for (int n = 0; n < gs.seeds; n++) {
      //int strain = int(random(gpl.numPredefined, gpl.numPredefined + gs.numStrains));
      //int strain = int(random(gpl.numPredefined + gs.numStrains));
      int strain = gpl.numPredefined + n;
      pos = new PVector(width*0.5, height*0.5); // random position
      
      //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
      vel = new PVector(1,-1);
      
      origin = new PVector (gs.orx, gs.ory);
      //PVector vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
      vel.normalize();
      //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
  
      DNA dna = gpl.genepool.get(strain); // Get's a random strain of dna from the genepool
      //DNA dna = gpl.genepool.get(0);                            // Get's a specific strain of dna from the genepool
      //dna.genes[0] = n; //n is transferred to gene 0
      
      for (int s = 0; s < gs.strainSize; s ++) {
        population.add(new Cell(pos, vel, dna));
      }
    }
  }
  
  // 1) Spawn cells in a random pattern
  void random_pattern() {
    // Here is the code which fills the 'cells' arraylist with cells at random positions
    for (int n = 0; n < gs.seeds; n++) {
      pos = new PVector(random(width), random(height)); // random position
      origin = new PVector (gs.orx, gs.ory);
      //PVector vel = PVector.sub(origin, pos); // Static velocity vector pointing from cell position TOWARDS the arbitrary 'origin'
      PVector vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position AWAY FROM the arbitrary 'origin'
      vel.normalize();
      //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
      //int strain = int(random(gpl.numPredefined, gpl.numPredefined + gs.numStrains));
      int strain = gpl.numPredefined + n;
      DNA dna = gpl.genepool.get(strain); // Get's a random strain of dna from the genepool
      //DNA dna = gpl.genepool.get(0);                            // Get's a specific strain of dna from the genepool
      
      // Set the start & end color of the strain according to the colour at the same location in the source image
      color colorFromPixel = pixelColour(pos);
      //dna.genes[1] = hue(colorFromPixel);
      //dna.genes[2] = hue(colorFromPixel);
      //dna.genes[3] = saturation(colorFromPixel);
      //dna.genes[4] = saturation(colorFromPixel);
      //dna.genes[5] = brightness(colorFromPixel);
      //dna.genes[6] = brightness(colorFromPixel);
      //dna.genes[11] = brightness(colorFromPixel);
      //dna.genes[12] = brightness(colorFromPixel);
      
      for (int s = 0; s < gs.strainSize; s ++) {
        population.add(new Cell(pos, vel, dna));
      }
    }
  }
  
  
  
  
  
  // 2) Spawn cells in a cartesian grid pattern
  void cartesian_pattern() {
    //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
  
    // Here is the code which fills the 'cells' arraylist with cells at given positions
    int n = 0;
    for (int r = 0; r <= gs.rows; r++) {      
      //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
      //a = map(r, 0, gs.rows, 0, TWO_PI);
      //vel = PVector.fromAngle(0).mult(1);
      
      for (int c = 0; c <= gs.cols; c++) {
        //int strain = int(random(gpl.numPredefined, gpl.numPredefined + gs.numStrains));
        int strain = (n % gs.numStrains) + gpl.numPredefined;
        DNA dna = gpl.genepool.get(strain); // Get's a random strain of dna from the genepool (not a preset DNA)
        //DNA dna = gpl.genepool.get(0);          // Get's a specific strain of dna from the genepool
        dna.genes[0] = n;
         n ++;
        float xpos = width * map (c, 0, gs.cols, 0, 1);
        float ypos = height * map (r, 0, gs.rows, 0, 1);
        pos = new PVector(xpos, ypos);
        
        // Set the start & end color of the strain according to the colour at the same location in the source image
        color colorFromPixel = pixelColour(pos);
        //dna.genes[1] = hue(colorFromPixel);
        //dna.genes[2] = hue(colorFromPixel);
        //dna.genes[3] = saturation(colorFromPixel);
        //dna.genes[4] = saturation(colorFromPixel);
        //dna.genes[5] = brightness(colorFromPixel);
        //dna.genes[6] = brightness(colorFromPixel);
        //dna.genes[11] = brightness(colorFromPixel);
        //dna.genes[12] = brightness(colorFromPixel);
        //dna.genes[17]= 500/gs.rows*map(saturation(colorFromPixel), 0, 255, 0.5, 1.8);
        //dna.genes[31]= map(saturation(colorFromPixel), 0, 255, 40, 60);
        
        //vel = PVector.fromAngle(radians(hue(colorFromPixel)));
        origin = new PVector (gs.orx, gs.ory);
        //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
        vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
        //vel = new PVector(0,-1);
        vel.normalize();
        vel.rotate(PI * map(cycleGen, -1, 1, 0, 2)); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
  
        for (int s = 0; s < gs.strainSize; s ++) {
          //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
          //if ( random(1) > 0.2) {population.add(new Cell(pos, vel, dna));
          //if (brightness(colorFromPixel) < 10) {population.add(new Cell(pos, vel, dna));}
          //if (saturation(colorFromPixel) > 3) {population.add(new Cell(pos, vel, dna));}
          if (n <= gs.numStrains) {population.add(new Cell(pos, vel, dna));}
          //population.add(new Cell(pos, vel, dna));
        }
      }
    }
  }
  
  // 3) Spawn cells in a cartesian grid pattern with alternating strains
  void cartesian_pattern_alt() {
    //vel = PVector.random2D();   // Initial velocity vector is random & identical for each cell
  
    // Here is the code which fills the 'cells' arraylist with cells at given positions
    int n = 0;
    for (int r = 0; r <= gs.rows; r++) {      
      //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
      //a = map(r, 0, gs.rows, 0, TWO_PI);
      //vel = PVector.fromAngle(0).mult(1);
      
      for (int c = 0; c <= gs.cols; c++) {
        //int strain = ((r + c) % int(random(1,gpl.genepool.size()))) + 0;
        //int strain = ((r + c) % 2) + int(random(7));
        int strain = int(random(gpl.numPredefined, gpl.numPredefined + gs.numStrains));
        DNA dna = gpl.genepool.get(strain); // Get's the appropriate strain of dna from the genepool
        //DNA dna = gpl.genepool.get(0);                        // Get's a specific strain of dna from the genepool
        n ++;
        float xpos = width * map (c, 0, gs.cols, 0, 1);
        float ypos = height * map (r, 0, gs.rows, 0, 1);
        pos = new PVector(xpos, ypos);
        color colorFromPixel = pixelColour(pos);
        //dna.genes[1] = hue(colorFromPixel);
        //dna.genes[2] = hue(colorFromPixel);
        //dna.genes[3] = saturation(colorFromPixel);
        //dna.genes[4] = saturation(colorFromPixel);
        //dna.genes[5] = brightness(colorFromPixel);
        //dna.genes[6] = brightness(colorFromPixel);
        dna.genes[7] = alpha(colorFromPixel);
        dna.genes[9] = hue(colorFromPixel);
        dna.genes[10] = hue(colorFromPixel);
        dna.genes[11] = saturation(colorFromPixel);
        dna.genes[12] = saturation(colorFromPixel);
        dna.genes[13] = brightness(colorFromPixel);
        dna.genes[14] = brightness(colorFromPixel);
        //dna.genes[15] = alpha(colorFromPixel);
        dna.genes[17] = map(saturation(colorFromPixel), 0, 255, 500/gs.rows*2, 500/gs.rows*2);
        dna.genes[18] = map(brightness(colorFromPixel), 0, 255, 0, 5);
        
        origin = new PVector (gs.orx, gs.ory);
  
        //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
        vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
        vel.normalize();
        //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
  
        for (int s = 0; s < gs.strainSize; s ++) {
          //vel = PVector.random2D();   // Initial velocity vector is random & unique for each cell
          //if ( random(1) > 0.2) {population.add(new Cell(pos, vel, dna));
          population.add(new Cell(pos, vel, dna));
        }
      }
    }
  }
  
  // 4) Spawn cells in a phyllotaxic spiral pattern
  void phyllotaxic_pattern() {
    // Here is the code which fills the 'cells' arraylist with cells at given positions
    for (int n = 0; n <= gs.seeds; n++) {
      
      // Simple Phyllotaxis formula:
      float a = n * radians(137.5);
      float r = c * sqrt(n);   
      float xpos = r * cos(a) + width * 0.5;
      float ypos = r * sin(a) + height * 0.5;
      pos = new PVector(xpos, ypos);
      
      
      origin = new PVector (gs.orx, gs.ory);
      PVector vel = PVector.sub(pos, origin); // Static velocity vector pointing from cell position to the arbitrary 'origin'
      vel.normalize();
      //vel.rotate(PI * map(cycleGen, -1, 1, 0, 2));
      vel.rotate(radians(map(runCycle, 1, maxCycles, 0, 120)));
      //vel.rotate(PI * 1.5); // Velocity is rotated 270 degrees (to be at right-angle to the radial 'spoke')
      //int strain = ((n) % 2) + 3;
      //int strain = int(random(gpl.numPredefined, gpl.numPredefined + gs.numStrains));
      int strain = (n % gs.numStrains) + gpl.numPredefined;
      //int strain = int(random(gpl.numPredefined + gs.numStrains));
      //DNA dna = gpl.genepool.get(int(random(gs.numStrains+3))); // Get's a random strain of dna from the genepool
      DNA dna = gpl.genepool.get(strain); // Get's a random strain of dna from the genepool
      dna.genes[0] = n;
      //DNA dna = gpl.genepool.get(0); // Get's a specific strain of dna from the genepool
      
      // Set the start & end color of the strain according to the colour at the same location in the source image
      //color colorFromPixel = pixelColour(pos);
      //dna.genes[1] = hue(colorFromPixel);
      //dna.genes[2] = hue(colorFromPixel);
      //dna.genes[3] = saturation(colorFromPixel);
      //dna.genes[4] = saturation(colorFromPixel);
      //dna.genes[5] = brightness(colorFromPixel);
      //dna.genes[6] = brightness(colorFromPixel);
      //dna.genes[7] = alpha(colorFromPixel);
      //dna.genes[9] = hue(colorFromPixel);
      //dna.genes[10] = hue(colorFromPixel);
      //dna.genes[11] = saturation(colorFromPixel);
      //dna.genes[12] = saturation(colorFromPixel);
      //dna.genes[13] = brightness(colorFromPixel);
      //dna.genes[14] = brightness(colorFromPixel);
      //dna.genes[15] = alpha(colorFromPixel);
      //dna.genes[17] = map(hue(colorFromPixel), 0, 360, 10, 200);
      //dna.genes[18] = map(brightness(colorFromPixel), 0, 255, 0, 5);
      
      for (int s = 0; s < gs.strainSize; s ++) {
        //if (brightness(colorFromPixel) > 100) {population.add(new Cell(pos, vel, dna));}
        //if (hue(colorFromPixel) < 90) {population.add(new Cell(pos, vel, dna));}
        population.add(new Cell(pos, vel, dna));
      }
     //c *= 1.000003;
     //c += width * 0.0003;
     //c += width * map(cycleGen, -1, 1, 0.00001, 0.0001);
     c *= map(cycleGen, -1, 1, 1.005, 1.01);
    }
  }
  
  // Returns a color object matching the color of the equivalent pixel at the position 'pos' in the source image /data/input.png
  color pixelColour(PVector pos) {
    int pixelX = int(map(pos.x, -1, width+1, 0, img.width-1)); 
    int pixelY = int(map(pos.y, -1, height+1, 0, img.height-1));
    int pixelPos = pixelX + pixelY * img.width; // Position of pixel to be used for colour-sample
    img.loadPixels(); // Load the pixel array for the input image
    //println("pos.X: " + pos.x + " pos.Y:" + pos.y + "img.width:" + img.width + " img.Height:" + img.height + " PixelX: " + pixelX + " PixelY: " + pixelY + " pixelPos: " + pixelPos +" pixels.length: " + img.pixels.length); // DEBUG
    //float h = hue(img.pixels[pixelPos]);
    //float s = saturation(img.pixels[pixelPos]);
    //float b = brightness(img.pixels[pixelPos]);
    //float a = alpha(img.pixels[pixelPos]);
    //return color (h, s, b, a);
    return color (hue(img.pixels[pixelPos]), saturation(img.pixels[pixelPos]), brightness(img.pixels[pixelPos]), alpha(img.pixels[pixelPos]));
  }
  
  
  // Spawns a new cell using the received values for position, velocity & DNA
  void spawn(PVector pos, PVector vel, DNA dna_) {
    population.add(new Cell(pos, vel, dna_));
  }

  // Runs the colony
  void run() {
    if (gs.debug) {colonyDebugger();}                 // If debug mode = true, run debugger to print debug info about the colony
    for (int i = population.size()-1; i >= 0; i--) {  // Iterate backwards through the ArrayList because we are removing items
      Cell c = population.get(i);                     // Get one cell at a time
      c.run();                                        // Run the cell (grow, move, spawn, check position vs boundaries etc.)
      if (c.dead()) {population.remove(i);}           // If the cell has died, remove it from the array

      // Test for collision between current cell(i) and the rest
      if (population.size() <= gs.populationMaxSize && c.fertile) {  // Don't check for collisons if there are too many cells (wait until some die off)
        for (int others = i-1; others >= 0; others--) {              // Since main iteration (i) goes backwards, this one needs to too
          Cell other = population.get(others);                       // Get the other cells, one by one
          if (other.fertile) {c.checkCollision(other);}              // Only check for collisions when both cells are fertile
        }
      }
    }
  }

  // Displays some values as text at the top left corner (for debug only)
  void colonyDebugger() {
    noStroke();
    fill(0);
    rect(0,0,250,40); // Make a background & overwrite the previous text to make the new text readable 
    fill(360);
    textSize(16);
    text("Cycle: " + runCycle + " Cycle frame: " + frameCounter + " Total frames: " + frameCount + " Nr. cells: " + population.size() + " MaxLimit:" + gs.populationMaxSize + " Pattern:" + gs.patternSelector, 10, 18);
  }

}