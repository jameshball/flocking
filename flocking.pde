import controlP5.*;
import java.util.Arrays;

ControlP5 cp5;
Species s;

float separationWeight = 425;
float alignmentWeight = 0.1;
// This defines how strongly the boid steers towards a target
float cohesionWeight = 0.1;
// neighbour radius (specifies the radius at which the boid can see)
float neighbourRadius = 40;
// separation radius
float separationRadius = 25;

void setup() {
  size(2000, 1000, P2D);
  frameRate(1000);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("separationWeight").setPosition(20, 20).setRange(0, 2000);
  cp5.addSlider("alignmentWeight").setPosition(20, 50).setRange(0, 2);
  cp5.addSlider("cohesionWeight").setPosition(20, 80).setRange(0, 0.5);
  cp5.addSlider("neighbourRadius").setPosition(20, 110).setRange(1, 500);
  cp5.addSlider("separationRadius").setPosition(20, 140).setRange(1, 300);
  
  s = new Species(2, 1250);
}

void draw() {
  background(41);
  s.update();
  s.show();
  
  text(frameRate, 20, 170);
}
