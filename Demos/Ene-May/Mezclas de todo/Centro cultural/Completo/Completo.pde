
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import blobDetection.*;
BlobDetection theBlobDetection;
import java.awt.Polygon;
import java.util.Collections;
import processing.opengl.*;

//Program
int scene = 5;
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

//Estela
int a=0;
int[] depthValues2;

//Threads
PVector position = new PVector(0,0,0);
PVector jointPos = new PVector(0,0,0);

//WoollenBall
int countWB;
int countWB2;
int[][] actWB = new int [7][8];
int countLineWB;

//////////////////////////////////////  SETUP  ////////////////////////////////////////////

void setup(){
  size(700,550,OPENGL);
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
  
  //BlobDetection
  theBlobDetection = new BlobDetection(cam.width, cam.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(cam.pixels);
  
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
  
  //Estela
  depthValues2 = kinect.depthMap();  
  depthValues = kinect.depthMap();
  
  //WoolenBalls
  countWB = 0;
  countWB2 = 0;
  countLineWB = 0;
}

//////////////////////////////////////  DRAW  ////////////////////////////////////////////

void draw(){
  
  kinect.update();
  userMap = kinect.userMap();
  userList = kinect.getUsers();
  depthValues = kinect.depthMap();
  
  switch(scene){
    case 0:
      fogonazos();
      break;
    case 1:
      niebla();
      break;
    case 2:
      puntosBlancos();
      break;
    case 3:
      explosion();
      break;
    case 4:
      circuloCerrando();
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
      estela(depthValues);
      break;
    case 9:
      woollenBalls();
      break;
  }
}

///////////////////////////////////////////////////////////////////////////////////////

void fogonazos(){
  
}

///////////////////////////////////////////////////////////////////////////////////////

void niebla(){
  
}

///////////////////////////////////////////////////////////////////////////////////////

void puntosBlancos(){
  
}

///////////////////////////////////////////////////////////////////////////////////////

void explosion(){
  
}

///////////////////////////////////////////////////////////////////////////////////////

void circuloCerrando(){
  
}

//////////////////////////////////////  AVOIDTHREADS  ////////////////////////////////////////////

void AvoidThreads(int[] userList,int[] userMap){
  
  background(0);
  for(int s=0; s<6; s++){
     minTH[s][0] = width;
     minTH[s][1] = height;
     maxTH[s][0] = 0;
     maxTH[s][1] = 0;
  }
      
  if (kinect.getNumberOfUsers() > 0) {
       cam.loadPixels(); 
       for(int z = 0; z < userList.length; z++) {    
         for(int x = 0; x < kinectWidth; x++){           //See all the pixels
           for(int y = 0; y < kinectHeight; y++){         
               int clickPosition = x + (y*640); 
               if (userMap[clickPosition] != 0) {
                 cam.pixels[clickPosition] = color(255);
                 if(x < minTH[z][0]){
                   minTH[z][0] = x;
                 }
                 if(x > maxTH[z][0]){
                   maxTH[z][0] = x;
                 }
                 if(y < minTH[z][1]){
                   minTH[z][1] = y;
                 }
                 if(y > maxTH[z][1]){
                   maxTH[z][1] = y;
                 } 
               }
               else cam.pixels[clickPosition] = color(0);
           }
          }  
        }
        cam.updatePixels();
        translate(0, (height-kinectHeight*reScale)/2);
        scale(reScale);
        image(cam,0,0);
  
      for(int r=0; r<nLinesTH; r++){
        int e = (cTH*r)-25;
        int u = (cTH*r)+25;
        linesTH[r][0] = int(random(e,u));
        linesTH[r][1] = int(random(e,u));
       }
      for(int w=0; w<nLinesTH; w++){
        for(int z = 0; z < userList.length; z++) {
          drawLineTH(linesTH[w][0],linesTH[w][1],minTH[z][0],minTH[z][1],maxTH[z][0],w);
        }
      }
     }
     else {
       for(int r=0; r<nLinesTH; r++){
          int e = (cTH*r)-25;
          int u = (cTH*r)+25;
          linesTH[r][0] = int(random(e,u));
          linesTH[r][1] = int(random(e,u));
          line(linesTH[r][0],-20,linesTH[r][1],height);
       }         
     }
    
    for(int r=0; r<nLinesTH; r++){
       if(actLinesTH[r] ==0){ 
          line(linesTH[r][0],-20,linesTH[r][1],height);
       }
    }
    
    for(int r=0; r<nLinesTH; r++){
      actLinesTH[r] = 0;
    }
}


//////////////////////////////////////  DRAWLINETH  ////////////////////////////////////////////

void drawLineTH(int l0, int l1,int minx, int miny, int maxx,int w){
  int s = l1 - l0 - ((l1-l0)/2);
  if(l1<maxx && l1>minx){
     if(l1>(minx+(maxx-minx)/2)){
       stroke(255);
       line(l0,-20,l1,miny-50);
       noFill();
       beginShape();
       curveVertex(l1,(miny)); 
       curveVertex(l1,(miny-51)); 
       curveVertex((maxx+5+s),(miny+100)); 
       curveVertex((maxx+30+s),(miny+200));    
       curveVertex((maxx+30+s),(height-150)); 
       curveVertex((maxx+s),(height+40)); 
       curveVertex((maxx),(height+200));
       endShape();
       actLinesTH[w]=1;
     }
     else if(l1<(minx+(maxx-minx)/2)){
       stroke(255);
       line(l0,-20,l1,miny-50);
       noFill();
       beginShape();
       curveVertex(l1,(miny));
       curveVertex(l1,(miny-51)); 
       curveVertex((minx-5-s),(miny+100)); 
       curveVertex((minx-30-s),(miny+200)); 
       curveVertex((minx-30-s),(height-150)); 
       curveVertex((minx-s),(height+40)); 
       curveVertex((minx),(height+200));
       endShape();
       actLinesTH[w]=1;
     }
   }    
}

//////////////////////////////////////  SNOW  ////////////////////////////////////////////

void snow(int[] userList,int[] depthValues){
  
  background(0);
  
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
  

  theBlobDetection.computeBlobs(cam.pixels);
  drawBlobsAndEdges(false, true);

  for(int x=0; x<num; x++){  

    if(act[x]==0 && actL[x]==0){
      lights[x][0] = 4;
      lights[x][1] = 1;
      snowflakes[x][1] = random(-height,-5);
      count[x] = 0;
      act[x] = 1;
      actL[x] = 0;
    }
    
    if(act[x] == 1){
      drawSnow(snowflakes[x][0],snowflakes[x][1]);
      snowflakes[x][1]+=3;
    }
    
    if(actL[x] == 1){
      fill(255);
      ellipseMode(CENTER);
      ellipse(snowflakes[x][0],snowflakes[x][1],lights[x][0],lights[x][1]);
      lights[x][0]++;
      lights[x][1]++;
      count[x]++;
    }
    
    if(snowflakes[x][1] > (height + 10)){
      act[x] = 0;
      actL[x] = 1;
    }

    if(count[x] > maxCount){
      actL[x] = 0;
    }
    
  }
}

//////////////////////////////////////  STRANDS  ////////////////////////////////////////////

void threads(int[] userList){
  fill(0,0,0,35);
  rect(0,0,width,height);
     
  for (int i=0; i<userList.length; i++){
    int userId = userList[i]; //getting user data
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position);
         
    jointPos.x = position.x*reScale;
    jointPos.y = position.y*reScale;
     
    for(int n=0; n<15; n++){
      PVector v = new PVector();
      v.x = int(random(jointPos.x-50,jointPos.x+50));
      v.y = int(random(jointPos.x-50,jointPos.x+50));
      PVector h = new PVector();
      h.x = int(random(jointPos.y-50,jointPos.y+50));
      h.y = int(random(jointPos.y-50,jointPos.y+50));
      stroke(255);
      line(v.x,0,v.y,height);
      line(0,h.x,width,h.y);
    }
  }
}

