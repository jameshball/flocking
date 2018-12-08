import controlP5.*;
import java.util.Arrays;
import java.util.List;
import java.util.Collections;

ControlP5 cp5;
Species s;

// Approximate width and height.
float w = 2000;
float h = 1000;

// These define the strength of the flock's three behaviours.
float separationWeight = 300;
float alignmentWeight = 0.1;
float cohesionWeight = 0.1;

// These define how far the boids can see.
float neighbourRadius = 130;
float separationRadius = 30;
float maxRadius = max(neighbourRadius, separationRadius);

void settings() {
  // This just makes the width and height a multiple of the neighbourRadius.
  size((int)((int)(w/(float)maxRadius)*maxRadius), (int)((int)(h/(float)maxRadius)*maxRadius), P2D);
}

void setup() {
  frameRate(1000);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("separationWeight").setPosition(20, 20).setRange(0, 2000);
  cp5.addSlider("alignmentWeight").setPosition(20, 50).setRange(0, 2);
  cp5.addSlider("cohesionWeight").setPosition(20, 80).setRange(0, 0.5);
  cp5.addSlider("neighbourRadius").setPosition(20, 110).setRange(1, 500);
  cp5.addSlider("separationRadius").setPosition(20, 140).setRange(1, 300);
  
  s = new Species(2, 1000);
  s.flocks[0].boids[0].size = 5;
}

void draw() {
  background(41);
  s.update();
  s.show();
  s.flocks[0].boids[0].show(color(255));
  
  text(frameRate, 20, 170);
  text(width + "x" + height, 20, 200);
}
