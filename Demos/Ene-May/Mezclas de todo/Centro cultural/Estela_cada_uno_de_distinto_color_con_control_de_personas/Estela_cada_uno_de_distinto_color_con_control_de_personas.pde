//Con el movimiento se va dejando una estela de un color por donde se pasa, cada usuario
//generará una estela de un color diferente al resto.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int t=0;
int s=0;
int cuenta=0;
int[] act = new int[8];
PVector jointPos = new PVector();
int kinectWidth = 640;
int kinectHeight = 480;
// to center and rescale from 640x480 to higher custom resolutions
float reScale;

void setup(){
  size (600,450);
  kinect= new SimpleOpenNI(this);
  background(0);
  reScale = (float) width / kinectWidth;
  
  if (kinect.isInit()==false){
   println("Nada de nada chato");
   exit();
   return; 
  }
  
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
}

void draw(){
  kinect.update();
  
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  PImage cam = createImage(640,480,RGB);
  
  fill(0,0,0,35);
  rect(0,0,width,height);
  s = 0;
  for(int u=0; u<8; u++){ act[u]=0; }
  int g = kinect.getNumberOfUsers();
  
  
  if (kinect.getNumberOfUsers() > 0) { 
    cam.loadPixels(); 
    for(int z = 0; z < userList.length; z++) { 
        for (int i = 0; i < userMap.length; i++) { 
          if (userMap[i] != 0) {
            if(act[z]==0){s++; act[z]=1;}            
            switch(z){
              case 0:
                cam.pixels[i] = color(0, 255, 0);
                break;
              case 1:
                cam.pixels[i] = color(255, 0, 0);
                break;
              case 2:
                cam.pixels[i] = color(0, 0, 255);
                break;
              case 3:
                cam.pixels[i] = color(255, 255, 255);
                break;
              case 4:
                cam.pixels[i] = color(255, 255, 0);
                break;
              case 5:
                cam.pixels[i] = color(0, 255, 255);
                break;
              default:
                cam.pixels[i] = color(255, 0, 255);
                break;            
            }
          }
        }
    }
   // display the changed pixel array
   cam.updatePixels();
   translate(0, (height-kinectHeight*reScale)/2);
   scale(reScale);
   image(cam,0,0); 
   
   println(g + " ; " + s);
  }
  
  
 for(int i=0;i<userList.length;i++)
 {
  kinect.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_LEFT_HAND,jointPos);
}
}

