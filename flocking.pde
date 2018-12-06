Flock flock;

void setup() {
  size(2000, 1000, P2D);
  frameRate(144);
  
  flock = new Flock(500);
}

void draw() {
  background(41);
  flock.update();
  flock.show();
}
