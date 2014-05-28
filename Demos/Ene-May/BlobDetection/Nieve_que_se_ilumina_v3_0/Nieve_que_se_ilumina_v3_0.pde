//Se diguja la silueta en blanco sobre un fondo negro y van cayendo copos de nieve, los 
//cuales al tocar dicha silueta se "desaparecen" y generan una luz.

import blobDetection.*;
BlobDetection theBlobDetection;
import java.awt.Polygon;
import java.util.Collections;
import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

int[] nieveSueloX = new int[6]; 
int[] nieveSueloY = new int[6];
float[][] copos;
float[][] lights;    //{width,height}
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int num;
int maxValue = 2500;
float reScale;
float maxCount = 8;
float lado = 10;
int[] count;
int[] act;
int[] actL;
PImage cam, blobs;

void setup(){
  size(1000,650,OPENGL);
  background(0);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
  num = width/2;
  copos = new float[num][2];
  lights = new float[num][2];
  count = new int[num];
  act = new int[num];
  actL = new int[num];
 
  for(int x=0; x<num; x++){
      lights[x][0] = 4;
      lights[x][1] = 1;
      copos[x][0] = 2*x;
      copos[x][1] = random(-height,-5);
      act[x] = 1;
      actL[x] = 0;
  }
}

void draw(){
  background(0);
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
             cam.pixels[clickPosition] = color(255);
           }
           else cam.pixels[clickPosition] = color(0);
         }
      }     
  }  
  cam.updatePixels();
  
  //blobs.copy(cam, 0, 0, cam.width, cam.height, 0, 0, blobs.width, blobs.height);
  //blobs.filter(BLUR, 1);
  theBlobDetection.computeBlobs(cam.pixels);
  drawBlobsAndEdges(false, true);

  for(int x=0; x<num; x++){  

    if(act[x]==0 && actL[x]==0){
      lights[x][0] = 4;
      lights[x][1] = 1;
      copos[x][1] = random(-height,-5);
      count[x] = 0;
      act[x] = 1;
      actL[x] = 0;
    }
    
    if(act[x] == 1){
      drawSnow(copos[x][0],copos[x][1]);
      copos[x][1] += (copos[x][1]+400)/150;
    }
    
    if(actL[x] == 1){
      fill(255);
      ellipseMode(CENTER);
      ellipse(copos[x][0],copos[x][1],lights[x][0],lights[x][1]);
      lights[x][0]++;
      lights[x][1]++;
      count[x]++;
    }
    
    if(copos[x][1] > (height + 10)){
      act[x] = 0;
      actL[x] = 1;
    }

    if(count[x] > maxCount){
      actL[x] = 0;
    }
    
  }
}

void drawSnow(float x,float y){
  
   noFill();
   stroke(255);
   line(x,y-lado/2,x,y+lado/2); 
   line(x,y-lado/3,x+lado/6,y-lado/2); 
   line(x,y-lado/3,x-lado/6,y-lado/2);  
   line(x,y+lado/3,x+lado/6,y+lado/2); 
   line(x,y+lado/3,x-lado/6,y+lado/2);
   line(x-lado/2,y,x+lado/2,y);
   line(x-lado/3,y,x-lado/2,y+lado/6); 
   line(x-lado/3,y,x-lado/2,y-lado/6);  
   line(x+lado/3,y,x+lado/2,y-lado/6); 
   line(x+lado/3,y,x+lado/2,y+lado/6);
   pushMatrix();
   noFill();
   stroke(255);
   translate(x,y,0);
   rotateZ(radians(45));
   line(0,-lado/2,0,lado/2);
   line(0,-lado/3,lado/6,-lado/2); 
   line(0,-lado/3,-lado/6,-lado/2);  
   line(0,lado/3,lado/6,lado/2); 
   line(0,lado/3,-lado/6,lado/2);
   rotateZ(radians(90));
   line(0,-lado/2,0,lado/2);
   line(0,-lado/2,0,lado/2);
   line(0,-lado/3,lado/6,-lado/2); 
   line(0,-lado/3,-lado/6,-lado/2);  
   line(0,lado/3,lado/6,lado/2); 
   line(0,lado/3,-lado/6,lado/2);
   popMatrix();
   
}

public void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(1);
        stroke(255);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
            
            for(int x=0; x<num; x++){ 
              if(eA.x*width-(lado) < copos[x][0] && copos[x][0] < eA.x*width+(lado) && copos[x][1] > eA.y*height-(lado) && copos[x][1] < eA.y*height+(lado) && count[x] < maxCount){
                act[x] = 0;
                actL[x] = 1;
              }
              else if(eB.x*width-(lado) < copos[x][0] && copos[x][0] < eB.x*width+(lado) && copos[x][1] > eB.y*height-(lado) && copos[x][1] < eB.y*height+(lado) && count[x] < maxCount){
                act[x] = 0;
                actL[x] = 1;
              }
            }
            
        }
      }
    }
  }
}

void keyPressed(){
  
  println("MaxValue: " + maxValue);
  switch(key)
  {
  case 'q':
    maxValue+=100;
    break;
  case 'a':
    maxValue-=100;
    break;
  }  
}