//////////////////////////////////////  ESTELA  ////////////////////////////////////////////

void estela(int[] depthValues){
  println(a);
  fill(0,0,0,35);
  rect(0,0,width,height);
  
  
  cam.loadPixels();
  for(int x = 0; x < kinectWidth; x++){           //See all the pixels
    for(int y = 0; y < kinectHeight; y++){
      clickPosition = x + (y*640);        //We see which pixel we are working on
      clickedDepth = depthValues2[clickPosition];    //See the pixel's value 
      if (clickedDepth > 455){
      if (maxValue > clickedDepth){
        switch (a){
          
          case 0:          
            cam.pixels[ clickPosition] = color(255, 0, 0);
            break;
          
          case 1:           
            cam.pixels[ clickPosition] = color(255, 125, 0);
            break;
            
          case 2:           
            cam.pixels[ clickPosition] = color(255, 255, 0);
            break;
            
          case 3:           
            cam.pixels[ clickPosition] = color(125, 255, 0);
            break;
            
          case 4: 
            cam.pixels[ clickPosition] = color(0, 255, 0);
            break;
          
          case 5:           
            cam.pixels[ clickPosition] = color(0, 255, 125);
            break;
                     
          case 6:           
            cam.pixels[ clickPosition] = color(0, 255, 255);
            break;
                     
          case 7:          
            cam.pixels[ clickPosition] = color(0, 125, 255);
            break;
          
          case 8:           
            cam.pixels[ clickPosition] = color(0, 0, 255);
            break;
                     
          case 9:           
            cam.pixels[ clickPosition] = color(125, 0, 255);
            break;
                      
          case 10:           
            cam.pixels[ clickPosition] = color(255, 0, 255);
            a=0;
            break;
          case 11:           
            cam.pixels[ clickPosition] = color(255, 0, 125);
            a=0;
            break;
            
      }
     }  
    }
   }
  }
  
  if (a==11){ a=0; }
  else  a++;
  
  for(int x = 0; x < kinectWidth; x++){           //See all the pixels
    for(int y = 0; y < kinectHeight; y++){
      clickPosition = x + (y*640);        //We see which pixel we are working on
      clickedDepth = depthValues[clickPosition];    //See the pixel's value 
      if (clickedDepth > 455){
      if (maxValue > clickedDepth){
        cam.pixels[ clickPosition] = color(0);}
      }
    }
  }
  
  depthValues2 = depthValues;
  cam.updatePixels();
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam,0,0);
}

