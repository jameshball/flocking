// Class used for rendering multiple flocks on ths screen at once.
class Species {
  
  Flock[] flocks;
  
  // Inputs the number of 'species' or flocks, n, and the size of each flock, s.
  Species(int n, int s) {
    flocks = new Flock[n];
    
    // Change colour mode and generate random value for hue, between 0 and 0.75.
    // Values greater than 0.75 looked very similar with multiple flocks, hence the limit.
    colorMode(HSB, 1.0);
    float r = random(0.75);
    
    for (int i = 0; i < n; i++) {
      // Equally space the hue values for each flock.
      flocks[i] = new Flock(s, color(r + i*(1/(float)n), 1, 1));
    }
    
    colorMode(RGB, 255);
  }
  
  void update() {
    for (int i = 0; i < flocks.length; i++) {
      flocks[i].update();
    }
  }
  
  void show() {
    for (int i = 0; i < flocks.length; i++) {
      flocks[i].show();
    }
  }
}
