class Flock {
  Boid[] boids;
  float separationWeight = 100;
  //float alignmentWeight = 0.01;
  float alignmentWeight = 1;
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
    
    for (int j = 0; j < neighbours.size(); j++) {
      total.add(shiftedPos(i, neighbours.get(j).pos));
    }
    
    boids[i].steerTo(total.div(neighbours.size()));
  }
  
  // Apply the alignment behavior to a boid, given its neighbours.
  void alignment(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    
    for (int j = 0; j < neighbours.size(); j++) {
      total.add(shiftedPos(i, neighbours.get(j).pos));
    }
    
    total.div(neighbours.size()).normalize();
    
    boids[i].vel.add(total.mult(alignmentWeight));
  }
  
  // Apply the separation behavior to a boid, given its neighbours.
  void separation(int i, ArrayList<Boid> neighbours) {
    PVector total = new PVector();
    
    for (int j = 0; j < neighbours.size(); j++) {
      // Temporary variables
      PVector iPos = boids[i].pos.copy();
      PVector jPos = shiftedPos(i, neighbours.get(j).pos);
      
      // This adds a vector that points in the opposite direction of the other vector that is inversely proportional to its distance to boid i.
      total.add(iPos.sub(jPos).normalize().div(iPos.dist(jPos)));
    }
    
    boids[i].vel.add(total.div(neighbours.size()).mult(separationWeight));
  }
  
  PVector shiftedPos(int i, PVector target) {
    PVector pos = boids[i].pos;
    float radius = boids[i].nRadius;
    target = target.copy();
    
    if (pos.dist(target) < radius) {
      return target;
    }
    else if (pos.dist(new PVector(target.x + width, target.y)) < radius) {
      target.x += width;
    }
    else if (pos.dist(new PVector(target.x - width, target.y)) < radius) {
      target.x -= width;
    }
    else if (pos.dist(new PVector(target.x, target.y + height)) < radius) {
      target.y += height;
    }
    else if (pos.dist(new PVector(target.x, target.y - height)) < radius) {
      target.y -= height;
    }
    
    return target;
  }
  
  // Get the list of all neighbours of a particular boid. sideCheck is false when the opposite side (as the boids can go from one side to another) hasn't been checked yet.
  ArrayList<Boid> neighbours(PVector pos, float radius, boolean sideCheck) {
    ArrayList<Boid> neighbours = new ArrayList();
    
    for (int j = 0; j < boids.length; j++) {
      if (pos.dist(boids[j].pos) < radius) {
        neighbours.add(boids[j]);
      }
      /*
      if (!sideCheck) {
        if (pos.x > width - radius) {
          neighbours.addAll(neighbours(new PVector(pos.x - width, pos.y), radius, true));
        }
        else if (pos.x < radius) {
          neighbours.addAll(neighbours(new PVector(pos.x + width, pos.y), radius, true));
        }
        if (pos.y > height - radius) {
          neighbours.addAll(neighbours(new PVector(pos.x, pos.y - height), radius, true));
        }
        else if (pos.y < radius) {
          neighbours.addAll(neighbours(new PVector(pos.x, pos.y + height), radius, true));
        }
      }
      */
    }
    
    return neighbours;
  }
  
  void update() {
    for (int i = 0; i < boids.length; i++) {
      ArrayList<Boid> neighbours = neighbours(boids[i].pos, boids[i].nRadius, false);

      cohesion(i, neighbours);
      alignment(i, neighbours);
      separation(i, neighbours(boids[i].pos, boids[i].sRadius, false));
      boids[i].update();
    }
  }
  
  void show() {
    for (int i = 0; i < boids.length; i++) {
      boids[i].show(col);
    }
  }
}