//////////////////////////////////////  WOOLLENBALLS  ////////////////////////////////////////////

void woollenBalls(){
  background(0);
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  if(countWB<481){
    countWB++;
    println(countWB);
    if(countWB==60){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==120){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==180){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==240){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==300){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==360){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==420){for(int t=0; t<7; t++){actWB[t][0]=1;}}
    if(countWB==480){for(int t=0; t<7; t++){actWB[t][0]=1;}}
  }
  
  for(int c=0; c<20; c++){
    woollenBall(width/7,100);
    woollenBall(6*width/7,100);
  }
  if(userList.size()>0){
    for (int i=0; i<userList.size(); i++){
      int userId = userList.get(i); //getting user data
      kinect.getCoM(userId, position);
      kinect.convertRealWorldToProjective(position, position);
        
      jointPos.x = position.x*reScale;
      jointPos.y = position.y*reScale;
      
      drawLineWB(width/7,100,int(jointPos.x),int(jointPos.y));
      drawLineWB(6*width/7,100,int(jointPos.x),int(jointPos.y));
    }
  } 
}


//////////////////////////////////////  WOOLLENBALL  ////////////////////////////////////////////

void woollenBall(int inix, int iniy){
  int x = int( inix + random(-30,30));
  int y = int( iniy + random(-30,30));
  stroke(255);
  noFill();
  ellipseMode(CENTER);
  ellipse(x,y,random(1,100),random(1,100));
}


//////////////////////////////////////  DRAWLINEWB  ////////////////////////////////////////////

