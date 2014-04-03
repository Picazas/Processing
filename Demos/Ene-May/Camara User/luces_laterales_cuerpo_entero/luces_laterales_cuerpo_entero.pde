//Se crean luces que salen de los laterales y de arriba y se van difuminando hasta llegar
//al usuario. Coge la sección eficaz del usuario. Encima del usuario no hay "luz" alguna.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

PImage light;
PVector position = new PVector();
PVector jointPos = new PVector(0,0,0);
PVector l1 = new PVector(0,0);
PVector l2 = new PVector(0,0);
PVector l0 = new PVector(0,0);
float[] scale = new float[3];
int[][] pos = new int [14][2];    //{x,y}
int[][] min = new int[6][2];    //{person}{x,y}
int[][] max = new int[6][2];
int clickedDepth,clickPosition;
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
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  scale(reScale);
  
  for(int s=0; s<6; s++){
     min[s][0] = width;
     min[s][1] = height;
     max[s][0] = 0;
     max[s][1] = 0;
  }
    
  for (int z=0; z<userList.length; z++){
    for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {

             if(w < min[z][0]){
               min[z][0] = w;
             }
             if(w > max[z][0]){
               max[z][0] = w;
             }
             if(h < min[z][1]){
               min[z][1] = h;
             }
             if(h > max[z][1]+5){
               max[z][1] = h;
             } 
           }
         }
      }
      
  }

  drawLight(min[0][0],min[0][1],max[0][0],max[0][1]);    
}

void drawLight(float xmin, float ymin, float xmax, float ymax){
  
  pushMatrix();
  rotateZ(radians(90));
  translate(0,-width,0);
  image(light,0,0,height,(width-xmax));
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(-90));
  translate(-width,0,0);
  image(light,0,0,2*height,xmin);
  popMatrix();
  
  image(light,0,0,width,ymin);

}
