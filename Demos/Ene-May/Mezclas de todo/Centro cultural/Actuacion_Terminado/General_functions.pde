
/////////////////////////////////////////  CONTROLP  ////////////////////////////////////////////

void controlP(){  
  
  if(control == 0){
    switch(scene){
      case 0:
        futureScene = 1;
        break;
      case 1:
        futureScene = 2;
        break;
      case 2:
        futureScene = 3;
        break;
      case 3:
        futureScene = 4;
        break;
      case 4:
        futureScene = 5;
        break;
      case 5:
        futureScene = 6;
        break;
      case 6:
        futureScene = 7;
        break;
    }
  }
}
  
  
/////////////////////////////////////////  ENDING  ////////////////////////////////////////////

void ending(){
    end[scene] = 0;
    scene = futureScene;
    futureScene = 0;
    countScene = 0;
    control = 0;

}

//////////////////////////////////////  RESET  ////////////////////////////////////////////

void reset(){
  
  //Sparkles
  numSP = 0;
  countSP = 0;
  actSP = 0;
  for(int o=0; o<307200; o++){
    array1SP[o] = 0;
    array2SP[o] = 0;
  } 
  
  //closingCircle
  PixelsCC = height*width;
  radioCC = int(width*2);
  comienzoCC = 0;
  cuentaPixelsCC = 100000;
  
  //Explosion
  particles = new ArrayList<Particle>();
  boundaries = new ArrayList<Boundary>();
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
  case 'm':
    countScene = time-10;
    break;
  
  }  
}
