
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
      case 7:
        futureScene = 8;
        break;
      case 8:
        futureScene = 9;
        break;
      case 9:
        futureScene = 10;
        break;
      case 10:
        futureScene = 0;
        break;
    }
  }
  
  
  /*if(people > 1 && peopleBefore < 1){
    control = 1;
    switch(scene){
      case 0:
        end[0] = 1;
        futureScene = 5;
        break;
      case 1:
        end[1] = 1;
        futureScene = 5;
        break;
      case 2:
        end[2] = 1;
        futureScene = 5;
        break;
      case 3:
        end[3] = 1;
        futureScene = 5;
        break;
      case 4:
        end[4] = 1;
        futureScene = 5;
        break;
    }
  }
  else if(people < 1 && peopleBefore > 1){
    control = 1;
    switch(scene){
      case 5:
        end[5] = 1;
        futureScene = 0;
        break;
      case 6:
        end[6] = 1;
        futureScene = 0;
        break;
      case 7:
        end[7] = 1;
        futureScene = 0;
        break;
      case 8:
        end[8] = 1;
        futureScene = 0;
        break;
      case 9:
        end[9] = 1;
        futureScene = 0;
        break;
      case 10:
        end[10] = 1;
        futureScene = 0;
        break;
    }
  }*/
}
  
  
/////////////////////////////////////////  ENDING  ////////////////////////////////////////////

void ending(){
  
  countEnding++;
  println(countEnding);
  
  translate(0,0,ZNumbers);
  /*fill(0,0,0,35);
  rect(0,0,width,height);*/
  background(0);
  
  String s = "cambiando de escenario";
  fill(175);
  noStroke();
  textSize(32);
  text(s,width/7,50);
  
  for(int u=0; u<5; u++){
    if(u*60 == countEnding){ZNumbers = -60;}
  }
  
  if(countEnding  < 60){
    textSize(256);
    text("5",width/3,2*height/3);
    ZNumbers++;
  }
  else if(countEnding < 120){
    textSize(256);
    text("4",width/3,2*height/3);
    ZNumbers++;
  }
  else if(countEnding < 180){
    textSize(256);
    text("3",width/3,2*height/3);
    ZNumbers++;
  }
  else if(countEnding < 240){
    textSize(256);
    text("2",width/3,2*height/3);
    ZNumbers++;
  }
  else if(countEnding < 300){
    textSize(256);
    text("1",width/3,2*height/3);
    ZNumbers++;
  }
  else if(countEnding == 300){
    end[scene] = 0;
    scene = futureScene;
    futureScene = 0;
    countEnding = 0;
    countScene = 0;
    control = 0;
  }
  
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
  
  //Sparkles
  numSP = 0;
  countSP = 0;
  actSP = 0;
  for(int o=0; o<307200; o++){
    array1SP[o] = 0;
    array2SP[o] = 0;
  } 
  
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
    countScene = 17950;
    break;
  
  }  
}
