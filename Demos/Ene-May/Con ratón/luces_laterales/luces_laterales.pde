//Se genera una mancha negra donde se haya el ratón que va difuminando hacia los laterales,
//de donde sale la luz.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

PImage light;
PVector point = new PVector(0,0);
PVector l1 = new PVector(0,0);
PVector l2 = new PVector(0,0);
PVector l0 = new PVector(0,0);
float[] scale = new float[3];
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;

void setup(){
  size(700,550,P3D);
  background(255);
  reScale = (float) width / kinectWidth;
  light = createImage(10*width,200,ARGB);
  
  for(int i = 0; i < light.pixels.length; i++) {
    float a = map(i, 0, light.pixels.length, 255, 0);
    light.pixels[i] = color(255, 255, 255, a); 
  }
  
 /* kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);*/
}

void draw(){ 
  background(0);
 // kinect.update();
  
  point.x = mouseX;
  point.y = mouseY;

    
  drawLight();    
}

public void drawLight(){
  
  pushMatrix();
  rotateZ(radians(90));
  translate(0,-width,0);
  image(light,0,0,height,(width-point.x));
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(-90));
  translate(-width,0,0);
  image(light,0,0,2*height,point.x);
  popMatrix();
  
  image(light,0,0,width,(point.y));
  
  pushMatrix();
  rotateZ(radians(180));
  translate(-width,-height,0);
  image(light,0,0,width,height-point.y);
  popMatrix();

}
