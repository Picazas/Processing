
import SimpleOpenNI.*;
SimpleOpenNI kinect;
import processing.opengl.*;

int[] array1 = new int [307200];
int[] array2 = new int [307200];
int[][] pos = new int [14][2];    //{x,y}
int[][] min = new int[6][2];    //{person}{x,y}
int[][] max = new int[6][2];
PVector position = new PVector();
PVector jointPos = new PVector(0,0,0);
PImage square;
int lado;
int before = 0;
int now = 0;
int num = 0;
int count = 0;
int clickedDepth,clickPosition;
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;
float movUp = 0;
float gravity = 0.00005;
float[] speed = new float[14];

void setup(){
  size(700,500,OPENGL);
  background(0);
  lado = width/14;
  square = createImage(lado,lado,ARGB);
  reScale = (float) width / kinectWidth;

  for(int i = 0; i < square.pixels.length; i++) {
    float a = map(i, 0, square.pixels.length, 255, 0);
    square.pixels[i] = color(255, 255, 255, a); 
  }

  for(int o=0; o<307200; o++){
    array1[o] = 0;
    array2[o] = 0;
  }

  for( int u=0; u<14; u++){
    pos[u][0] = int(u*width/14.2);
    pos[u][1] = 0;
    speed[u] = 0;
  }
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
}

void draw(){
  
  kinect.update();
  int[] userMap = kinect.userMap(); 
  int[] userList = kinect.getUsers();
  int[] depthValues = kinect.depthMap();
  
  
  fill(0);
  rect(0,0,width,height);
  for(int s=0; s<6; s++){
     min[s][0] = width;
     min[s][1] = height;
     max[s][0] = 0;
     max[s][1] = 0;
  }
  
  if (kinect.getNumberOfUsers() > 0) {   
     for (int z=0; z<userList.length; z++){ 
      for(int h = 0; h < 480; h++){           //See all the pixels
       for(int w = 0; w < 640; w++){
         clickPosition = w + (h*640);        //We see which pixel we are working on
         if (userMap[clickPosition] != 0) {
           
             array2 [clickPosition] = 1;
             
             if(w < min[z][0]){
               min[z][0] = int(w*reScale);
             }
             if(w > max[z][0]){
               max[z][0] = int(w*reScale);
             }
             if(h < min[z][1]){
               min[z][1] = int(h*reScale);
             }
             if(h > max[z][1]+5){
               max[z][1] = int(h*reScale);
             } 
           }
           else array2 [clickPosition] = 0;
         }
      }
      
     for(int r=0; r<307200; r++){
        if(array1[r] != array2[r]){
          num++;
        }
     }   
      
    movUp = num/4000;  
    if(movUp < 1) movUp = 1;
    println("MovUp:"+movUp);      
    println("num:"+num);
      for( int u=0; u<14; u++){
        int minS = int( u * width/14);
        int maxS =int( (u+1) * width/14);
        if(gravity<1){gravity=1;}
           if(min[z][0]<maxS && min[z][0]>minS && max[z][0]>maxS){
             if(pos[u][1]>-1){
               pos[u][1]-= movUp;
             }
           }
           else if(min[z][0]<minS && max[z][0]>maxS){
             if(pos[u][1]>-1){
               pos[u][1]-= movUp;
             }
           }
           else if(min[z][0]<minS && max[z][0]>minS && max[z][0]<maxS){
             if(pos[u][1]>-1){
               pos[u][1]-= movUp;
             }
           }
           else{
             if(pos[u][1] < height-width/14){
             pos[u][1] += speed[u]/10;
             speed[u] += gravity;      
             println("Speed:"+speed[u]);
             }
           }
      }
    }
  }
  
  filtro();
  
  for(int r=0; r<307200; r++){
    array1[r] = array2[r];
  }
  num = 0;
  
  for( int u=0; u<14; u++){
    image(square,pos[u][0],pos[u][1]);
  }
}

void filtro(){
  for( int u=0; u<14; u++){
    if(pos[u][1] < 0){
      pos[u][1] = 0;  
      speed[u] = 1;      
    }    
    else if(pos[u][1] > height-lado){
      pos[u][1] = height-lado; 
      speed[u] = 1;     
    }
  }
}

