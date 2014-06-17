
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
int time = 8000;
int scene = 7;
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

//Kinect
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
int maxValue = 2500;
float reScale;

//BlobDetection
PImage cam, blobs;

//Sparkles
int[] array1SP = new int [307200];
int[] array2SP = new int [307200];
int numSP;
int countSP;
int actSP;

//Fog
PImage lightF;
PVector l1F = new PVector(0,0);
PVector l2F = new PVector(0,0);
PVector l0F = new PVector(0,0);
float[] scaleF = new float[3];
int[][] posF = new int [14][2];    //{x,y}
int[][] minF = new int[6][2];    //{person}{x,y}
int[][] maxF = new int[6][2];

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

//Snow
int num;
float maxCount = 8;
float snowSide = 10;
int[] floorSnowX = new int[6]; 
int[] floorSnowY = new int[6];
int[] count;
int[] act;
int[] actL;
float[][] snowflakes;
float[][] lights;

//LinesV&H
int totalLVH =90;
int lineW;
int c=0;
int c2=0;
int actLVH=0;

//Threads
PVector position = new PVector(0,0,0);
PVector jointPos = new PVector(0,0,0);

//WoollenBall
int countWB;
int countWB2;
int[][] actWB = new int [7][8];
int countLineWB;

//Squares
int[][] posSQ = new int [14][2];    //{x,y}
int[][] minSQ = new int[6][2];    //{person}{x,y}
int[][] maxSQ = new int[6][2];
PImage square;
int beforeSQ;
int nowSQ;

//////////////////////////////////////  SETUP  ////////////////////////////////////////////

void setup(){
  size(1000,600,OPENGL);
  background(0);
  reScale = (float) width / kinectWidth;
  cam = createImage(640,480,RGB);
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  
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
  
  //BlobDetection
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
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
  
  //Fog
  lightF = createImage(10*width,200,ARGB);  
  for(int i = 0; i < lightF.pixels.length; i++) {
    float a = map(i, 0, lightF.pixels.length, 255, 0);
    lightF.pixels[i] = color(255, 255, 255, a); 
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
  
  
  //AvoidThreads
  cTH = width/nLinesTH;
  linesTH = new int[nLinesTH][2];
  actLinesTH =new int [nLinesTH];
  for(int r=0; r<nLinesTH; r++){
    linesTH[r][0] = int(random( (cTH*r)-25, (cTH*r)+25 ));
    linesTH[r][1] = int(random( (cTH*r)-25, (cTH*r)+25 ));
    actLinesTH[r] = 0;
  }
  
  //Snow
  num = width/2;
  snowflakes = new float[num][2];
  lights = new float[num][2];
  count = new int[num];
  act = new int[num];
  actL = new int[num];
 
  for(int x=0; x<num; x++){
      lights[x][0] = 4;
      lights[x][1] = 1;
      snowflakes[x][0] = 2*x;
      snowflakes[x][1] = random(-height,-5);
      act[x] = 1;
      actL[x] = 0;
  }
  
  //LinesV&H
  lineW = width/totalLVH;
  
  //WoolenBalls
  countWB = 0;
  countWB2 = 0;
  countLineWB = 0;
  
  //Squares
  beforeSQ = 0;
  nowSQ = 0;
  square = createImage(width/14,width/14,ARGB);
  for(int i = 0; i < square.pixels.length; i++) {
    float a = map(i, 0, square.pixels.length, 255, 0);
    square.pixels[i] = color(255, 255, 255, a); 
  }

  for( int u=0; u<14; u++){
    posSQ[u][0] = int(u*width/14.2);
    posSQ[u][1] = 0;
  }
  
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
      sparkles(depthValues);
      break;
    case 1:
      fog(userList, depthValues);
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
    case 5:
      AvoidThreads(userList, userMap);
      break;
    case 6:
      snow(userList, depthValues);
      break;
    case 7:
      threads(userList);
      break;
    case 8:
      LinesVH(depthValues);
      break;
    case 9:
      woollenBalls();
      break;
    case 10:
      squares(userList, userMap);
      break;
    default:
      background(0,255,0);
      break;
  }
}


