//Divide la imagen en una red de 50x30 cuadrados que se iluminan si se encuentra algún usuario
//o algún objeto en ellos. Como un tablero de ajedrez que se ilumina.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int[][] square = new int [2][2]; //{Xi,Yi}{Xf,Yf}
int[] act;
int squareV = 30;
int squareH = 50;
int kinectWidth = 640;
int kinectHeight = 480;
int clickedDepth,clickPosition;
int maxValue;
float reScale;

void setup(){
  size(640,480,P3D);
  background(0);
  //frameRate(3);
  kinect= new SimpleOpenNI(this);
  reScale = (float) width / kinectWidth;
  
  if (kinect.isInit()==false){
   println("Nada de nada chato");
   exit();
   return; 
  }
  
  act = new int [squareV*squareH];
  
  kinect.setMirror(true);
  kinect.enableDepth();  
  maxValue = 2500;
  for(int u=0; u<squareV*squareH; u++){act[u]=0;}
}

void draw(){

  kinect.update();
  int[] depthValues = kinect.depthMap();
  PImage cam = createImage(640,480,RGB);
  
  fill(0);
  rect(-1,-1,width+1,height+1);
  stroke(255);
  for(int v=0; v<squareV; v++){
    line(0,height*v/squareV,width,height*v/squareV);
  }
  for(int h=0; h<squareH; h++){
    line(width*h/squareH,0,width*h/squareH,height);
  }
  cam.loadPixels();
  for(int x = 0; x < 640; x++){           //See all the pixels
    for(int y = 0; y < 480; y++){
      clickPosition = x + (y*640);        //We see which pixel we are working on
      clickedDepth = depthValues[clickPosition];    //See the pixel's value 
      if (clickedDepth > 455 && maxValue > clickedDepth){        
          for(int cx=0; cx<squareH; cx++){
            for(int cy=0; cy<squareV; cy++){
              int x1 = int(width*cx/squareH);
              int x2 = int(width*(cx+1)/squareH);
              int y1 = int(height*cy/squareV);
              int y2 = int(height*(cy+1)/squareV);
              if( x>x1 && x<x2 && y>y1 && y<y2){
                int num = cx + cy*squareH;
                act[num] = 1;
              }
            }
          }                 
        }
     }    
  }
  cam.updatePixels();
  
  for(int x = 0; x < squareH; x++){
    for(int y = 0; y < squareV; y++){
      int num = x + y*squareH;
      if(act[num] == 1){
         square[0][0] = int(width*x/squareH);      //XI
         square[1][0] = int(width*(x+1)/squareH);  //XF
         square[0][1] = int(height*y/squareV);      //YI
         square[1][1] = int(height*(y+1)/squareV);  //YF
    
         fill(255);
         rect(square[0][0],square[0][1],square[1][0],square[1][1]);
      }
    }
  }

  for(int u=0; u<squareV*squareH; u++){act[u]=0;}
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
