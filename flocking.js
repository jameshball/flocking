let boids = [];
let s;

let separationWeight = 300;
let alignmentWeight = 0.1;
let cohesionWeight = 0.1;

let neighbourRadius = 130;
let separationRadius = 30;

function setup() {
  let maxRadius = max(neighbourRadius, separationRadius);

  createCanvas((displayWidth / maxRadius) * maxRadius, (displayHeight / maxRadius) * maxRadius);

  s = new Species(1, 1000);
}

function draw() {
  background(41);
  s.update();
  s.show();

  //text(int(frameRate()), 20, 170);
  //text(width + "x" + height, 20, 200);
}

// Class used for rendering multiple flocks on ths screen at once.
class Species {
  constructor(n, s) {
    this.flocks = [];
    
    colorMode(HSB, 1.0);
    
    for (let i = 0; i < n; i++) {
      // Generate random hue values, and semi-random brightness values for each flock.
      this.flocks[i] = new Flock(s, color(random(1), random(0.8, 1), random(0.75, 1)));
    }
    
    colorMode(RGB, 255);
  }
  
  update() {
    for (let i = 0; i < this.flocks.length; i++) {
      this.flocks[i].update();
    }
  }

  show() {
    for (let i = 0; i < this.flocks.length; i++) {
      this.flocks[i].show();
    }
  }
}

class Grid {
  constructor(x, y) {
    this.cells = [];
    this.rows = x;
    this.cols = y;
    
    for (let i = 0; i < x; i++ ) {
      this.cells[i] = []; 
    }
    
    for (let i = 0; i < x; i++) {
      for (let j = 0; j < y; j++) {
        this.cells[i][j] = [];
      }
    }
  }
}


// Flock class used to manage multiple boids and draw them all on the screen at once.
class Flock {
  
  // Inputs the size of the flock and the colour.
  constructor(s, colour) {
    this.boids = [];
    this.colour = colour;
    this.colShift = random(0.001, 0.005);
    
    this.grid = new Grid(width/neighbourRadius, height/neighbourRadius);
    
    for (let i = 0; i < s; i++) {
      let boid = new Boid(this.grid.rows, this.grid.cols);
      
      this.boids[i] = boid;
      this.grid.cells[this.boids[i].cell[0]][this.boids[i].cell[1]].push(i);
    }
  }
  
  // Apply the cohesion behavior to a boid, given its neighbours.
  cohesion(i, neighbours) {
    let total = createVector(0, 0);
    let count = 0;
    
    for (let j = 0; j < neighbours.length; j++) {
      if (this.boids[i].pos.dist(this.boids[neighbours[j]].pos) < neighbourRadius) {
        total.add(this.boids[neighbours[j]].pos);
        count++;
      }
    }
    
    // Steer towards the average location of all neighbouring boids.
    this.boids[i].steerTo(total.div(count));
  }
  
  // Apply the alignment behavior to a boid, given its neighbours.
  alignment(i, neighbours) {
    let total = createVector(0, 0);
    let count = 0;
    
    for (let j = 0; j < neighbours.length; j++) {
      if (this.boids[i].pos.dist(this.boids[neighbours[j]].pos) < neighbourRadius) {
        total.add(this.boids[neighbours[j]].vel);
        count++;
      }
    }
    
    total.div(count);
    
    // Apply the average velocity of all neighbouring boids.
    this.boids[i].vel.add(total.mult(alignmentWeight));
  }
  
  // Apply the separation behavior to a boid, given its neighbours.
  separation(i, neighbours) {
    let total = createVector(0, 0);
    let count = 0;
    
    for (let j = 0; j < neighbours.length; j++) {
      if (this.boids[i].pos.dist(this.boids[neighbours[j]].pos) < separationRadius) {
        // Temporary variables
        let iPos = this.boids[i].pos.copy();
        let jPos = this.boids[neighbours[j]].pos.copy();
        
        // This adds a vector that points in the opposite direction of the other vector that is inversely proportional to its distance to boid i.
        total.add(iPos.sub(jPos).normalize().div(iPos.dist(jPos)));
        count++;
      }
    }
    
    // Apply the average separation velocity of all neighbouring boids.
    this.boids[i].vel.add(total.div(count).mult(separationWeight));
  }
  
  // Get the list of all potential neighbours of a particular boid.
  neighbours(i) {
    // This doesn't even do anything in particular. I don't know why this works.
    let cell = [this.boids[i].cell[0] - 1, this.boids[i].cell[1] - 1];
    
    let n = [];
    
    // Using r, c here as i is already being used.
    // If r and c are changed to different numbers, there are different behaviours. I don't know how this works...
    for (let r = 0; r < 3; r++) {
      for (let c = 0; c < 3; c++) {
        let append = this.grid.cells[int((this.grid.rows + cell[0] + r) % this.grid.rows)][int((this.grid.cols + cell[1] + c) % this.grid.cols)]
        
        n = n.concat(append);
      }
    }
    
    return n;
  }
  
  // Update creates a new thread which applies the flocking bechaviours to each boid.
  // Threading (even just one thread per frame) improves performance significantly.
  update() {
    for (let i = 0; i < this.boids.length; i++) {
      let neighbours = this.neighbours(i).slice();
    
      this.cohesion(i, neighbours);
      this.alignment(i, neighbours);
      this.separation(i, neighbours);
      this.boids[i].update();
    }
  }
  
  show() {
    colorMode(HSB, 1.0);
    
    let newHue = hue(this.colour) + this.colShift;
    
    if (newHue > 1) {
      newHue = 0;
    }
    
    this.colour = color(newHue, saturation(this.colour), brightness(this.colour));
    for (let i = 0; i < this.boids.length; i++) {
      this.boids[i].show(this.colour);
    }
    
    colorMode(RGB, 255);
  }
}

class Boid {
  constructor(x, y) {
    this.vel = createVector(random(-1, 1), random(-1, 1));
    this.pos = createVector(random(width), random(height));
    this.size = 3;
    this.maxSpeed = random(1, 3);
    this.cell = [int(random(x)), int(random(y))];
  }
  
  // d is the desired target to steer towards.
  steerTo(d) {
    // Calculate the vector that points to the target.
    d.sub(this.pos);
    let dist = d.mag();
    
    if (dist > 0) {
      // Normalise and scale the vector based on the distance to the target.
      d.normalize().mult(this.maxSpeed);
      this.vel.add(d.sub(this.vel).limit(cohesionWeight));
    }
  }
  
  update() {
    //steerTo(new PVector(mouseX, mouseY));
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
    this.pos.x = (this.pos.x + width) % width;
    this.pos.y = (this.pos.y + height) % height;
  }
  
  show(c) {
    fill(c);
    // Translates the canvas to the position of the boid and then draws a triangle that is rotated according to the direction the boid is facing in.
    push();
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading() + PI/2);
    triangle(0, -2*this.size, -this.size, 2*this.size, this.size, 2*this.size);
    pop();
  }
}