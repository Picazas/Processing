
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
import java.util.Collections;
import toxi.geom.*; // toxiclibs shapes and vectors
import toxi.processing.*; // toxiclibs display
ToxiclibsSupport gfx;
PolygonBlob poly;

int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int maxWidth = 7;
float reScale;
PGraphics img;
PImage cam, blobs;
ArrayList<Particle> particles;

void setup(){
  size(1000,700,OPENGL);
  background(255);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 9.8);
  
  particles = new ArrayList<Particle>();  
  gfx = new ToxiclibsSupport(this);
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
  for(int r=0; r<250; r++){
    Particle p = new Particle(random(width),random(-height,-3),5);
    particles.add(p);
  }
}

void draw(){ 
  background(0);
  kinect.update();
  box2d.step();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  
  blobs.copy(cam, 0, 0, cam.width, cam.height, 0, 0, blobs.width, blobs.height);
  blobs.filter(BLUR, 1);
  theBlobDetection.computeBlobs(blobs.pixels);
  drawBlobsAndEdges(false, true);
  
  poly = new PolygonBlob();
  poly.createPolygon();
  poly.createBody();      //the box2d body
  poly.destroyBody();
  
  cam.loadPixels(); 
  for (int z=0; z<userList.length; z++){
    for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {
             cam.pixels[clickPosition] = color(255);
           }
           else cam.pixels[clickPosition] = color(0);
         }
      }
      
  }
  
  cam.updatePixels();  
  
 // for(int r=0; r<250; r++){
    for (Particle w: particles) {
      if(w.actP[0] != 1){
        Particle p = new Particle(random(width),height/2,5);
        particles.add(p);
      }
    }
 // }
  
  for (Particle p: particles) {
    if(p.actP[0] == 1){
      ellipseMode(CENTER);
      ellipse(p.actP[1],p.actP[2],p.actP[3],p.actP[3]);
      p.actP[3]++;
      p.actP[4]++;
    }
    if(maxWidth == p.actP[3]){
      p.actP[0] = 0;
    }
  }
  
  /*translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam,0,0);*/
  
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
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
            for (Particle p: particles) {
              float xp = p.getPositionX();
              float yp = p.getPositionY();
              if(eA.x*width==xp && eA.y*height==yp){
                p.killBody();
                p.actP[0] = 1;
                p.actP[1] = eA.x*width;
                p.actP[2] = eA.y*width;
                p.actP[3] = 4;
                p.actP[4] = 2;
              }
              if(eB.x*width==xp && eB.y*height==yp){
                p.killBody();
                p.actP[0] = 1;
                p.actP[1] = eA.x*width;
                p.actP[2] = eA.y*width;
                p.actP[3] = 4;
                p.actP[4] = 2;
              }
            }
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
