
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;
PBox2D box2d;

PVector position = new PVector();
int[][] now = new int[7][2];
int[][] before = new int[7][2];
int[][] min = new int[6][2];    //{person}{x,y}
int[][] max = new int[6][2];
ArrayList<Boundary> boundaries;
ArrayList<Particle> particles;
int [] pixel;
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int allParticles = 350;
float reScale;

void setup() {
  size(900,550);
  smooth();
  reScale = (float) width / kinectWidth;
  pixel = new int[width*height];
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);

  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  particles = new ArrayList<Particle>();
  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  
  for(int s=0; s<6; s++){
     min[s][0] = width;
     min[s][1] = height;
     max[s][0] = 0;
     max[s][1] = 0;
  }
  
  for(int r=0; r<allParticles; r++){
    Particle p = new Particle(random(width),random(height),2);
    particles.add(p);
  }
  
  for(int q=0; q<pixel.length; q++){
    pixel[q] = 0;
  }
  
  for(int u=0; u<4; u++){
    before[u][0] =0;
    before[u][1] = 0;
    now[u][0] = 0;
    now[u][1] = 0;
  }
  
}

void draw() {
  background(255);
  box2d.step();
  kinect.update();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  int total = 0;
  
  for(int s=0; s<6; s++){
     min[s][0] = width;
     min[s][1] = height;
     max[s][0] = 0;
     max[s][1] = 0;
  }
  
  for (int z=0; z<userList.length; z++){
    
    int userId = userList[z]; //getting user data
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position);
      
    now[z][0] = int(position.x*reScale);
    now[z][1] = int(position.y*reScale);
    
    for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {
           pixel[clickPosition] = 1;
           if(w < min[z][0]){
               min[z][0] = w;
             }
             if(w > max[z][0]){
               max[z][0] = w;
             }
             if(h < min[z][1]){
               min[z][1] = h;
             }
             if(h > max[z][1]+5){
               max[z][1] = h;
             }
         }
       }
    }
  }
  int aty=userList.length;
  println("USERLIST: "+aty);
  println("TOTAL: "+total);
  float d = max[0][0]-min[0][0];
  float n = max[0][1]-min[0][1];
  println("B-N: "+d+" ; "+n);
  if (d<400) {
    int count=0;
    int s=0;
    for(int user=0; user<7; user++){
      if (now[user][0]!=0 && now[user][1]!=0){
        total++;
      }      
    }
    for (Particle b: particles) {
      switch(total){
        case 1:
          for(int user=0; user<7; user++){
            if (now[user][0]!=0 && now[user][1]!=0){
              b.attract(now[user][0],now[user][1]);
            }      
          }
          break;
        case 2:
          s = int(allParticles/2);
          if(count<s){
            b.attract(now[2][0],now[2][1]);
          }
          else{
            b.attract(now[1][0],now[1][1]);
          }
          break;
        case 3:
          s = int(allParticles/3);
          if(count<s){
            b.attract(now[3][0],now[3][1]);
          }
          else if(count<2*s){
            b.attract(now[1][0],now[1][1]);
          }
          else{
            b.attract(now[2][0],now[2][1]);
          }
          break;
        case 4:
          s = int(allParticles/4);
          if(count<s){
            b.attract(now[4][0],now[4][1]);
          }
          else if(count<2*s){
            b.attract(now[1][0],now[1][1]);
          }
          else if(count<3*s){
            b.attract(now[2][0],now[2][1]);
          }
          else{
            b.attract(now[3][0],now[3][1]);
          }
          break;
      }     
      count++;
    }
  }
  else{
    int r = 0;
    for (Particle b: particles) {
        r++;
        int x = int(r/65);
        switch(x){
          case 0:
            b.moveAway(random(0,width),0);
            break;
          case 1:
            b.moveAway(random(0,width),height);
            break;
          case 2:
            b.moveAway(0,random(0,height));
            break;
          case 3:
            b.moveAway(width,random(0,height));
            break;
        }
    }
  }

  for (Boundary wall: boundaries) {
    wall.display();
  }

  for (Particle b: particles) {
    b.display();
  }

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle b = particles.get(i);
    if (b.done()) {
      particles.remove(i);
    }
  }
  for(int u=0; u<4; u++){
    before[u][0] = now[u][1];
    before[u][0] = now[u][1];
  }
  for(int q=0; q<pixel.length; q++){
    pixel[q] = 0;
  }
  
}




