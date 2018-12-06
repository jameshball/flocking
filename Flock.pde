class Flock {
  Boid[] boids;
  float separationWeight = 80;
  float cohesionWeight = 1;
  float alignmentWeight = 1/200;
  color col;
    
  Flock(int s) {
    boids = new Boid[s];
    col = color(random(255), random(255), random(255));
    
    for (int i = 0; i < boids.length; i++) {
      boids[i] = new Boid();
    }
  }
  
  // Apply the cohesion behavior to a boid, given its neighbours.
  void cohesion(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(neighbours.get(j).pos) < boids[i].nRadius) {
        total.add(neighbours.get(j).pos);
        count++;
      }
    }
    
    boids[i].steerTo(total.div(count));
  }
  
  // Apply the alignment behavior to a boid, given its neighbours.
  void alignment(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(neighbours.get(j).pos) < boids[i].nRadius) {
        total.add(neighbours.get(j).pos);
        count++;
      }
    }
    
    total.div(count).normalize();
    
    boids[i].vel.add(total.mult(alignmentWeight));
  }
  
  // Apply the separation behavior to a boid, given its neighbours.
  void separation(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      // Temporary variables
      PVector iPos = boids[i].pos.copy();
      PVector jPos = neighbours.get(j).pos.copy();
      
      // If the other boid is within the separation distance...
      if (iPos.dist(jPos) < boids[i].sRadius) {
        // This adds a vector that points in the opposite direction of the other vector that is inversely proportional to its distance to boid i.
        total.add(iPos.sub(jPos).normalize().div(iPos.dist(jPos)));
        count++;
      }
    }
    
    boids[i].vel.add(total.div(count).mult(separationWeight));
  }
  
  // Get the list of all neighbours of a particular boid.
  ArrayList<Boid> neighbours(int i) {
    ArrayList<Boid> neighbours = new ArrayList();
    
    for (int j = 0; j < boids.length; j++) {
      if (boids[i].pos.dist(boids[j].pos) < max(new float[] { boids[i].nRadius, boids[i].sRadius })) {
        neighbours.add(boids[j]);
      }
    }
    
    return neighbours;
  }
  
  void update() {
    for (int i = 0; i < boids.length; i++) {
      ArrayList<Boid> neighbours = neighbours(i);

      cohesion(i, neighbours);
      alignment(i, neighbours);
      separation(i, neighbours);
      boids[i].update();
    }
  }
  
  void show() {
    for (int i = 0; i < boids.length; i++) {
      boids[i].show(col);
    }
  }
}
