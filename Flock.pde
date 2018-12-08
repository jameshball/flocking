// Flock class used to manage multiple boids and draw them all on the screen at once.
class Flock {
  Boid[] boids;
  color col;
  float maxRadius = max(neighbourRadius, separationRadius);
  
  // Inputs the size of the flock and the colour.
  Flock(int s, color col) {
    boids = new Boid[s];
    this.col = col;
    
    for (int i = 0; i < boids.length; i++) {
      boids[i] = new Boid();
    }
  }
  
  // Apply the cohesion behavior to a boid, given its neighbours.
  void cohesion(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(neighbours.get(j).pos) < neighbourRadius) {
        total.add(neighbours.get(j).pos);
      }
    }
    
    // Steer towards the average location of all neighbouring boids.
    boids[i].steerTo(total.div(neighbours.size()));
  }
  
  // Apply the alignment behavior to a boid, given its neighbours.
  void alignment(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(neighbours.get(j).pos) < neighbourRadius) {
        total.add(neighbours.get(j).vel);
      }
    }
    
    total.div(neighbours.size());
    
    // Apply the average velocity of all neighbouring boids.
    boids[i].vel.add(total.mult(alignmentWeight));
  }
  
  // Apply the separation behavior to a boid, given its neighbours.
  void separation(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(neighbours.get(j).pos) < separationRadius) {
        // Temporary variables
        PVector iPos = boids[i].pos.copy();
        PVector jPos = neighbours.get(j).pos.copy();
        
        // This adds a vector that points in the opposite direction of the other vector that is inversely proportional to its distance to boid i.
        total.add(iPos.sub(jPos).normalize().div(iPos.dist(jPos)));
      }
    }
    
    // Apply the average separation velocity of all neighbouring boids.
    boids[i].vel.add(total.div(neighbours.size()).mult(separationWeight));
  }
  
  // Get the list of all neighbours of a particular boid. sideCheck is false when the opposite side (as the boids can go from one side to another) hasn't been checked yet.
  ArrayList<Boid> neighbours(PVector pos, float radius) {
    ArrayList<Boid> neighbours = new ArrayList();
    
    for (int j = 0; j < boids.length; j++) {
      if (pos.dist(boids[j].pos) < radius) {
        neighbours.add(boids[j]);
      }
    }
    
    return neighbours;
  }
  
  // Update creates a new thread which applies the flocking bechaviours to each boid.
  // Threading (even just one thread per frame) improves performance significantly.
  void update() { //<>//
    Runnable r = new UpdateBoid();
    new Thread(r).start();
  }
  
  void show() {
    for (int i = 0; i < boids.length; i++) {
      boids[i].show(col);
    }
  }
  
  class UpdateBoid implements Runnable {
    void run() {
      for (int i = 0; i < boids.length; i++) {
        ArrayList<Boid> neighbours = neighbours(boids[i].pos, maxRadius);
    
        cohesion(i, neighbours);
        alignment(i, neighbours);
        separation(i, neighbours);
        boids[i].update();
      }
    }
  }
}
