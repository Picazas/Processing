
import SimpleOpenNI.*;
import processing.opengl.*;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
SimpleOpenNI kinect;
PBox2D box2d;

int XC = 0;
int YC = 0;
float scale = 1;

ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;
ArrayList<Circle> circles;

void setup(){
  
  size(700,500);
  background(0);
  
  staticF();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  
  boundaries = new ArrayList<Boundary>();
  boxes = new ArrayList<Box>();
  circles = new ArrayList<Circle>();
  Vec2 gravity = new Vec2(0,-10);
 
  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  
}

void draw(){
  
  //kinect.update();
  box2d.step();
  
  fill(255);
  rectMode(CENTER);
  rect(XC+25,width/6,20,40);
  
}

void star(){
  fill(200);
  beginShape();
  vertex(width-width/10, -25+11*height/12);
  vertex(7+width-width/10, -10+11*height/12);
  vertex(22.5+width-width/10, -7.5+11*height/12);
  vertex(11.5+width-width/10, 3.5+11*height/12);
  vertex(15.5+width-width/10, 20+11*height/12);
  vertex(width-width/10, 12.5+11*height/12);
  vertex(-15.5+width-width/10, 20+11*height/12);
  vertex(-11.5+width-width/10, 3.5+11*height/12);
  vertex(-23.5+width-width/10, -7.5+11*height/12);
  vertex(-7+width-width/10, -10+11*height/12);
  endShape(CLOSE);
}


