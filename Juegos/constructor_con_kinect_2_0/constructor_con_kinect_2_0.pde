
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
int redCircleNum = 0;
int outCircle = 1;
int moment = 0;  //0: select the shape and the size of this; 1: move the shape;
int kinectWidth = 640;
int kinectHeight = 480;
int LH = 0;
int RH = 0;
float reScale;
float scale = 1;
float squareX = 25;
Vec2 posLH = new Vec2(0,0);
Vec2 posRH = new Vec2(0,0);
Vec2 jointPos = new Vec2(0,0);
Vec2 posShape = new Vec2(0,0);
/*PVector posLH = new PVector(0,0,0);
PVector posRH = new PVector(350,250,0);
PVector jointPos = new PVector(0,0,0);
PVector posShape;*/

ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;
ArrayList<Circle> circles;
ArrayList<Triangle> triangles;
ArrayList<Star> stars;

void setup(){
  
  size(700,500);
  background(0);
  
  posShape.x = width/2;
  posShape.y = height/2;
  reScale = (float) width / kinectWidth;
  
  staticSquares();
  staticShapes();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  
  boundaries = new ArrayList<Boundary>();
  boxes = new ArrayList<Box>();
  circles = new ArrayList<Circle>();
  stars = new ArrayList<Star>();
  triangles = new ArrayList<Triangle>();
 
  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
 // kinect.setMirror(true);
  
}

void draw(){
  
  background(0);
  kinect.update();
  box2d.step();
  println("Moment:"+moment);
  println("redCircle:"+redCircleNum);
  println("outCircle:"+outCircle);
  
  int[] userList = kinect.getUsers();
  int[] userMap = kinect.userMap();
  PImage cam = createImage(640,480,RGB);
  
  
  for(int i=0;i<userList.length;i++){
    int userId = userList [i];
    
    PVector jointPos2 = new PVector(0,0,0);
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos2);
    jointPos.x = jointPos2.x/2 + width/2;
    jointPos.y = jointPos2.y*(-1)/2 + height/2;
    println("RH:"+jointPos);
    posRH.x = jointPos.x * reScale;
    posRH.y = jointPos.y * reScale;
    
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPos2);
    jointPos.x = jointPos2.x/2 + width/2;
    jointPos.y = jointPos2.y*(-1)/2 + height/2;
    println("LH:"+jointPos);
    posLH.x = jointPos.x * reScale;
    posLH.y = jointPos.y * reScale;
  }
  
  for (Box b: boxes){
    b.display();
  }
  for (Circle b: circles){
    b.display();
  }
  for (Star b: stars){
    b.display();
  }
  for (Triangle b: triangles){
    b.display();
  }
  
  moment();
    PVector posLH2 = new PVector(0,0,0);
    PVector posRH2 = new PVector(0,0,0);
    posLH2.x = posLH.x;
    posLH2.y = posLH.y;
    posRH2.x = posRH.x;
    posRH2.y = posRH.y;
  if(moment==0) {
    posShape.x = width/2;
    posShape.y = height/2;
    scaleSquare();
    scale = 1 + squareX/300;
    botones(posLH2,posRH2);
  }
  else if(moment ==1){
    MovShape(posLH2, posRH2);
  }
  
  staticSquares();
  whiteSquares();
  drawShape();
  redCircle();
  
  fill(255);
  rectMode(CENTER);
  rect(squareX,width/6,20,40);
    
  fill(255,0,0);
  ellipse(posLH.x,posLH.y,15,15);
  ellipse(posRH.x,posRH.y,15,15);
  
}

void reset(){
  actShape = 0;
  moment = 0;
  movCircle = 0;
  shape = 0;
  actShape = 0;
  actMovShape = 0;
  redCircleNum = 0;
  outCircle = 1;
  moment = 0;  //0: select the shape and the size of this; 1: move the shape;
  scale = 1;
  squareX = 25;
  posShape.x = width/2;
  posShape.y = height/2;
  LH = 0;
  RH = 0;
}

void MovShape(PVector pLH, PVector pRH){
  if(pLH.x < (width/2)+20 && pLH.x > (width/2)-20 && pLH.y < (height/2)+20 && pLH.y > (height/2)-20){
    actMovShape = 1;
    LH = 1;
    RH = 0;
  }
  else if(pRH.x < (width/2)+20 && pRH.x > (width/2)-20 && pRH.y < (height/2)+20 && pRH.y > (height/2)-20){
    actMovShape = 1;
    LH = 0;
    RH = 1;
  }
  if(actMovShape == 1){
    if(LH == 1){
      posShape.x = posLH.x;
      posShape.y = posLH.y;
    }
    else if( RH == 1){
      posShape.x = posRH.x;
      posShape.y = posRH.y;
    }     
  }
}

void moment(){
  if(shape != 0 && moment == 0 && redCircleNum == 1){ moment = 1; }
  else if(actShape == 1 && moment == 1 && posShape.x != width/2 && posShape.y != height/2 && redCircleNum == 1){ 
    switch(shape){
      case 1:
        Box B1 = new Box(posShape.x, posShape.y, 75*scale, 50*scale);
        boxes.add(B1);
        break;
      case 2:
        Box B2 = new Box(posShape.x, posShape.y, 50*scale, 75*scale);
        boxes.add(B2);
        break;
      case 3:
        Box B3 = new Box(posShape.x, posShape.y, 50*scale, 50*scale);
        boxes.add(B3);
        break;
      case 4:
        Circle C = new Circle(posShape.x, posShape.y, 25*scale);
        circles.add(C);
        break;
      case 5:
        Triangle T = new Triangle(posShape.x, posShape.y, scale);
        triangles.add(T);
        break;
      case 6:
        Star S = new Star(posShape.x, posShape.y);
        stars.add(S);
        break;
    }
    reset();
  }
}

void redCircle(){
  if(posLH.x > 400 && posLH.x < 500){
    if(posLH.y > 50 && posLH.y < 155 && redCircleNum == 0 && outCircle == 1){
      outCircle = 0;
      redCircleNum = 1;
    }
  }
  else if(posRH.x > 400 && posRH.x < 500){
    if(posRH.y > 50 && posRH.y < 155 && redCircleNum == 0 && outCircle == 1){
      outCircle = 0;
      redCircleNum = 1;
    }
  }
  else if(redCircleNum == 1 && outCircle == 0){
        outCircle = 1;
        redCircleNum = 0;
        actShape = 1;
  }
}

void scaleSquare(){
  if(posLH.x > 15 && posLH.x < 375){
    if(posLH.y > 95 && posLH.y < 135){
      squareX = posLH.x;
    }
  }
  else if(posRH.x > 15 && posRH.x < 375){
    if(posRH.y > 95 && posRH.y < 135){
      squareX = posRH.x;
    }
  }
  if( squareX < 25) squareX = 25;
}


void drawShape(){
  if (shape > 6) shape = 0;
  if (shape != 0){
    pushMatrix();
    switch (shape){
      case 1:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(255);
        rect(0,0,75,50);
        break;
      case 2:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(255);
        rect(0,0,50,75);
        break;
      case 3:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(255);
        rect(0,0,50,50);
        break;
      case 4:
        translate(posShape.x, posShape.y);
        scale(scale);
        fill(255);
        ellipse(0,0,50,50);
        break;
      case 5:
        translate(posShape.x, posShape.y);
        scale(scale*20);
        fill(255);
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

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


