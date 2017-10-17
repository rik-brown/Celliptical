class Genepool {

/* The Genepool class creates and populates an ArrayList for all the DNA available to the Colony
*
*  The genepool object contains:
*  1) A fixed number of predefined genotypes (DNA objects) loaded from /data/genepool.csv
*  2) A configurable number of genotypes created by iteratively applying the DNA constructor
*
*/

  // VARIABLES
  ArrayList<DNA> genepool;  // An arraylist for all the strains of dna
  Table genetable;          // A table of gene data
  int numPredefined;        // Used to count the number of predefined DNA in the genepool (#rows in the source .csv)

  // CONSTRUCTOR: Creates a 'Genepool' object
  Genepool() {
    genepool = new ArrayList<DNA>();
    genetable = loadTable("genepool.csv", "header");
    numPredefined = genetable.getRowCount(); // Count the number of rows initially (minus header)

    // This for-loop reads each row of the .csv and adds a DNA object to the genepool using the values
    for (TableRow row : genetable.rows()) {
      float[] newgenes = new float[genetable.getColumnCount()];
      // Iterate through all the columns, getting each value and add it to newgenes[]
      for(int col = 0; col < genetable.getColumnCount(); col++) {
        float value = row.getFloat(col);
        newgenes[col] = value; //Add the value pulled from the table to it's respective position in the array
      }
      // This code may be used to inject some random into specific genes in the DNA stored in genepool.csv
      //newgenes[17]= 500/gs.rows;
      //newgenes[25]= random(2, 4);   // 25=noise_vMax
      //newgenes[26]= random(0.001, 0.006);   // 26=noise_step
      //newgenes[27]= random(1);   // 27=noise_xOff
      //newgenes[28]= random(1);   // 28=noise_yOff
      //newgenes[31]= random(1);   // 31=lifespan

      // Add a new DNA object to the genepool using the array newgenes[] with data from .csv row
      genepool.add(new DNA(newgenes));

    }
    // This for-loop calls the newDNA constructor 'gs.numStrains' times to make different DNA-strains & add them to the 'genepool' arraylist
    // (they are also added to the .csv table, for posterity)
    for (int g = 0; g < gs.numStrains; g++) {
      DNA newDNA = new DNA(); // Create a new DNA object from the constructor template (id gene[0] will always be =0)
      TableRow newRow = genetable.addRow();
      int rows = genetable.getRowCount()-1;
      newDNA.genes[0] = rows; // Set id gene[0] to a value equal to the number of the new row (subtracting 1 for the header)
      newRow.setFloat(0, rows); // Add id to the first column
      // Iterate through the remaining rows of the table, starting at column 1
      for (int i = 1; i < newDNA.genes.length; i++) {
        float value = newDNA.genes[i];
        newRow.setFloat(i, value);
      }
      genepool.add(newDNA); // Add new DNA object to the genepool. numStrains = nr. of unique genomes
    }

    // The current 'genetable' (including a copy of the original .csv and all DNA added in this constructor) is saved to file
    String newFileName = pathName + "/csv/" + batchName + "-" + iterationNum +".genepool.csv";
    saveTable(genetable, newFileName);

    // In debug-mode, the value of a specific gene in each DNA will be printed to the terminal
    if (gs.debug) {
      for (int i = 0; i < genepool.size(); i++) {
        int gene = 32;
        DNA debugDNA = genepool.get(i); //get the DNA that you just put in back out again
        println("Genepool strain# " + i + ": contains gene [" + gene + "] with value " + debugDNA.genes[gene]);
      }
    }
  }
}
