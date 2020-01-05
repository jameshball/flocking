// Class used for rendering multiple flocks on ths screen at once.
class Species {
  Flock[] flocks;
  
  // Inputs the number of 'species' or flocks, n, and the size of each flock, s.
  Species(int n, int s) {
    flocks = new Flock[n];
    
    colorMode(HSB, 1.0);
    
    for (int i = 0; i < n; i++) {
      // Generate random hue values, and semi-random brightness values for each flock.
      flocks[i] = new Flock(s, color(random(1), random(0.8, 1), random(0.75, 1)));
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
