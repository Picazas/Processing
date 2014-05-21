//Se dibuja la silueta y círculos por el escenario y por donde pasa la silueta los círculos
//empiezan a abrirse y cerrarse.

import blobDetection.*;
BlobDetection theBlobDetection;
import java.awt.Polygon;
import java.util.Collections;
import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

//Movimiento
int[] array1 = new int [307200];
int[] array2 = new int [307200];
float[] movement;
int num = 0;

//Programa principal
float[] circleSize;
float[] circleX;
float[] circleY;
float[] actMove;
float[] count;
int maxCircle = 10;
int total = 0;
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int maxValue = 2500;
float reScale;
PImage cam, blobs;

int z=0;

void setup(){
  size(900,700,OPENGL);
  background(0);
  int x = int(width/10);
  int y = int(height/10);
  int num = 0;
  total = x * y;
  circleSize = new float[total];
  circleX = new float[total];
  circleY = new float[total];
  actMove = new float[total];
  count = new float[total];
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  
  //Movimiento
  movement = new float[total];
  for(int o=0; o<307200; o++){
    array1[o] = 0;
    array2[o] = 0;
  }
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
  for(int r=0; r<total; r++){
    circleSize[r] = 0;
    actMove[r] = 0;
    count[r] = 0;
    movement[r] = 1;
  }
  
  for(int i = 0; i <= width; i += 20) {
      for(int j = 0; j <= height; j += 20) {
        num++;
        circleX[num] = i;
        circleY[num] = j;
      }
    }
  
}

void draw(){
  background(255);
  kinect.update();  
  int[] userMap = kinect.userMap();
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  
  cam.loadPixels(); 
  for (int z=0; z<userList.length; z++){
    for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         clickedDepth = depthValues[clickPosition];    //See the pixel's value 
         if (clickedDepth > 455 && maxValue > clickedDepth) {
             array2 [clickPosition] = 1;
             cam.pixels[clickPosition] = color(255);
           }
           else {
             cam.pixels[clickPosition] = color(0);
             array2 [clickPosition] = 0;
           }
         }
      }     
  }  
  cam.updatePixels();
  
  for(int r=0; r<307200; r++){
    if(array1[r] != array2[r]){
      num++;
    }
  }
  
  theBlobDetection.computeBlobs(cam.pixels);
  circleUpdateActMove();
  circleUpdate();
  drawCircle();  
  
  for(int r=0; r<307200; r++){
    array1[r] = array2[r];
  }
  num = 0;
}

public void circleUpdate(){
  println("count: "+count[2]);
  for(int r=0; r<total; r++){
    if(actMove[r] == 1 || actMove[r] == 2){
      if(count[r] < 2*(maxCircle-2)){
        count[r]++;
        if(count[r] < maxCircle-2){
          circleSize[r] += movement[r];
        }
        else{
          circleSize[r] -= movement[r];
        }
      }
      else{
        count[r] = 0;
        actMove[r]++;
      }
    }
    else if (actMove[r] == 3){
      actMove[r] = 0;
      circleSize[r] = 0;
      movement[r] = 1;
    }
  }
}

public void circleUpdateActMove(){
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      
        strokeWeight(1);
        stroke(0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
            
            for(int x=0; x<total; x++){ 
              if(eA.x*width-3 < circleX[x] && circleX[x] < eA.x*width+3 && circleY[x] > eA.y*height-3 && circleY[x] < eA.y*height+3){
                actMove[x] = 1;
                movement[x] = num/15000;
              }
              else if(eB.x*width-3 < circleX[x] && circleX[x] < eB.x*width+3 && circleY[x] > eB.y*height-3 && circleY[x] < eB.y*height+3){
                actMove[x] = 1;
                movement[x] = num/15000;
              }
            }            
        }
    }
  }
}

public void drawCircle(){
  int num = 0;
  for(int i = 0; i <= width; i += 20) {
      for(int j = 0; j <= height; j += 20) {
        num++;
        ellipse(i, j, circleSize[num], circleSize[num]);
      }
    }
}
