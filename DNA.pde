// Class to describe DNA
// Borrowed from 'Evolution EcoSystem'
// by Daniel Shiffman <http://www.shiffman.net> #codingrainbow

/* The DNA class creates a genotype DNA object containing an array of float values (or 'genes')
*  The genes are determined by predefined values & functions in the constructor
*  Each time the class is called, the values for the DNA created are appended to the "_settings.txt" file
*/

class DNA {

  float[] genes;  // 'genes' is an array of float values in the range (0-1)
  int numGenes;

  // Constructor (makes a random DNA)
  DNA() {
      numGenes = 36;
      genes = new float[numGenes];  // DNA contains an array called 'genes' with [34] float values

// ID, fill_H_start, fill_H_end, fill_S_start, fill_S_end, fill_B_start, fill_B_end, fill_A_start, fill_A_end, stroke_H_start, stroke_H_end, stroke_S_start, stroke_S_end, stroke_B_start, stroke_B_end, stroke_A_start, stroke_A_end, size_start, size_end, flatness_start, flatness_end, twist_Start, twist_End, noisePercent_Start, noisePercent_End, noise_vMax, noise_Step, noise_xOff, noise_yOff, fertility, spawnLimit, lifespan, StripeSize, StripeRatio

      // DNA gene mapping (29 genes)
      // 0=ID
      // 1=fill_H_start
      // 2=fill_H_end
      // 3=fill_S_start
      // 4=fill_S_end
      // 5=fill_B_start
      // 6=fill_B_end
      // 7=fill_A_start
      // 8=fill_A_end
      // 9=stroke_H_start
      // 10=stroke_H_end
      // 11=stroke_S_start
      // 12=stroke_S_end
      // 13=stroke_B_start
      // 14=stroke_B_end
      // 15=stroke_A_start
      // 16=stroke_A_end
      // 17=size_start (in units of 1/1000 of width, so if width = 1000, 1 = 1 pixel)
      // 18=size_end (expressed as % of size_start)
      // 19=flatness_start
      // 20=flatness_end
      // 21=twist_Start
      // 22=twist_End
      // 23=noisePercent_Start
      // 24=noisePercent_End
      // 25=noise_vMax
      // 26=noise_Step
      // 27=noise_xOff
      // 28=noise_yOff
      // 29=fertility
      // 30=spawnLimit
      // 31=lifespan (in units of 1/1000 of width, so if width = 1000, 100 = 100 frames)
      // 32=StripeSize
      // 33=StripeRatio
      // 34=Sawtooth_1_scaling_factor
      // 35=Sawtooth_2_scaling_factor
      
      genes[0] = 0;  // id
      
      genes[1]= 200;
      //genes[1]= random(200, 260);   // 1=fill_H_start
      //genes[1]= random(255);   // 1=fill_H_start
      //genes[1]= 300 + map(cycleGenSin, 0, 1, 0, 30);   // 1=fill_H_start

      //genes[1]= cycleGen;
      //genes[1]= gs.bkg_H + 180;   // 1=fill_H_start
      //genes[1]= gs.bkg_H + random(170, 210);   // 1=fill_H_start
      //genes[1]= gs.bkg_H + 240;   // 1=fill_H_start
      //genes[2]= gs.bkg_H + 60;   // 1=fill_H_start
      //genes[2]= 90;   // 2=fill_H_end
      genes[2]= genes[1] * random (0.80, 1.2);   // 2=fill_H_end
      //genes[2]= genes[1] + 0.1;   // 2=fill_H_end
      //genes[2]= gs.bkg_H + 10;   // 2=fill_H_end
      //genes[2]= gs.bkg_H * random (0.75, 1.2);   // 2=fill_H_end
      //genes[2]= gs.bkg_H;   // 2=fill_H_end
      //genes[2]= 240 + map(cycleGenSin, 0, 1, 0, 30);   // 2=fill_H_end
      //genes[2]= map(runCycle, 1, maxCycles, 360, 719);

      genes[3]= 128;
      //genes[3]= random(130,180);   // 3=fill_S_start  
      //genes[3]= map(cycleGenSin, 0, 1, 0, 100);   // 3=fill_S_start
      //genes[3]= gs.bkg_S;   // 3=fill_S_start
      genes[4]= 255;
      //genes[4]= map(cycleGenSin, 0, 1, 100, 255);   // 4=fill_S_end
      //genes[4]= gs.bkg_S;   // 4=fill_S_end
      //genes[4]= gs.bkg_S * random(0.5, 0.9);   // 4=fill_S_end
      
      genes[5]= 128;
      //genes[5]= gs.bkg_B;   // 5=fill_B_start
      //genes[5]= map(cycleGenSin, 0, 1, 164, 200);   // 5=fill_B_start
      genes[6]= 255;
      //genes[6]= map(cycleGenSin, 0, 1, 255,64);   // 6=fill_B_end
      //genes[6]= gs.bkg_B * random(0.9, 1.1);   // 6=fill_B_end
      //genes[6]= gs.bkg_B * 0.5;   // 6=fill_B_end
      
      genes[7]= 255;   // 7=fill_A_start
      genes[8]= 255;   // 8=fill_A_end
      
      genes[9]= 0;   // 9=stroke_H_start
      //genes[9]= random(360);   // 9=stroke_H_start
      //genes[9]= gs.bkg_H;   // 9=stroke_H_start
      genes[10]= 0;   // 10=stroke_H_end
      //genes[10]= gs.bkg_H;   // 10=stroke_H_end
      
      genes[11]= 0;   // 11=stroke_S_start
      //genes[11]= gs.bkg_S;   // 11=stroke_S_start
      genes[12]= 0;   // 12=stroke_S_end
      
      genes[13]= 1;   // 13=stroke_B_start
      genes[14]= 1;   // 14=stroke_B_end
      
      genes[15]= 2;   // 15=stroke_A_start
      //genes[15]= random(5.5, 16.3);   // 15=stroke_A_start
      genes[16]= 15;   // 16=stroke_A_end
      
      genes[17]= 0.2;   // 17=size_start. Range 0-1, % of gs.maxSize
      //genes[17]= 500/((gs.rows)*random(1, 2));   // 17=size_start CARTESIAN GRID
      //genes[17]= (500/gs.rows)*0.5;   // 17=size_start CARTESIAN GRID
      //genes[17]= random(0.15, 0.4);   // 17=size_start
      
      genes[18]= 0.5;   // 18=size_end. Range 0-1, % of genes[17]
      //genes[18]= random(0.05, 0.25);   // 18=size_end
      
      //genes[19]= map(cycleGenSin, 0, 1, 100, 150);   // 19=flatness_start
      genes[19]= random (1, 1.5);   // 19=flatness_start
      genes[20]= map(cycleGenSin, 0, 1, 1, 1.5);   // 20=flatness_end
      
      //genes[21]= map(cycleGenSin, 0, 1, -5, 5);   // 21=twist_start
      genes[21]= random(-1, -1);   // 21=twist_start
      //genes[22]= map(cycleGenSin, 0, 1, -3, 3);   // 22=twist_end
      //genes[21]= 0; // 21=twist_start
      //genes[22]= 0.8; // 22=twist_end
      genes[22]= random(-1, 1);   // 22=twist_end

      genes[23]= 0.5;   // 23=noisePercent_start (range: 0-1)
      //genes[23]= random(0,100);   // 23=noisePercent_start
      genes[24]= 1;   // 24=noisePercent_End (range: 0-1)
      //genes[24]= random(0,100);   // 24=noisePercent_end
      
      //genes[25]= random(2, 4);   // 25=noise_vMax
      genes[25]= 2;
      //genes[26]= random(0.001, 0.006);   // 26=noise_step
      genes[26]= 0.003;
      genes[27]= random(1);   // 27=noise_xOff
      //genes[27]= 500;
      genes[28]= random(1);   // 28=noise_yOff
      //genes[28]= 1;

                  
      genes[29]= 0.5;   // 29=fertility
      //println("At " + frameCount + ", In DNA, genes[29]= " + genes[29]);
      //genes[29]= random(0.65, 0.85);   // 29=fertility
      genes[30]= 0.6;   // 30=spawnLimit
      //genes[30]= random(0.1, 0.3);   // 30=spawnLimit
      //genes[31]= random(0.2, 0.6);   // 31=lifespan
      //genes[31]= 0.8;   // 31=lifespan. Range 0-1, % of gs.maxLifespan
      genes[31]= random(0.3, 0.6);   // 31=lifespan
      
      //genes[32]= random(20,60);   // 32=StripeSize
      genes[32]= 0.5;   // 32=StripeSize
      //if (random(1)>0.4) {genes[32] = random(20,50);} else {genes[32] = 10000;} // 32=StripeSize
      //genes[33]= 0.01;   // 33=StripeRatio
      genes[33] = random(0.2, 0.4);  // 33=StripeRatio
      //genes[34] = 0.5;  // 34=Sawtooth_1_scaling_factor
      genes[34] = 0;  // 34=Sawtooth_1_scaling_factor 0=No step
      genes[35] = 1000.0;  // 35=Sawtooth_2_scaling_factor      
   }

  DNA combine(DNA otherDNA_) { // Returns a new set of DNA consisting of randomly selected genes from both parents
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < newgenes.length; i++) {
      if (random(1) < 0.5) {newgenes[i] = genes[i];}
      else {newgenes[i] = otherDNA_.genes[i];} // 50/50 chance of copying gene from either 'mother' or 'other'
    }
    return new DNA(newgenes);
  }

// This method accepts a float array called 'newgenes' and fills the 'genes' array with the values therein.
// It is used when the last line of the combine() method directly above returns a new DNA object to the Cell via the conception() method
  DNA(float[] newgenes) {
    genes = newgenes;
  }

}