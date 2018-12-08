// Flock class used to manage multiple boids and draw them all on the screen at once.
class Flock {
  Boid[] boids;
  color col;
  float maxRadius = max(neighbourRadius, separationRadius);
  Grid grid;
  
  // Inputs the size of the flock and the colour.
  Flock(int s, color col) {
    boids = new Boid[s];
    this.col = col;
    
    grid = new Grid((int)(width/neighbourRadius), (int)(height/neighbourRadius));
    
    for (int i = 0; i < boids.length; i++) {
      boids[i] = new Boid();
      grid.cells[boids[i].cell[0]][boids[i].cell[1]].add(i);
    }
  }
  
  // Apply the cohesion behavior to a boid, given its neighbours.
  void cohesion(int i, ArrayList<Integer> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(boids[neighbours.get(j)].pos) < neighbourRadius) {
        total.add(boids[neighbours.get(j)].pos);
        count++;
      }
    }
    
    // Steer towards the average location of all neighbouring boids.
    boids[i].steerTo(total.div(count));
  }
  
  // Apply the alignment behavior to a boid, given its neighbours.
  void alignment(int i, ArrayList<Integer> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(boids[neighbours.get(j)].pos) < neighbourRadius) {
        total.add(boids[neighbours.get(j)].vel);
        count++;
      }
    }
    
    total.div(count);
    
    // Apply the average velocity of all neighbouring boids.
    boids[i].vel.add(total.mult(alignmentWeight));
  }
  
  // Apply the separation behavior to a boid, given its neighbours.
  void separation(int i, ArrayList<Integer> neighbours) {
    PVector total = new PVector();
    int count = 0;
    
    for (int j = 0; j < neighbours.size(); j++) {
      if (boids[i].pos.dist(boids[neighbours.get(j)].pos) < separationRadius) {
        // Temporary variables
        PVector iPos = boids[i].pos.copy();
        PVector jPos = boids[neighbours.get(j)].pos.copy();
        
        // This adds a vector that points in the opposite direction of the other vector that is inversely proportional to its distance to boid i.
        total.add(iPos.sub(jPos).normalize().div(iPos.dist(jPos)));
        count++;
      }
    }
    
    // Apply the average separation velocity of all neighbouring boids.
    boids[i].vel.add(total.div(count).mult(separationWeight));
  }
  
  // Get the list of all potential neighbours of a particular boid.
  ArrayList<Integer> neighbours(int i) {
    //Get the top left cell in the 3x3 grid.
    int[] cell = new int[] { boids[i].cell[0] - 1, boids[i].cell[1] - 1 };
    
    ArrayList<Integer> neighbours = new ArrayList<Integer>();
    
    // Using r, c here as i is already being used.
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        neighbours.addAll(grid.cells[(grid.rows + cell[0] + r) % grid.rows][(grid.cols + cell[1] + c) % grid.cols].list);
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
        int[] cell = new int[] { boids[i].cell[0], boids[i].cell[1] };
        ArrayList<Integer> neighbours = neighbours(i);
    
        cohesion(i, neighbours);
        alignment(i, neighbours);
        separation(i, neighbours);
        boids[i].update();
        
        if (!(cell[0] == boids[i].cell[0] && cell[1] == boids[i].cell[1])) {
          grid.move(cell, boids[i].cell, i);
        }
      }
    }
  }
}