public void drawLineWB (int xi,int yi,int xf,int yf){
  int r = xf - xi;
  int q = yf - yi;
  for(int w=0; w<2; w++){
    for(int s=0; s<2; s++){
      if(r<0){
        noFill();
        stroke(255);
        beginShape();
        curveVertex(xi+random(-15,15)-20-50*w-50*s,yf-100+random(-15,15));
        curveVertex(xi+random(-15,15),yi+random(-15,15));
        if(countLineWB>0){curveVertex(xf+random(-15,15)-(r/2)-(r/4)-50*w+50*s,(q/2)+50+random(-15,15));}
        if(countLineWB>1){curveVertex(xf+random(-15,15)-(r/2)+(r/4)+50*w+50*s,(q/2)+150+random(-15,15));}
        if(countLineWB>2){curveVertex(xf,yf);}
        if(countLineWB>3){curveVertex(xf+100+random(-15,15)+50*w+50*s,yf+20+random(-15,15));}
        endShape();
      }
      else {
        noFill();
        stroke(255);
        beginShape();
        curveVertex(xi+random(-15,15)+20+50*w+50*s,yf-100+random(-15,15));
        curveVertex(xi+random(-15,15),yi+random(-15,15));
        if(countLineWB>0){curveVertex(xi+random(-15,15)+(r/2)-(r/4)-50*w+50*s,(q/2)+50+random(-15,15));}
        if(countLineWB>1){curveVertex(xi+random(-15,15)+(r/2)+(r/4)-50*w-50*s,(q/2)+150+random(-15,15));}  
        if(countLineWB>2){curveVertex(xf,yf);}
        if(countLineWB>3){curveVertex(xf+random(-15,15)-100-50*w-50*s,yf+20+random(-15,15));}
        endShape();
      }
    }
  }
  if (countWB2 == 10){
    countWB2 = 0;
    countLineWB++;
  }
  else countWB2++;
}

//////////////////////////////////////  DRAWSNOW  ////////////////////////////////////////////

void drawSnow(float x,float y){
  
   noFill();
   stroke(255);
   line(x,y-snowSide/2,x,y+snowSide/2); 
   line(x,y-snowSide/3,x+snowSide/6,y-snowSide/2); 
   line(x,y-snowSide/3,x-snowSide/6,y-snowSide/2);  
   line(x,y+snowSide/3,x+snowSide/6,y+snowSide/2); 
   line(x,y+snowSide/3,x-snowSide/6,y+snowSide/2);
   line(x-snowSide/2,y,x+snowSide/2,y);
   line(x-snowSide/3,y,x-snowSide/2,y+snowSide/6); 
   line(x-snowSide/3,y,x-snowSide/2,y-snowSide/6);  
   line(x+snowSide/3,y,x+snowSide/2,y-snowSide/6); 
   line(x+snowSide/3,y,x+snowSide/2,y+snowSide/6);
   pushMatrix();
   noFill();
   stroke(255);
   translate(x,y,0);
   rotateZ(radians(45));
   line(0,-snowSide/2,0,snowSide/2);
   line(0,-snowSide/3,snowSide/6,-snowSide/2); 
   line(0,-snowSide/3,-snowSide/6,-snowSide/2);  
   line(0,snowSide/3,snowSide/6,snowSide/2); 
   line(0,snowSide/3,-snowSide/6,snowSide/2);
   rotateZ(radians(90));
   line(0,-snowSide/2,0,snowSide/2);
   line(0,-snowSide/2,0,snowSide/2);
   line(0,-snowSide/3,snowSide/6,-snowSide/2); 
   line(0,-snowSide/3,-snowSide/6,-snowSide/2);  
   line(0,snowSide/3,snowSide/6,snowSide/2); 
   line(0,snowSide/3,-snowSide/6,snowSide/2);
   popMatrix();
   
}

//////////////////////////////////////  BLOBDETECTION  ////////////////////////////////////////////

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
              if(eA.x*width-3 < snowflakes[x][0] && snowflakes[x][0] < eA.x*width+3 && snowflakes[x][1] > eA.y*height-3 && snowflakes[x][1] < eA.y*height+3 && count[x] < maxCount){
                act[x] = 0;
                actL[x] = 1;
              }
              else if(eB.x*width-3 < snowflakes[x][0] && snowflakes[x][0] < eB.x*width+3 && snowflakes[x][1] > eB.y*height-3 && snowflakes[x][1] < eB.y*height+3 && count[x] < maxCount){
                act[x] = 0;
                actL[x] = 1;
              }
            }
            
        }
      }
    }
  }
}

//////////////////////////////////////  RESET  ////////////////////////////////////////////

void reset(){
  
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
  
  //Estela
  depthValues2 = kinect.depthMap();
  
  //WoolenBalls
  countWB = 0;
  countWB2 = 0;
  countLineWB = 0;
}

//////////////////////////////////////  MAXVALUE  ////////////////////////////////////////////

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
  case 'r':
    scene++;
    println(scene);
    reset();
    break;
  case 'f':
    scene--;
    reset();
    println(scene);
    break;
  }  
}
