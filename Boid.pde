class Boid {
  PVector pos;
  PVector vel;
  float maxSpeed;
  // Size of triangle
  float size;
  int[] cell;
  
  Boid() {
    vel = new PVector(random(-1, 1), random(-1, 1));
    pos = new PVector(random(width), random(height));
    size = 3;
    maxSpeed = random(1, 3);
    cell = getCell();
  }
  
  // PVector d is the desired target to steer towards.
  void steerTo(PVector d) {
    // Calculate the vector that points to the target.
    d.sub(pos);
    float dist = d.mag();
    
    if (dist > 0) {
      // Normalise and scale the vector based on the distance to the target.
      d.normalize().mult(maxSpeed);
      vel.add(d.sub(vel).limit(cohesionWeight));
    }
  }
  
  void update() {
    //steerTo(new PVector(mouseX, mouseY));
    vel.limit(maxSpeed);
    pos.add(vel);
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }
  
  int[] getCell() {
    // Return the cell corresponding to the position the boid is currently in.
    return new int[] { (int)(pos.x/neighbourRadius), (int)(pos.y/neighbourRadius) };
  }
  
  void show(color c) {
    fill(c);
    // Translates the canvas to the position of the boid and then draws a triangle that is rotated according to the direction the boid is facing in.
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading() + PI/2);
    triangle(0, -2*size, -size, 2*size, size, 2*size);
    popMatrix();
  }
}
