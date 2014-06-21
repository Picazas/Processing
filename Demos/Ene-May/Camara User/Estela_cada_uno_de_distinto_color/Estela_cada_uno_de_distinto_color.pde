//Con el movimiento se va dejando una estela de un color por donde se pasa, cada usuario
//generará una estela de un color diferente al resto.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int t=0;
int cuenta=0;
PVector jointPos = new PVector();
int[] pixel = new int[307200];
int[][] min = new int[6][2];    //{person}{x,y}
int[][] max = new int[6][2];
int kinectWidth = 640;
int kinectHeight = 480;
// to center and rescale from 640x480 to higher custom resolutions
float reScale;

void setup(){
  
  size (1024,768);
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
  
  for(int r=0; r<307200; r++){ pixel[r] = 0;}
  
}

void draw(){
  kinect.update();
  
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  PImage cam = createImage(640,480,RGB);
  
  fill(0,0,0,35);
  rect(0,0,width,height);
  
  if (kinect.getNumberOfUsers() > 0) { 
    cam.loadPixels(); 
    for(int z = 0; z < userList.length; z++) { 
        for (int x = 0; x < width; x++) {
          for( int y=0; y<height; y++){         
            i = x + x*y; 
            for(int w=0; w<6; w++){   
              if (min[w][0]<x && max[w][0]>x && userMap[i] != 0 && pixel[i] == 0) {
                switch(w){
                  case 0:
                    cam.pixels[i] = color(0, 255, 0);
                    pixel[i] = 1;
                    break;
                  case 1:
                    cam.pixels[i] = color(255, 0, 0);
                    pixel[i] = 1;
                    break;
                  case 2:
                    cam.pixels[i] = color(0, 0, 255);
                    pixel[i] = 1;
                    break;
                  case 3:
                    cam.pixels[i] = color(255, 255, 255);
                    pixel[i] = 1;
                    break;
                  case 4:
                    cam.pixels[i] = color(255, 255, 0);
                    pixel[i] = 1;
                    break;
                  case 5:
                    cam.pixels[i] = color(0, 255, 255);
                    pixel[i] = 1;
                    break;
                  default:
                    cam.pixels[i] = color(255, 0, 255);
                    break;            
                }
              }
            }
          }
        }
        }
    }
   // display the changed pixel array
   cam.updatePixels();
   translate(0, (height-kinectHeight*reScale)/2);
   scale(reScale);
   image(cam,0,0); 
  

  for(int s=0; s<6; s++){
     min[s][0] = width;
     min[s][1] = height;
     max[s][0] = 0;
     max[s][1] = 0;
  }
  for(int r=0; r<307200; r++){ pixel[r] = 0;}
}

