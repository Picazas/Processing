//Al moverse el usuario se van generando pequeñas luces que caen de su silueta.

import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import blobDetection.*;
BlobDetection theBlobDetection;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
PBox2D box2d;

float[][] points = new float [100000][2];
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int p=0;
float reScale;
PGraphics img;
PImage cam;
ArrayList<Particle> particles;

void setup(){
  size(1000,700,OPENGL);
  background(255);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  particles = new ArrayList<Particle>();
  
  for (int r=0; r<100000; r++){
    points[r][0] = 0;
    points[r][1] = 0;    
  }
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 9.8);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  println("1");
}

void draw(){ println("2");
  background(0);
  kinect.update();
  box2d.step();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  //PImage cam2 = createImage(640,480,RGB);
  
  cam.loadPixels(); 
 // cam2.loadPixels();
  for (int z=0; z<userList.length; z++){
    for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {
             cam.pixels[clickPosition] = color(0);
            // cam2.pixels[clickPosition] = color(0);
           }
           else{
           cam.pixels[clickPosition] = color(255);
           //cam2.pixels[clickPosition] = color(255,255,255,0);
           }
         }
      }
      
  }
  
  cam.updatePixels();  
 // cam2.updatePixels();
  theBlobDetection.computeBlobs(cam.pixels);
  drawBlobsAndEdges(false, true);

  for(int r=0; r<50; r++){
    int h = int(random(0,100000));
    Particle z = new Particle(points[h][0],points[h][1],2);
    particles.add(z);
    points[h][0] = 0;
    points[h][1] = 0;
  }
  
  for(int r=0; r<1000000; r++){
    for (Particle b: particles) {
      b.radius();
      b.display();
    }
  }
  
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle b = particles.get(i);
    if (b.done()) {
      particles.remove(i);
    }
  }
  p=0;
  /*translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam2,0,0);*/
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
            points[p][0] = eB.x;
            points[p][1] = eB.y;
            p++;
            line(eA.x*width, eA.y*height,eB.x*width, eB.y*height);
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(b.xMin*width, b.yMin*height,b.w*width, b.h*height);
      }
    }
  }
}
