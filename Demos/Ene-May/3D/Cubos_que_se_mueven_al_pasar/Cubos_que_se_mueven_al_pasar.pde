
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import blobDetection.*;
BlobDetection theBlobDetection;

int X;
int Y;
int s = 0;
int q;
int c;
int lado = 50;
int clickPosition=0;
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;
int[] a;
int[] act;
PImage cam;

void setup (){
  size(900,650,P3D);
  background(0);
  cam = createImage(640,480,RGB); 
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
  reScale = (float) width / kinectWidth;  
  X = int(width/100)+1;
  Y = int(height/100)+1;
  c = X*Y;
  a = new int[c];
  act = new int[c];
  
  for(int r=0; r<c; r++){
    a[r]=0;
    act[r]=0;
  }
}

void draw(){
  
  background(0);
  s = 0;
  q = 0;
  
  kinect.update();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  
  if (kinect.getNumberOfUsers() > 0) {   
    for (int z=0; z<userList.length; z++){  
      for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {
           cam.pixels[clickPosition] = color(255);
           for( int x=0; x<X; x++){
             for(int y=0; y<Y; y++){
               if(lado*x<w && w<lado*x+100){
                 if(lado*y<h && h<lado*y+100){
                   if(act[q]==0){  act[q]=1;  }
                 }
               }
               q++;
             }
            }
            q=0;
           }
           else cam.pixels[clickPosition] = color(0);
         }
       }
      }
    }
    
  for(int x=0; x<X; x++){
    for(int y=0; y<Y; y++){      
      pushMatrix();
      translate(100*x,100*y,0);
      rotateX(radians(45+a[s]));
      rotateY(radians(45+a[s]));
      fill(175);
      stroke(255);
      box(lado);
      popMatrix();
      if(act[s]==1){a[s]++;}
      s++;
    }
  }
  
  for(int z=0; z<c; z++){
    if(a[z]==360){a[z]=0;}
    act[z]=0;
  }
  
  cam.updatePixels();  
  theBlobDetection.computeBlobs(cam.pixels);
  drawBlobsAndEdges(true, true);
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
    }
  }
}
