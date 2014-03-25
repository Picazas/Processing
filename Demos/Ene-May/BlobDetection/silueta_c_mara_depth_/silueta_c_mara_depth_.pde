
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import blobDetection.*;
BlobDetection theBlobDetection;

int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int maxValue = 2500;
float reScale;
PGraphics img;
PImage cam;

void setup(){
  size(1000,700,P3D);
  background(255);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
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
         clickedDepth = depthValues[clickPosition];
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (clickedDepth > 455 && maxValue > clickedDepth) {
             cam.pixels[clickPosition] = color(255);
           }
           else cam.pixels[clickPosition] = color(0);
         }
      }
      
  }
  
  cam.updatePixels();  
  theBlobDetection.computeBlobs(cam.pixels);
  drawBlobsAndEdges(false, true);
  /*translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam,0,0);*/
  
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
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
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
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
