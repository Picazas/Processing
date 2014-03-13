
import SimpleOpenNI.*;
SimpleOpenNI kinect;


PVector position = new PVector();
PVector jointPos = new PVector(0,0,0);
int kinectWidth = 640;
int kinectHeight = 480;
int count = 0;
float reScale;

void setup(){
  size(900,600);
  background(255);
  reScale = (float) width / kinectWidth;
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
}

void draw(){
  background(0);
  kinect.update();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  count++;
  println(count);
  
  for(int c=0; c<20; c++){
    woolBall(150,100);
    woolBall(750,100);
  }
  
  for (int i=0; i<userList.size(); i++){
    int userId = userList.get(i); //getting user data
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position);
      
    jointPos.x = position.x*reScale;
    jointPos.y = position.y*reScale;
    
    drawLine(150,100,int(jointPos.x),int(jointPos.y));
    drawLine(750,100,int(jointPos.x),int(jointPos.y));
  }
}

void woolBall(int inix, int iniy){
  int x = int( inix + random(-30,30));
  int y = int( iniy + random(-30,30));
  stroke(255);
  noFill();
  ellipseMode(CENTER);
  ellipse(x,y,random(1,100),random(1,100));
}

void drawLine (int xi,int yi,int xf,int yf){
  int r = xf - xi;
  int q = yf - yi;
  for(int w=0; w<2; w++){
    for(int s=0; s<2; s++){
      if(r<0){
        noFill();
        stroke(255);
        beginShape();
        curveVertex(xf+100+random(-15,15)+50*w+50*s,yf+20+random(-15,15));
        curveVertex(xf,yf);
        curveVertex(xf+random(-15,15)-(r/2)+(r/4)+50*w+50*s,(q/2)+150+random(-15,15));
        curveVertex(xf+random(-15,15)-(r/2)-(r/4)-50*w+50*s,(q/2)+50+random(-15,15));
        curveVertex(xi+random(-15,15),yi+random(-15,15));
        curveVertex(xi+random(-15,15)-20-50*w-50*s,yf-100+random(-15,15));
        endShape();
      }
      else {
        noFill();
        stroke(255);
        beginShape();
        curveVertex(xf+random(-15,15)-100-50*w-50*s,yf+20+random(-15,15));
        curveVertex(xf,yf);
        curveVertex(xi+random(-15,15)+(r/2)+(r/4)-50*w-50*s,(q/2)+150+random(-15,15));
        curveVertex(xi+random(-15,15)+(r/2)-(r/4)-50*w+50*s,(q/2)+50+random(-15,15));    
        curveVertex(xi+random(-15,15),yi+random(-15,15));
        curveVertex(xi+random(-15,15)+20+50*w+50*s,yf-100+random(-15,15));
        endShape();
      }
    }
  }
}
