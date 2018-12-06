Flock f1;
Flock f2;

void setup() {
  size(2000, 1000, P2D);
  frameRate(144);
  
  f1 = new Flock(500);
  f2 = new Flock(500);
}

void draw() {
  background(41);
  f1.update();
  f1.show();
  f2.update();
  f2.show();
}
