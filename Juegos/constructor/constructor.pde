
import SimpleOpenNI.*;
import processing.opengl.*;
import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
SimpleOpenNI kinect;
PBox2D box2d;

int a;
int movCircle = 0;
int shape = 0;
int actShape = 0;
int actMovShape = 0;
int moment = 0;  //0: select the shape and the size of this; 1: move the shape;
float scale = 1;
float squareX = 25;
PVector pos = new PVector(0,0,0);
PVector posShape;

ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;
ArrayList<Circle> circles;
ArrayList<Triangle> triangles;
ArrayList<Star> stars;

void setup(){
  
  size(700,500);
  background(0);
  
  posShape = new PVector(width/2,height/2,0);
  
  staticSquares();
  staticShapes();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  
  boundaries = new ArrayList<Boundary>();
  boxes = new ArrayList<Box>();
  circles = new ArrayList<Circle>();
  stars = new ArrayList<Star>();
  triangles = new ArrayList<Triangle>();
  Vec2 gravity = new Vec2(0,-10);
 
  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  
}

void draw(){
  
  background(0);
  //kinect.update();
  box2d.step();
  pos.x = mouseX;
  pos.y = mouseY;
  println("X:"+pos.x);
  println("Y:"+pos.y);
  
  int num = redCircle();
  scaleSquare();
  scale = 1 + squareX/300;
  
  staticSquares();
  if (moment == 0) botones(pos);
  whiteSquares();
  drawShape();
  
  fill(255);
  rectMode(CENTER);
  rect(squareX,width/6,20,40);
  
}

void scaleSquare(){
  if(pos.x > 15 && pos.x < 375){
    if(pos.y > 95 && pos.y < 135){
      squareX = pos.x;
    }
  }
  if( squareX < 25) squareX = 25;
}

int redCircle(){
  if(pos.x > 400 && pos.x < 500){
    if(pos.y > 50 && pos.y < 155){
      a = 1;
    }
    else a = 0;
  }
  else a = 0;
  return a;
}

void drawShape(){
  if (shape > 6) shape = 0;
  if (shape != 0){
    pushMatrix();
    switch (shape){
      case 1:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(175);
        rect(0,0,75,50);
        break;
      case 2:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(175);
        rect(0,0,50,75);
        break;
      case 3:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(175);
        rect(0,0,50,50);
        break;
      case 4:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(175);
        ellipse(0,0,50,50);
        break;
      case 5:
        translate(posShape.x, posShape.y);
        scale(scale*20);
        fill(175);
        stroke(175);
        triangle(-1,0,1,0,0,-1.73);
        break;
      case 6:
        fill(255);
        star(posShape.x, posShape.y, scale);
        break;
    }
    popMatrix();
  }
}

void star(float x, float y, float scaleStar){
  pushMatrix();
  fill(175);
  beginShape();
  translate(x,y);
  scale(scaleStar+1);
  vertex(0, -25);
  vertex(7, -10);
  vertex(22.5, -7.5);
  vertex(11.5, 3.5);
  vertex(15.5, 20);
  vertex(0, 12.5);
  vertex(-15.5, 20);
  vertex(-11.5, 3.5);
  vertex(-23.5, -7.5);
  vertex(-7, -10);
  endShape(CLOSE);
  popMatrix();
}


