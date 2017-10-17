class Cell {

  float[] modulators;  // 'modulators' is an array of float values in the range (0-1)
  
  //  Objects
  DNA dna;         // DNA

  // BOOLEAN
  boolean fertile;
  
  boolean stripeON;
  //boolean stepON;
  boolean nucleusON;
  
  boolean drawCellON;
  boolean drawNucleusON;
  
  // GROWTH AND REPRODUCTION
  int age;         // Age (nr. of frames since birth)
  float fertilityThreshold; // Condition for becoming fertile
  float fertility;
  float spawnLimit;

  // SIZE AND SHAPE
  float r;
  float flatness;  // To make flatter ellipses (1 = circle)
  
  // SAWTEETH
  int sawtooth_1, sawtooth_2, sawtooth_3;
  float sawtooth_3_limit;
  boolean sawtooth_1_Flag, sawtooth_2_Flag, sawtooth_3_Flag;

  // MOVEMENT
  PVector position; // cell's current position
  PVector home;     // cell's initial position
  //PVector origin;   // arbitrary origin (e.g. center of screen)
  //PVector toHome;   // from current to initial (=sub(home, position) )
  //PVector toOrigin; // from current to initial (=sub(origin, position) )
  
  PVector velocityRef;
  PVector velocityLinear;
  //PVector velocityNoise;
  PVector velocity;
  
  float noise_xoff, noise_yoff; // x&y noise-offset
  
  float distanceFromHome;      // How far is the cell from it's home position?
  float distanceFromOrigin;      // How far is the cell from the arbitrary origin?
  
  float directionDiff; // The difference between the current and the initial velocity heading. Range 0-1 where 1 = max diff. = 180 degrees

  // COLOUR
  color fillColor, strokeColor, pixelColor;
  
  // STRAIN
  int id;

  // **************************************************CONSTRUCTOR********************************************************
  // CONSTRUCTOR: create a 'cell' object
  Cell (PVector pos, PVector vel, DNA dna_) {
    modulators = new float[6]; // Each float holds value = 0.0 at this point
    
    // OBJECTS
    dna = new DNA();
    for (int i = 0; i < dna_.genes.length; i++) {
      dna.genes[i] = dna_.genes[i]; // Copy the contents of the referenced dnx genes into the local dna genes
    }
    
    // BOOLEAN
    fertile = false;       // Cell always starts off infertile
    drawCellON = true;     // Cell will always be drawn (unless otherwise)
    drawNucleusON = false; // Nucleus will not be drawn unless enabled & conditions met
    stripeON = false;      // Cell always starts off displaying it's normal colour
    
    id = int(dna.genes[0]);
    age = 0; // Age is number of frames a cell has existed. A new cell always starts with age = 0.
    
    // POSITION & MOVEMENT
    position = pos.copy();                // cell has current position
    home = pos.copy();                    // home = initial position
    //origin = new PVector(gs.orx, gs.ory); //arbitrary origin (replaced by gs.origin in updatePosition()
    
    updatePosition();
    
    velocity = vel.copy(); //cell has unique basic velocity component
    velocityRef = velocity.copy(); //keep a copy of the inital velocity for reference
    velocityLinear = velocity.copy(); //cell has unique basic velocity component
        
    noise_xoff = dna.genes[27]*1000; //Seed for noise-component (x)
    noise_yoff = dna.genes[28]*1000; //Seed for noise-component (y)
    // velocity, velocityRef, noise_xoff & noise_yoff must all have values before updateModulators() can be run for first time
    updateModulators(); // Why would I want to do that now? To PRIME them for any following DNA-mods
    // Once updateModulators() has been run, velocity can be calculated correctly
    updateVelocity();
    velocityRef = velocity.copy(); // velocityRef() can be redefined using the correct velocity value.
    
    // OLD remnants??
    //noise_xoff = modulator(cycleGenSin, 1, 1.5); // NOTE: max/min values are hard-coded
    //noise_yoff = map (id, 0, gpl.genepool.size(), 1, 1000) + map(cycleGenSin, 0, 1, 10, 10.5); //Strain ID is seed for noiseY
    
    
    //distanceFromOriginMods(); // IF ENABLED, IT WOULD HAVE TO BE HERE, ONCE POSITION & MODULATORS ARE INITIALISED  *******************************************
    // TEMPORARILY MOVING ALL DNA MODS HERE *************************************************************************
    
    // STATIC (ID)
    //dna.genes[17] = map(id, 0, 8, 0, 88);
    //noise_xoff = dna.genes[27] + id; //Seed for noiseX
    
    // LINEAR
    //twist_start = map(runCycle, 1, maxCycles, -2, 2); // twist_end screw amount
    //twist_end = map(runCycle, 1, maxCycles, -3, 3) * 0.01; // twist_end screw amount
    //noise_xoff = map(runCycle, 1, maxCycles, 1, 2); //Seed for noiseX
    
    // CYCLIC
    //lifespan= dna.genes[31] * width * 0.001 * map(cycleGenSin, 0, 1, 0.3, 0.7);
    //twist_start = map(cycleGenSin, 0, 1, 0, 1); // twist_end screw amount
    //noisePercent_end =map(cycleGenSin, 0, 1, 0, 100);
    //noise_xoff = modulator(cycleGenSin, 1, 1.5); // NOTE: max/min values are hard-coded
    
    // COMBINATION
    //noise_yoff = map (id, 0, gpl.genepool.size(), 1, 1000) + map(cycleGenSin, 0, 1, 10, 10.5); //Strain ID is seed for noiseY
    
    // TEMPORARILY MOVING ALL DNA MODS HERE *************************************************************************
    
     updateSize(); // Uses a MODULATOR to calculate size. 
    
    // SAWTOOTH WAVES (for Michael)
    sawtooth_1 = 0;
    sawtooth_2 = 0;
    sawtooth_3 = 0;
    sawtooth_3_limit = ((dna.genes[31] * gs.maxLifespan) - age) * 0.25;
    updateSawteeth(); // Dependant on size
    
    fertilityThreshold = dna.genes[29]; // How soon will the cell become fertile?
    spawnLimit = dna.genes[30] * gs.maxSpawns; // Max. number of spawns
    
    if (gs.debug) {cellDNALogger();} //Print the DNA for this cell
  }
  
  void distanceFromOriginMods() {
      //println("In distanceFromOriginMods:   ID:" + id + " distanceFromOrigin: " + distanceFromOrigin);
      //dna.genes[17] *= map(distanceFromOrigin, 0, width*0.5, 1.0, 0.5);
      //println("ID:" + id + " dna[17] now equals:" + dna.genes[17]);
      //radius_start *= map(distanceFromOrigin, 0, width*1.4, 0.1, 1);
  }
  
  void run() { //<>//
    updateModulators();
    updateVelocity();
    //updateVelocityByHue();
    updatePosition();
    updateSize();
    updateShape();
    updateSawteeth();
    //updateStripe();
    updateFertility();
    updateFillColor();
    updateStrokeColor();
    //updateFillColorByDirection();
    //updateStrokeColorByDirection();
    //updateFillColorByPosition();
    //updateStrokeColorByPosition();
    if (stripeON) {updateStripeColor();}
    updateStep();
    updateNucleus();
    display();
    //displayLine();
    //displayText();
    if (gs.debug) {cellDebugger();}
    increment();
  }

  // Updates the values of the parameters which are incremented on each iteration 
  void increment() {
    age ++;
    sawtooth_1 ++;
    sawtooth_2 ++;
    sawtooth_3 ++;
    noise_xoff += dna.genes[26];
    noise_yoff += dna.genes[26];
    position.add(velocity);
  }
  
  // Updates the values of each of the modulators according to their respective rules
  void updateModulators() {
    modulators[0] = map(age, 0, dna.genes[31] * gs.maxLifespan, 0, 1); // maturity is the driver tied to the aging process 'MATURITY'
    modulators[1] = map(distanceFromHome, 0, dna.genes[31] * gs.maxLifespan, 0, 1); // distanceFromHome = distance to seed-position (home). 'REMOTENESS'
    modulators[2] = map(distanceFromOrigin, 0, width, 0, 1);  // distanceFromOrigin = distance to origin. 'REMOTENESS2'
    modulators[3] = map(PVector.angleBetween(velocityRef, velocity), 0, PI, 0, 1); // MODULATOR in updateVelocity()
    modulators[4] = noise(noise_xoff); // NOISE_X
    modulators[5] = noise(noise_yoff); // NOISE_Y
    
    // Examples from earlier experiments...
    //remoteness = sq(map(distanceFromHome, 0, lifespan, 0, 1)); // remoteness is a value between 0-1.
    //remoteness = sq(map(distanceFromOrigin, 0, lifespan, 0, 1)); // remoteness is a value between 0-1.
    //r = map(hue(pixelColor), 360, 0, radius_start, radius_end); // Size from pixel brightness
    //r = ((sin(map(distMag, 0, 500, 0, PI)))+0)*radius_start;
    //r = (((sin(map(remoteness, 0, 1, 0, PI*0.5)))+0)*radius_start) + radius_end;
    //r = (((sin(map(age, 0, lifespan, 0, PI)))+0)*radius_start) + radius_end;
  }
  
  void updateSawteeth() {
    // sawtooth_1 starts at zero and increases by +1 each run-cycle
    // It sets 'sawtooth_1_Flag' to TRUE and resets to zero every time it passes the limit 'sawtooth_1_limit'
    float sawtooth_1_limit = r * dna.genes[34];
    if (sawtooth_1 > sawtooth_1_limit) {sawtooth_1_Flag = true; sawtooth_1 = 0;} else {sawtooth_1_Flag = false;}
    
    //float sawtooth_2_limit = r * dna.genes[35];
    float sawtooth_2_limit = ((dna.genes[31] * gs.maxLifespan) - age) * 0.5;
    if (sawtooth_2 > sawtooth_2_limit) {sawtooth_2_Flag = true; sawtooth_2 = 0;} else {sawtooth_2_Flag = false;}
    
    //if (stripeON) {sawtooth_3_limit = r * 2 * dna.genes[32] * dna.genes[33];} else {sawtooth_3_limit = r * 2 * dna.genes[32] * (1- dna.genes[33]);}
    //if (sawtooth_3 > sawtooth_3_limit) {sawtooth_3_Flag = true; sawtooth_3 = 0;} else {sawtooth_3_Flag = false;}
    if (sawtooth_3 > sawtooth_3_limit) {
      sawtooth_3_Flag = true;
      sawtooth_3 = 0;
      sawtooth_3_limit = ((dna.genes[31] * gs.maxLifespan) - age) * 0.25;
    } 
    else {
      sawtooth_3_Flag = false;
    }
  }
  
  void updateStep() {
    if (sawtooth_1_Flag) {drawCellON = true;} else {drawCellON = false;}
  }
  
  void updateNucleus() {
    if (sawtooth_1_Flag) {drawNucleusON = true;} else {drawNucleusON = false;}
  }
  
  void updateStripe() {
    if (sawtooth_2_Flag) {stripeON = !stripeON;}
  }

  void updateVelocity() {
    //Update Perlin noise vector 
    float vx = modulator(modulators[4], -dna.genes[25], dna.genes[25]);
    float vy = modulator(modulators[5], -dna.genes[25], dna.genes[25]);
    PVector velocityNoise = new PVector(vx,vy);
    
    //Update noisePercent
    float noisePercent = modulator(modulators[0], dna.genes[23], dna.genes[24]);
    
    //Update twistAngle
    float twist = radians(modulator(modulators[0], dna.genes[21], dna.genes[22]));
    
    //Interpolate between the linear and noise vectors
    velocity = PVector.lerp(velocityLinear.rotate(twist), velocityNoise, noisePercent);
    //velocity.normalize(); // TEST. To see how this looks, velocity only contributes direction, is always a unit vector.
  }
  
  void updateVelocityByHue() {
    velocity = PVector.fromAngle(radians(hue(pixelColor)));
    float twist = radians(modulator(modulators[1], dna.genes[21], dna.genes[22]));
    velocity.rotate(twist);
  }
  
  
  void updatePosition() { //<>//
    //pixelColor = colony.pixelColour(position);
    
    PVector toHome = PVector.sub(home, position); // static vector pointing from cell to home
    distanceFromHome = toHome.mag(); // distanceFromHome is how far the cell is from home at any time. MODULATOR
    
    PVector toOrigin = PVector.sub(gs.origin, position); // static vector pointing from cell to origin
    distanceFromOrigin = toOrigin.mag(); // distance from pos to origin. MODULATOR
  }

  void updateSize() {
    r = modulator(modulators[0], dna.genes[17], dna.genes[17] * dna.genes[18]) * gs.maxSize;
  }

  void updateShape() {
  flatness = modulator(modulators[0], dna.genes[19], dna.genes[20]);
  }
  
  void updateFertility() {
    fertility = (1-modulators[0]);
    if (fertility <= fertilityThreshold) {fertile = true; } else {fertile = false; }
    if (spawnLimit == 0) {fertilityThreshold = 0;} // Once spawnLimit has counted down to zero, the cell will spawn no more
  }
  
  void updateFillColor() {
    // START > END
    float h = (modulator(modulators[0], dna.genes[1], dna.genes[2])) % 255;
    float s = modulator(modulators[0], dna.genes[3], dna.genes[4]);
    float b = modulator(modulators[0], dna.genes[5], dna.genes[6]);
    float a = modulator(modulators[0], dna.genes[7], dna.genes[8]);
    fillColor = color(h, s, b, a); //fill colour is updated with new values
  }
  
  void updateStrokeColor() {
    // START > END
    float h = (modulator(modulators[0], dna.genes[9], dna.genes[10])) % 255;
    float s = modulator(modulators[0], dna.genes[11], dna.genes[12]);
    float b = modulator(modulators[0], dna.genes[13], dna.genes[14]);
    float a = modulator(modulators[0], dna.genes[15], dna.genes[16]);
    strokeColor = color(h, s, b, a); //fill colour is updated with new values
  }


  //void updateFillColorByDirection() {
  //  float fill_H = map(directionDiff, 0, PI, fill_H_start, fill_H_end) % 360;
  //  float fill_S = map(directionDiff, 0, PI, fill_S_start, fill_S_end);
  //  float fill_B = map(directionDiff, 0, PI, fill_B_start, fill_B_end);
  //  float fill_A = map(maturity, 0, 1, fill_A_start, fill_A_end);
  //  fillColor = color(fill_H, fill_S, fill_B, fill_A); //fill colour is updated with new values
  //}
  
  //void updateStrokeColorByDirection() {
  //  float stroke_H = map(directionDiff, 0, PI, stroke_H_start, stroke_H_end) % 360;
  //  float stroke_S = map(directionDiff, 0, PI, stroke_S_start, stroke_S_end);
  //  float stroke_B = map(directionDiff, 0, PI, stroke_B_start, stroke_B_end);
  //  float stroke_A = map(maturity, 0, 1, stroke_A_start, stroke_A_end);
  //  strokeColor = color(stroke_H, stroke_S, stroke_B, stroke_A); //stroke colour is updated with new values
  //}
  
  void updateFillColorByPosition() {
  //fillColor = colony.pixelColour(position);
  //float fill_H = hue(pixelColor);
  //float fill_S = saturation(pixelColor);
  //float fill_B = brightness(pixelColor);
  //float fill_A = alpha(fillColor); // alpha from pixelColor is not used as it is always 100%
  fillColor = color(hue(fillColor), saturation(fillColor), brightness(pixelColor), alpha(fillColor)); //fill colour is updated with new values
  //fillColor = pixelColor;
  }
  
  void updateStrokeColorByPosition() {
    strokeColor = color(hue(pixelColor), saturation(pixelColor), brightness(pixelColor), alpha(strokeColor));
    //strokeColor = pixelColor;
  }

  void updateStripeColor() {
    //fillColor = color(34, 255, 255, 255); // RED
    //fillColor = strokeColor;
    fillColor = color(0, 0, 0, 0); // BLACK
    //fillColor = gs.bkgColor; // Background
    //fillColor = color(0, 0, 255); // WHITE
    //strokeColor = color(0, 0, 0);  
  }
  
  void updateNucleusColor() {
    if (fertile) {fillColor = gs.nucleusColorF;} else {fillColor = gs.nucleusColorU;}
    strokeColor = color(1,1,1,0);
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    float angle = velocity.heading();
    rotate(angle);
    if (drawCellON) {drawSomething(fillColor, strokeColor, r, r*flatness, 1);}
    if (drawNucleusON) {updateNucleusColor(); drawSomething(fillColor, strokeColor, r*0.1, r*0.1, 1);}
    if (drawNucleusON) {updateNucleusColor(); drawSomething(strokeColor, fillColor, r*0.1, r*0.1, 1);}
    popMatrix(); 
  }
  
  void drawSomething(color fillCol, color strokeCol, float xSize, float ySize, int type) {
    strokeWeight(1);
    fill(fillCol);
    stroke(strokeCol);
    if (type == 1) {ellipse(0, 0, xSize, ySize);}
    if (type == 2) {rect(0, 0, xSize, ySize);}
    if (type == 3) {point(0, 0);}
  }

void displayLine() {
  float size_start = dna.genes[17] * gs.maxSize;
  float t = constrain (r * 0.1, 2, size_start);
  strokeWeight(t);
  fill(fillColor);
  stroke(fillColor);
  
  float angle = velocity.heading();
  pushMatrix();
  translate(position.x, position.y);
  rotate(angle);
  line(0, -r, 0, r);
  fill(0);
  noStroke();
  ellipse(0,-r, t, t);
  ellipse(0, r, t, t);
  //line(0, 0, 0, -r);
  popMatrix();
}

//void displayText() {
//    textSize(r*0.5);
//    strokeWeight(1);
//    stroke(strokeColor);
//    fill(fillColor);

//    float angle = velocity.heading();
//    pushMatrix();
//    translate(position.x,position.y);
//    rotate(angle);
//    String word = gs.words.get(id);
//    text(word, 0, 0);
    
//   popMatrix();
//  }



  void checkCollision(Cell other) {       // Method receives a Cell object 'other' to get the required info about the collidee
      PVector distVect = PVector.sub(other.position, position); // Static vector to get distance between the cell & other
      float distMag = distVect.mag();       // calculate magnitude of the vector separating the balls
      if (distMag < (r + other.r)) { conception(other);} // Spawn a new cell
  }

  void conception(Cell other) {
    // Decrease spawn counters.
    spawnLimit --;
    other.spawnLimit --; //<>// //<>// //<>// //<>//

    // Calculate velocity vector for spawn as being centered between parent cell & other
    PVector spawnVel = velocity.copy(); // Create spawnVel as a copy of parent cell's velocity vector
    spawnVel.add(other.velocity);       // Add dad's velocity
    spawnVel.normalize();               // Normalize to leave just the direction and magnitude of 1 (will be multiplied later)
    spawnVel.rotate(random(PI));

    // Combine the DNA of the parent cells
    DNA childDNA = dna.combine(other.dna);

    // Calculate new fill colour for child (a 50/50 blend of each parent cells)
    //color childFillColor = lerpColor(fillColor, other.fillColor, 0.5);

    // Calculate new stroke colour for child (a 50/50 blend of each parent cells)
    //color childStrokeColor = lerpColor(strokeColor, other.strokeColor, 0.5);

    // Genes for color require special treatment as I want childColor to be a 50/50 blend of parents colors
    // I will therefore overwrite color genes with reverse-engineered values after lerping:
    //childDNA.genes[1] = hue(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[3] = saturation(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[5] = brightness(childFillColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[9] = hue(childStrokeColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[11] = saturation(childStrokeColor); // Get the  lerped hue value and map it back to gene-range
    //childDNA.genes[13] = brightness(childStrokeColor); // Get the  lerped hue value and map it back to gene-range

    childDNA.genes[17] = (r + other.r) * 0.5 / gs.maxSize; // Child size_start is set at average of parents current radii

    colony.spawn(position, spawnVel, childDNA);

    //Reduce fertility for parent cells by squaring them
    fertilityThreshold *= fertility;
    fertile = false;
    other.fertilityThreshold *= other.fertility;
    other.fertile = false;
  }

  // Death
  boolean dead() {
    if (age >= dna.genes[31] * gs.maxLifespan) {return true;} // Death by old age (regardless of size, which may remain constant)
    if (r < dna.genes[17]*dna.genes[18]*gs.maxSize) {return true;} // Death by too little size
    //if (r > (width*0.1)) {return true;} // Death by too much size
    if (spawnLimit <= 0) {return true;} // Death by too much babies
    //if (position.x > width + r * dna.genes[19] || position.x < -r * dna.genes[19] || position.y > height + r * dna.genes[19] || position.y < -r * dna.genes[19] {return true;} // Death if move beyond canvas boundary
    if (position.x > width || position.x < 0 || position.y > height || position.y < 0) {return true;} // Death if move beyond border
    else { return false; }
    //return false; // Use to disable death
  }

  void cellDebugger() { // For debug only
    int rowHeight = 15;
    fill(120, 0, 255);
    textSize(rowHeight);
    text("id: " + id, position.x, position.y + rowHeight * 0);
    text("age: " + age, position.x, position.y + rowHeight * 1);
    //text("maturity:" + maturity, position.x, position.y + rowHeight * 2);
    text("r: " + r, position.x, position.y + rowHeight * 2);
    //text("sawtooth_1: " + sawtooth_1, position.x, position.y + rowHeight * 3);
    //text("drawCellON: " + drawCellON, position.x, position.y + rowHeight * 4);
    //text("sawtooth_1_Flag: " + sawtooth_1_Flag, position.x, position.y + rowHeight * 5);
    text("sawtooth_2: " + sawtooth_2, position.x, position.y + rowHeight * 3);
    text("sawtooth_2_Flag: " + sawtooth_2_Flag, position.x, position.y + rowHeight * 5);
    text("stripeON:" + stripeON, position.x, position.y + rowHeight * 6);
    //text("drawNucleusON: " + drawNucleusON, position.x, position.y + rowHeight * 8);
    //text("gene[17]:" + dna.genes[17], position.x, position.y + rowHeight * 4);
    //text("gene[18]:" + dna.genes[18], position.x, position.y + rowHeight * 5);
    //text("gene[17*18]:" + dna.genes[17]*dna.genes[17], position.x, position.y + rowHeight * 6);
    //text("pos:" + position.x + "," + position.y, position.x, position.y + rowHeight * 0);
    //text("distanceFromHome:" + int(distanceFromHome), position.x, position.y + rowHeight * 4);
    //text("fill_H:" + hue(fillColor), position.x, position.y + rowHeight * 1);
    //text("fill_S:" + saturation(fillColor), position.x, position.y + rowHeight * 2);
    //text("fill_B:" + brightness(fillColor), position.x, position.y + rowHeight * 6);
    //text("fill_A:" + alpha(fillColor), position.x, position.y + rowHeight * 4);
    //text("stroke_H:" + hue(strokeColor), position.x, position.y + rowHeight * 1);
    //text("stroke_S:" + saturation(strokeColor), position.x, position.y + rowHeight * 2);
    //text("stroke_B:" + brightness(strokeColor), position.x, position.y + rowHeight * 3);
    //text("stroke_A:" + alpha(strokeColor), position.x, position.y + rowHeight * 4);
    //text("lifespan:" + dna.genes[31] * gs.maxLifespan, position.x, position.y + rowHeight * 1);  
    //text("fertile:" + fertile, position.x, position.y + rowHeight * 4);
    //text("fertilityThreshold:" + fertilityThreshold, position.x, position.y + rowHeight * 3);
    //text("spawnLimit:" + spawnLimit, position.x, position.y + rowHeight * 4);
    //text("vel.x:" + velocity.x, position.x, position.y + rowHeight * 4);
    //text("vel.x:" + velocity.y, position.x, position.y + rowHeight * 5);
    //text("dirDiff:" + directionDiff, position.x, position.y + rowHeight * 2);
    //text("twist:" + twist, position.x, position.y + rowHeight * 4);
    //text("distanceFromOrigin:" + distanceFromOrigin, position.x, position.y + rowHeight * 3);
    //text("noise%:" + noisePercent, position.x, position.y + rowHeight * 3);
  }
  
  void cellDNALogger() {
    for (int i = 0; i < dna.genes.length; i++) {
      float value = dna.genes[i];
      output.println("Gene:" + i + ": has value " + value);
    }
  }
  
  float modulator (float scalar, float start, float end) {
    float modulated = map (scalar, 0, 1, start, end);
    //if (gs.debug) {println("ID: " + id + " scalar = " + scalar + " start = " + start + " end = " + end + " MODULATED = " + modulated);}
    return modulated;
  }

}