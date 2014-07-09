
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
PBox2D box2d;
import blobDetection.*;
BlobDetection theBlobDetection;
import java.awt.Polygon;
import java.util.Collections;
import processing.opengl.*;

//Program
int control = 0;
int time = 800000000;
int scene = 0;
int people = 5;
int peopleBefore = 5 ;
int futureScene = 0;
int countEnding = 0;
int countScene = 0;
int ZNumbers = -60;
int[] end = new int[11];
int[] endFinished = new int[11];
int[] userMap ;
int[] userList ;
int[] depthValues ;
PVector position = new PVector(0,0,0);
PVector jointPos = new PVector(0,0,0);

//Kinect
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int maxValue = 2650;
float reScale;
PImage cam;

//Sparkles
int[] array1SP = new int [307200];
int[] array2SP = new int [307200];
int numSP;
int countSP;
int actSP;

//whitePoints
float max_distance;

//Explosion
int[][] nowEX = new int[7][2];
int[][] beforeEX = new int[7][2];
int[][] minEX = new int[6][2];    //{person}{x,y}
int[][] maxEX = new int[6][2];
int [] pixelEX;
int allParticlesEX = 250;
ArrayList<Boundary> boundaries;
ArrayList<Particle> particles;

//ClosingCircle
int comienzoCC;
int radioCC;
int cuentaPixelsCC;
int PixelsCC = 0;

//AvoidThreads
int[][] linesTH;                  //{line}{y0,y1}
int[] actLinesTH;
int[][] minTH = new int[6][2];    //{person}{x,y}
int[][] maxTH = new int[6][2];
int cTH;
int nLinesTH = 150;

//////////////////////////////////////  SETUP  ////////////////////////////////////////////

void setup(){
  size(800,600,OPENGL);
  background(255);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  
  //Kinect
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  if (kinect.isInit()==false){
   println("Nada");
   exit();
   return; 
  }
  
  //Box2D
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  
  //Program
   for(int o=0; o<11; o++){
    end[o] = 0;
    endFinished[o] = 0;
  }
  
  //Sparkles
  numSP = 0;
  countSP = 0;
  actSP = 0;
  for(int o=0; o<307200; o++){
    array1SP[o] = 0;
    array2SP[o] = 0;
  }
  
  //whitePoints
  max_distance = dist(0, 0, width, height);
  
  //Explosion
  particles = new ArrayList<Particle>();
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  pixelEX = new int[width*height];
  for(int s=0; s<6; s++){
     minEX[s][0] = width;
     minEX[s][1] = height;
     maxEX[s][0] = 0;
     maxEX[s][1] = 0;
  }
  
  for(int r=0; r<allParticlesEX; r++){
    Particle p = new Particle(random(width),random(height),2);
    particles.add(p);
  }
  
  for(int q=0; q<pixelEX.length; q++){
    pixelEX[q] = 0;
  }
  
  for(int u=0; u<4; u++){
    beforeEX[u][0] =0;
    beforeEX[u][1] = 0;
    nowEX[u][0] = 0;
    nowEX[u][1] = 0;
  }
  
  //closingCircle
  PixelsCC = height*width;
  radioCC = int(width*2);
  comienzoCC = 0;
  cuentaPixelsCC = 100000;
  
}

//////////////////////////////////////  DRAW  ////////////////////////////////////////////

void draw(){
  println(countScene);
  println("Scene: "+ scene);
  println("People: "+ people);
  
  box2d.step();
  kinect.update();
  userMap = kinect.userMap();
  userList = kinect.getUsers();
  depthValues = kinect.depthMap();
  
  if(userList.length>0){
    people = userList.length; 
  }
  controlP();
  //peopleBefore = people;   
  countScene ++;
  
  switch(scene){
    case 0:
      sparkles(userList, userMap);
      break;
    case 1:
      threads(userList);
      break;
    case 2:
      whitePoints(depthValues);
      break;
    case 3:
      explosion(userList, userMap);
      break;
    case 4:
      closingCircle(depthValues);
      break;
    default:
      background(0);
      break;
  }
}


