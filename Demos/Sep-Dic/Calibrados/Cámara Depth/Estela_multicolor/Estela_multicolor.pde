//Con el movimiento se va dejando una estela de diferentes colores por donde se pasa, vale
//con objetos también, no solo con las personas.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int kinectWidth = 640;
int kinectHeight = 480;
// to center and rescale from 640x480 to higher custom resolutions
float reScale;
int clickedDepth,clickPosition;
int maxValue = 2500;
int a=0;
int[] depthValues2;
int[] depthValues;

void setup(){
  size (1024, 768);
  kinect= new SimpleOpenNI(this);
  background(0);
  frameRate(10);
  reScale = (float) width / kinectWidth;
  
  if (kinect.isInit()==false){
   println("Nada de nada chato");
   exit();
   return; 
  }
  
  kinect.setMirror(true);
  kinect.enableDepth();
  
  depthValues2 = kinect.depthMap();
  depthValues = kinect.depthMap();
  
}


void draw()
{
  // update the cam
  kinect.update();
  fill(0,0,0,35);
  rect(0,0,width,height);

  PImage cam = createImage(640,480,RGB);

  depthValues2 = depthValues;
  cam.loadPixels();

  for(int x = 0; x < 640; x++){           //See all the pixels
    for(int y = 0; y < 480; y++){
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
  
  if (a==11) a=0;
  else  a++;
  
  depthValues = kinect.depthMap();  //Save the Depth's values in an array
  
  for(int x = 0; x < 640; x++){           //See all the pixels
    for(int y = 0; y < 480; y++){
      clickPosition = x + (y*640);        //We see which pixel we are working on
      clickedDepth = depthValues[clickPosition];    //See the pixel's value 
      if (clickedDepth > 455){
      if (maxValue > clickedDepth){
        cam.pixels[ clickPosition] = color(0);}
      }
    }
  }
  cam.updatePixels();
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);
  image(cam,0,0);
}

void keyPressed(){
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
