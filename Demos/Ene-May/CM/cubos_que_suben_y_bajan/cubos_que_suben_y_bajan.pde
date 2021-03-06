
import SimpleOpenNI.*;
SimpleOpenNI kinect;

int[][] pos = new int [7][2];    //{x,y}
PVector position = new PVector();
PVector jointPos = new PVector(0,0,0);
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;

void setup(){
  size(640,480,P3D);
  background(0);
  reScale = (float) width / kinectWidth;

  for( int u=0; u<7; u++){
    pos[u][0] = u*width/7;
    pos[u][1] = 0;
  }
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
}

void draw(){
  
  kinect.update();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();

  fill(0);
  rect(0,0,width,height);
  stroke(255);
  line(width/7,0,width/7,height);
  line(2*width/7,0,2*width/7,height);
  line(3*width/7,0,3*width/7,height);
  line(4*width/7,0,4*width/7,height);
  line(5*width/7,0,5*width/7,height);
  line(6*width/7,0,6*width/7,height);
  
  for (int i=0; i<userList.length; i++){
    int userId = userList[i]; //getting user data
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position);
      
    jointPos.x = position.x*reScale;
    jointPos.y = position.y*reScale;
    
    for( int u=0; u<7; u++){
      int min = u * width/7;
      int max = (u+1) * width/7;
      
         if(jointPos.x<max && jointPos.x>min){
           if(pos[u][1]>-1){
             pos[u][1]--;
           }
         }
         else{
           if(pos[u][1] < height-width/7){
           pos[u][1]++;
           }
         }
    }
    
  }
  
  for( int u=0; u<7; u++){
     drawSquare(pos[u][0],pos[u][1],width/7,width/7);
  }
}

void drawSquare (int x, int y, int w, int h){
  int [] square = new int [4];
  for(int z=0; z<20; z++){
    square[0] = x;
    square[1] = y + (h/2) - (z*h/20);
    square[2] = x+w;
    square[3] = y + (h/2);
    fill(255,255,255,15);
    noStroke();
    rectMode(CORNERS);
    rect(square[0],square[1],square[2],square[3]);
    square[0] = x;
    square[1] = y + (h/2);
    square[2] = x+w;
    square[3] = y + (h/2) + (z*h/20);
    fill(255,255,255,15);
    noStroke();
    rectMode(CORNERS);
    rect(square[0],square[1],square[2],square[3]);
  }
}
