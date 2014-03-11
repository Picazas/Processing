
import SimpleOpenNI.*;
SimpleOpenNI kinect;

PImage light;
PVector position = new PVector();
PVector jointPos = new PVector(0,0,0);
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
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
}

void draw(){ 
  background(0);
  kinect.update();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
    
    for (int i=0; i<userList.size(); i++){
      int userId = userList.get(i); //getting user data
      kinect.getCoM(userId, position);
      kinect.convertRealWorldToProjective(position, position);
        
      jointPos.x = position.x*reScale;
      jointPos.y = position.y*reScale;
      
    }

  println( jointPos.x + " ; " +jointPos.y); 
  drawLight(jointPos.x,jointPos.y);    
}

void drawLight(float x, float y){
  
  pushMatrix();
  rotateZ(radians(90));
  translate(0,-width,0);
  image(light,0,0,height,(width-x+40));
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(-90));
  translate(-width,0,0);
  image(light,0,0,2*height,x-40);
  popMatrix();
  
  image(light,0,0,width,(y-40));

}
