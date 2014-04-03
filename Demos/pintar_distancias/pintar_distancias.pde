//Dibujacada pixel de un color dependiendo de a que distancia se encuentre de la kinect
//siendo el rojo para el más cercano y el azul para el más alejado

import SimpleOpenNI.*;
SimpleOpenNI kinect;

float reScale;
float milimetros;
int clickedDepth,position;
int kinectWidth = 640;
int kinectHeight = 480;

void setup(){
  size (640,480);
  kinect=new SimpleOpenNI(this);
  kinect.enableDepth();
  reScale = (float) width / kinectWidth;
}

void draw(){
  kinect.update();
  PImage cam = createImage(640,480,RGB);
  int[] depthValues = kinect.depthMap();
  
  cam.loadPixels();
  for(int x = 0; x < 640; x++){
    for(int y = 0; y < 480; y++){
      position = x + (y*640);
      clickedDepth = depthValues[position];
      milimetros = clickedDepth;
      if (milimetros < 1000){
        cam.pixels[ position] = color(255,0,0);
      }
      else if (milimetros < 2000){
        cam.pixels[ position] = color(0,255,0);
      }
      else if (milimetros > 2000) {
        cam.pixels[ position] = color(0,0,255);
     }
     else cam.pixels[ position] = color(255,255,255);
   }
  }
  cam.updatePixels();
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam,0,0);
}

void mousePressed(){
  int[] depthValues = kinect.depthMap();
  int clickPosition = mouseX + (mouseY*640);
  int clickedDepth = depthValues[clickPosition];
  float inches = clickedDepth / 25.4;
  float milimetros = clickedDepth;
  inches = inches * 0.025400;
  println("metros: " + inches + "milimetros:" + milimetros);
}
