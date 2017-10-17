import processing.pdf.*; // For exporting output as a .pdf file
import com.hamoid.*;     // For creating .mp4 animations from output images

Colony colony;           // A Colony object called 'colony'
Global_settings gs;      // A Global_settings object called 'gs'
Genepool gpl;            // A Genepool object called 'gpl'
PImage img;              // A PImage object called 'img' (used when importing a source image)
VideoExport videoExport; // A VideoExport object called 'videoExport' (used when exporting video)

String batchName = "batch-163.00"; // Used to define the output folder
int maxCycles = 1; // How many
int runCycle = 1;
float cycleGen, cycleGenSin;


int maxFrames = 10000;
//int maxFrames = int(random(1300,1600));
int frameCounter;

String iterationNum;
String applicationName = "sandbox";
//String inputFile = "flower.jpg"; // First run will use /data/input.png, which will not be overwritten
String inputFile = "badger.jpg"; // First run will use /data/input.png, which will not be overwritten
//String inputFile = "sushi.jpg"; // First run will use /data/input.png, which will not be overwritten
//String inputFile = "bananas.jpg"; // First run will use /data/input.png, which will not be overwritten
//String inputFile = "input.png"; // First run will use /data/input.png, which will not be overwritten
String pathName;
String screendumpPath; // Name & location of saved output (final image)
String screendumpPathGIF1; // Name & location of saved output (final image) (reverse numbering for cyclic GIFs)
String screendumpPathGIF2; // Name & location of saved output (final image) (reverse numbering for cyclic GIFs)
String screendumpPathPDF; // Name & location of saved output (pdf file)
String framedumpPath; // Name & location of saved output (individual frames)
String videoPath; // Name & location of video output (.mp4 file)
PrintWriter output;    // Object for writing to the settings logfile

void setup() {
  colorMode(HSB, 255, 255, 255, 255);
  //blendMode(DIFFERENCE);
  rectMode(RADIUS);
  ellipseMode(RADIUS);
  smooth();
  getReady(); // Create the colony
  //size(200, 200);
  //size(400, 400);
  //size(500, 500);
  //size(800, 800);
  size(1000, 1000);
  //size(1500, 1500);
  //size(2048, 2048);
  //size(4000, 4000);
  //size(5000, 5000);
  //size(6000, 6000);
  //size(8000, 8000);
  background(gs.bkgColor); // TEST ONLY
  if (gs.debug) {frameRate(1000);} else {frameRate(1000);}
  if (gs.makeMPEG) {
    videoExport = new VideoExport(this, videoPath + ".mp4");
    videoExport.setFrameRate(30);
    videoExport.setQuality(70, 128);
    videoExport.setDebugging(false);
    videoExport.startMovie();
  }
}

void draw() {
  if (colony.population.size() == 0 || frameCounter <= 0 ) {manageColony();} // Criteria for terminating & restarting a colony
  if (gs.debug) {background(gs.bkgColor);} // Refresh the background on every frame to simplify debugging
  //background(gs.bkgColor);
  colony.run(); // Update the colony
  //frameSave(); // Saves each frame as a .png (for GIFs etc.)
  //if (gs.makeMPEG) {videoExport.saveFrame();} // Use this to save every frame in the sketch
  frameCounter --;
}

// What happens when the colony goes extinct
void manageColony() {
  if (gs.savePNG) {saveFrame(screendumpPath);} // Save an image of how the colony looked when it was terminated
  if (gs.makeGIF) {saveFrame(screendumpPathGIF1);saveFrame(screendumpPathGIF2);} // Save an image plus a duplicate image with alternative iteration number
  //saveFrame("/data/output.png"); // Save a duplicate image to the /data folder to be used in next iteration
  if (gs.makePDF) {endRecord();} // If I'm in PDF-mode, complete & close the file
  if (gs.makeMPEG) {videoExport.saveFrame();} // If in MPEG mode, save one frame per iteration to the file
  endSettingsFile(); // Complete the settings logfile & close
  //exit();
  // If all iterations are completed:
  if (runCycle >= maxCycles) {
    if (gs.makeMPEG) {videoExport.endMovie();} // If in MPEG mode, complete & close the file
    exit(); // Terminate the program
  }
  //if (runCycle >= maxCycles) {exit();}
  else {
    // Increment the counter & get ready for a new cycle
    runCycle ++;
    getReady();
  }
}

void getReady() {
  img = loadImage(inputFile);
  inputFile = "output.png"; // After 1st run, all iterations will use /data/output.png as the input file
  frameCounter = maxFrames;
  iterationNum = nf(runCycle, 3);
  cycleGen = map(runCycle, 0, maxCycles, 0, 1); // global linear modulator value in range 0-1
  cycleGenSin = map(sin(PI * map(runCycle, 0, maxCycles, 1.5, 3.5)), -1, 1, 0, 1); // global cyclic modulator value in range 0-1
  //println("Iteration: " + runCycle + " cycleGenSin: " + cycleGenSin);
  String iterationNum2 = nf((maxCycles * 2 - runCycle), 3);
  pathName = "../../output/" + applicationName + "/" + batchName + "/" + String.valueOf(width) + "x" + String.valueOf(height) + "/"; //local
  //pathName = "D:/output/" + applicationName + "/" + batchName + "/"+ String.valueOf(width) + "x" + String.valueOf(height) + "/"; //USB

  screendumpPath = pathName + "/png/" + batchName + "-" + iterationNum + ".png";
  //screendumpPath = "../output.png"; // For use when running from local bot
  screendumpPathGIF1 = pathName + "/jpg/" + batchName + "-" + iterationNum + ".jpg";
  screendumpPathGIF2 = pathName + "/jpg/" + batchName + "-" + iterationNum2 + ".jpg";
  screendumpPathPDF = pathName + "/pdf/" + batchName + "-" + iterationNum + ".pdf";
  framedumpPath = pathName + "/frames/";
  videoPath = pathName + "/" + batchName;

  output = createWriter(pathName + "/settings/" + batchName + "-" + iterationNum +".settings.log"); //Open a new settings logfile

  startSettingsFile();
  gs = new Global_settings();
  gpl = new Genepool();
  colony = new Colony();
  if (gs.makePDF) {beginRecord(PDF, screendumpPathPDF);}
  //background(gs.bkgColor);
  //image(img,(width-img.width)*0.5, (height-img.height)*0.5); // Displays the image file /data/output.png (centered)
}
 //<>//
void startSettingsFile() {
String timeStamp = (year() + "" + month() + "" + day() + "-" + hour() + "" + minute() + "" + second());
output.println("Iteration: " + iterationNum + " " + timeStamp);
output.println(screendumpPath);
}

void endSettingsFile() {
  output.println("Total frames: " + (maxFrames - frameCounter)); // Update the log with the number of frames used
  output.flush();
  output.close(); //Flush and close the settings file
}

// Saves a frame as .jpg to framedumpPath
void frameSave() {
  String frameName = nf(frameCount, 5);
  saveFrame(framedumpPath + frameName + ".jpg");
}