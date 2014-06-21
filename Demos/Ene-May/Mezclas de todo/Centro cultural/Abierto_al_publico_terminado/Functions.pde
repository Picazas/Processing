

/////////////////////////////////////////  SPARKLES  ////////////////////////////////////////////

void sparkles(int[] depthValues){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
    fill(0,0,0,30);
    rect(0,0,width*2,height*2);
    cam.loadPixels();
    for(int x = 0; x < kinectWidth; x++){           //See all the pixels
      for(int y = 0; y < kinectHeight; y++){
        clickPosition = x + (y*kinectWidth);        //We see which pixel we are working on
        clickedDepth = depthValues[clickPosition];    //See the pixel's value 
        if (clickedDepth > 455){
          if (maxValue > clickedDepth){
            array2SP [clickPosition] = 1;
            cam.pixels[ clickPosition] = color(175);
          }
          else array2SP [clickPosition] = 0;
        }
      }
    }
    cam.updatePixels();
    
    for(int r=0; r<307200; r++){
      if(array1SP[r] != array2SP[r]){
        numSP++;
      }
    }
    
    println("flujo optico: " + numSP);
    println("act: " + actSP);
    
    if(numSP > 6000 && actSP==0){
      actSP=1;
    }
    
    if(actSP==1 && countSP<4){
      fill(255);
      noStroke();
      rect(0,0,width,height);
      stroke(0,0,50);
      strokeWeight(10);
      line(int(random(0,width)),0,0,int(random(0,height)));
      line(int(random(0,width)),height,width,int(random(0,height)));
      line(int(random(0,width)),0,int(random(0,width)),height);
      line(0,int(random(0,height)),width,int(random(0,height)));
      line(int(random(0,width)),0,0,int(random(0,height)));
      countSP++;
    }
    
    if(countSP == 4){
      countSP=0;
      actSP=0;
    }
    
    for(int r=0; r<307200; r++){
      array1SP[r] = array2SP[r];
    }
    numSP = 0;
  }
}

/////////////////////////////////////////  FOG  ////////////////////////////////////////////

void fog(int[] userList, int[] depthValues){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
  
    background(0);
    scale(reScale);
    for(int s=0; s<6; s++){
       minF[s][0] = width;
       minF[s][1] = height;
       maxF[s][0] = 0;
       maxF[s][1] = -20;
    }
    cam.loadPixels();  
    for (int z=0; z<userList.length; z++){
      for(int h = 0; h < kinectHeight; h++){           //See all the pixels
         for(int w = 0; w < kinectWidth; w++){
           clickPosition = w + (h*kinectWidth);        //We see which pixel we are working on
           if (userMap[clickPosition] != 0) {
                cam.pixels[clickPosition] = color(255,0,0);
               if(w < minF[z][0]){
                 minF[z][0] = w;
               }
               if(w > maxF[z][0]){
                 maxF[z][0] = w;
               }
               if(h < minF[z][1]){
                 minF[z][1] = h;
               }
               if(h > maxF[z][1]+5){
                 maxF[z][1] = h;
               } 
             }
           }
        }
        
    }
    cam.updatePixels();
    translate(0, (height-kinectHeight*reScale)/2);
    scale(reScale);
    image(cam,0,0);
    drawLightF(minF[0][0],minF[0][1],maxF[0][0],maxF[0][1]);
  }
}

//////////////////////////////////////  DRAWLIGHTF  ////////////////////////////////////////////

void drawLightF(float xmin, float ymin, float xmax, float ymax){

    background(0);
    float cx = (xmax-xmin)/2;
    float cy = 50+(ymax-ymin)/2;
    float xi = xmin/2;
    float xd = (width-xmax)/2;
    float y = ymin/2;
    
    pushMatrix();
    rotateZ(radians(90));
    translate(0,-width,0);
    image(lightF,y,(width-2*xmax),height,(width-xmax));
    popMatrix();
      
    pushMatrix();
    rotateZ(radians(-90));
    translate(-width/2,-xi,0);
    image(lightF,y,xi,height,xmin);
    popMatrix();
    
    image(lightF,0,y,width,ymin);
    
    pushMatrix();  
    fill(255);
    noStroke();
    rectMode(CORNERS);
    rect(-50,-100,width,y);
    rect(width-xd,-50,width,height);
    rect(-50,-50,xmin/2-100,height);
    popMatrix();

}

//////////////////////////////////////  WHITEPOINTS  ////////////////////////////////////////////

void whitePoints(int[] depthValues){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
  
    background(0);
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    
    for (int z=0; z<userList.size(); z++){    
      int userId = userList.get(z);           //getting user data    
      kinect.getCoM(userId, position);
      kinect.convertRealWorldToProjective(position, position);
        
      jointPos.x = position.x*reScale;
      jointPos.y = position.y*reScale;    
      
      for(int i = 0; i <= width; i += 20) {
        for(int j = 0; j <= height; j += 20) {
          float size = dist(jointPos.x, jointPos.y, i, j);
          size = size/max_distance * 66;
          fill(255);
          noStroke();
          ellipse(i, j, size, size);
        }
      }
    }
  }
}

//////////////////////////////////////  EXPLOSION  ////////////////////////////////////////////

void explosion(int[] userList,int[] userMap){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
  
    background(255);
    int totalEX = 0;  
    for(int s=0; s<6; s++){
       minEX[s][0] = width;
       minEX[s][1] = height;
       maxEX[s][0] = 0;
       maxEX[s][1] = 0;
    }
    
    for (int z=0; z<userList.length; z++){    
      int userId = userList[z]; //getting user data
      kinect.getCoM(userId, position);
      kinect.convertRealWorldToProjective(position, position);
        
      nowEX[z][0] = int(position.x*reScale);
      nowEX[z][1] = int(position.y*reScale);
      
      for(int h = 0; h < kinectHeight; h++){           //See all the pixels
         for(int w = 0; w < kinectWidth; w++){
           clickPosition = w + (h*kinectWidth);        //We see which pixel we are working on
           if (userMap[clickPosition] != 0) {
             pixelEX[clickPosition] = 1;
             if(w < minEX[z][0]){
                 minEX[z][0] = w;
               }
               if(w > maxEX[z][0]){
                 maxEX[z][0] = w;
               }
               if(h < minEX[z][1]){
                 minEX[z][1] = h;
               }
               if(h > maxEX[z][1]+5){
                 maxEX[z][1] = h;
               }
           }
         }
      }
    }
    int aty=userList.length;
    println("USERLIST: "+aty);
    println("TOTAL: "+totalEX);
    float d = maxEX[0][0]-minEX[0][0];
    float n = maxEX[0][1]-minEX[0][1];
    println("B-N: "+d+" ; "+n);
    if (d<400) {
      int count=0;
      int s=0;
      for(int user=0; user<7; user++){
        if (nowEX[user][0]!=0 && nowEX[user][1]!=0){
          totalEX++;
        }      
      }
      for (Particle b: particles) {
        switch(totalEX){
          case 1:
            for(int user=0; user<7; user++){
              if (nowEX[user][0]!=0 && nowEX[user][1]!=0){
                b.attract(nowEX[user][0],nowEX[user][1]);
              }      
            }
            break;
          case 2:
            s = int(allParticlesEX/2);
            if(count<s){
              b.attract(nowEX[2][0],nowEX[2][1]);
            }
            else{
              b.attract(nowEX[1][0],nowEX[1][1]);
            }
            break;
          case 3:
            s = int(allParticlesEX/3);
            if(count<s){
              b.attract(nowEX[3][0],nowEX[3][1]);
            }
            else if(count<2*s){
              b.attract(nowEX[1][0],nowEX[1][1]);
            }
            else{
              b.attract(nowEX[2][0],nowEX[2][1]);
            }
            break;
          case 4:
            s = int(allParticlesEX/4);
            if(count<s){
              b.attract(nowEX[4][0],nowEX[4][1]);
            }
            else if(count<2*s){
              b.attract(nowEX[1][0],nowEX[1][1]);
            }
            else if(count<3*s){
              b.attract(nowEX[2][0],nowEX[2][1]);
            }
            else{
              b.attract(nowEX[3][0],nowEX[3][1]);
            }
            break;
        }     
        count++;
      }
    }
    else{
      int r = 0;
      
      for (Particle b: particles) {
          r++;
          int x = int(r/65);
          switch(x){
            case 0:
             b.moveAway(random(0,width),0);
              break;
            case 1:
              b.moveAway(random(0,width),height);
              break;
            case 2:
              b.moveAway(0,random(0,height));
              break;
            case 3:
              b.moveAway(width,random(0,height));
              break;
          }
      }
    }
  
    for (Boundary wall: boundaries) {
      wall.display();
    }
  
    for (Particle b: particles) {
      b.display();
    }
  
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle b = particles.get(i);
      if (b.done()) {
        particles.remove(i);
      }
    }
    for(int u=0; u<4; u++){
      beforeEX[u][0] = nowEX[u][1];
      beforeEX[u][0] = nowEX[u][1];
    }
    for(int q=0; q<pixelEX.length; q++){
      pixelEX[q] = 0;
    }
  }
}

//////////////////////////////////////  CLOSING CIRCLE  ////////////////////////////////////////////

void closingCircle(int[] depthValues){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{    
    fill(0);
    rect(0,0,width,height);  
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    
    cam.loadPixels();
    for(int x = 0; x < 640; x++){           //See all the pixels
      for(int y = 0; y < 480; y++){
        clickPosition = x + (y*640);        //We see which pixel we are working on
        clickedDepth = depthValues[clickPosition];    //See the pixel's value 
        if (clickedDepth > 455){
          if (maxValue > clickedDepth){
            cuentaPixelsCC++;
            cam.pixels[ clickPosition] = color(0);
          }
        }
      }
    }
    cam.updatePixels();
    
    for (int z=0; z<userList.size(); z++){
      
      int userId = userList.get(z);           //getting user data    
      kinect.getCoM(userId, position);
      kinect.convertRealWorldToProjective(position, position);
        
      jointPos.x = position.x*reScale;
      jointPos.y = position.y*reScale;    
  
    }  
    
    if (cuentaPixelsCC < 35000)  {
      comienzoCC = 1;
    }
    if (comienzoCC == 1){
      radioCC-=15;
      if(radioCC < 30){
        comienzoCC = 0;
        radioCC = int(width*1.6);
      }
      fill(255);
      ellipse(jointPos.x,jointPos.y,radioCC,radioCC);
    }
    else{  
      fill(255);
      ellipse(width/2,height-height/20,radioCC,radioCC); 
    }
    
    println("Comienzo: " + comienzoCC);
    println("Pixels: " + cuentaPixelsCC); 
    translate(0, (height-kinectHeight*reScale)/2);
    scale(reScale);
    image(cam,0,0);  
    }
}

//////////////////////////////////////  AVOIDTHREADS  ////////////////////////////////////////////

void AvoidThreads(int[] userList,int[] userMap){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
  
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
                 int clickPosition = x + (y*kinectWidth); 
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
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
  
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
}

//////////////////////////////////////  STRANDS  ////////////////////////////////////////////

void threads(int[] userList){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
    fill(0,0,0,35);
    rect(0,0,2*width,2*height);
       
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
}

//////////////////////////////////////  LINES V&H  ////////////////////////////////////////////

void LinesVH(int[] depthValues){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  

    PImage camLVH = createImage(640,480,RGB);
    camLVH.loadPixels();
    for(int y = 0; y < 480; y++){
      
      if(c2<lineW){
        actLVH=1;
        c2++;
      }
      else if(c2<(lineW*2)){
        actLVH=2;
        c2++;
      }
      if(c2==(2*lineW-1)) {c2=0;}
      
      for(int x = 0; x < 640; x++){         //See all the pixels    
        clickPosition = x + (y*640);        //We see which pixel we are working on
        clickedDepth = depthValues[clickPosition];    //See the pixel's value 
        if (clickedDepth > 455){
          if (maxValue > clickedDepth){
            if(actLVH==1){
                camLVH.pixels[clickPosition] = color(255);
              }
              else if(actLVH==2){
                camLVH.pixels[clickPosition] = color(0);
              }
          }
          else {
            camLVH.pixels[clickPosition] = color(0);
            for(int h=0; h<totalLVH; h+=2){
              if(x > h*lineW && x < h*lineW+lineW){
                camLVH.pixels[clickPosition] = color(255);
              }
            }
          }
        }
      }
    }
    camLVH.updatePixels();    
  
    fill(255);
    rect(0,0,width,height);
    
    pushMatrix();
    translate(0, (height-kinectHeight*reScale)/2);
    scale(reScale);
    image(camLVH,0,0);
    popMatrix();
    
    /*for(int r=0; r<(totalLVH+1); r++){
      if(c==1){
        c=0;
        fill(0);
        noStroke();
        rect((lineW*r),-20,lineW,(height+40));
      }
     else if(c==0){c=1;}
    }*/
    c=0; 
    c2=0;
  }
}

//////////////////////////////////////  WOOLLENBALLS  ////////////////////////////////////////////

void woollenBalls(){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
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


//////////////////////////////////////  SQUARES  ////////////////////////////////////////////

void squares (int[] userList,int[] userMap){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{    
   
    fill(0);
    rect(0,0,width,height);
    for(int s=0; s<6; s++){
       minSQ[s][0] = width;
       minSQ[s][1] = height;
       maxSQ[s][0] = 0;
       maxSQ[s][1] = 0;
    }
    
    if (kinect.getNumberOfUsers() > 0) {   
       for (int z=0; z<userList.length; z++){ 
        for(int h = 0; h < 480; h++){           //See all the pixels
         for(int w = 0; w < 640; w++){
           clickPosition = w + (h*640);        //We see which pixel we are working on
           if (userMap[clickPosition] != 0) {
             
               array2SQ [clickPosition] = 1;
               
               if(w < minSQ[z][0]){
                 minSQ[z][0] = int(w*reScale);
               }
               if(w > maxSQ[z][0]){
                 maxSQ[z][0] = int(w*reScale);
               }
               if(h < minSQ[z][1]){
                 minSQ[z][1] = int(h*reScale);
               }
               if(h > maxSQ[z][1]+5){
                 maxSQ[z][1] = int(h*reScale);
               } 
             }
             else array2SQ [clickPosition] = 0;
           }
        }
        
       for(int r=0; r<307200; r++){
          if(array1SQ[r] != array2SQ[r]){
            numSQ++;
          }
       }   
        
      movUpSQ = numSQ/4000;  
      if(movUpSQ < 1) movUpSQ = 1;
      println("MovUp:"+movUpSQ);      
      println("num:"+numSQ);
        for( int u=0; u<14; u++){
          int minS = int( u * width/14);
          int maxS =int( (u+1) * width/14);
          if(gravitySQ<1){gravitySQ=1;}
             if(minSQ[z][0]<maxS && minSQ[z][0]>minS && maxSQ[z][0]>maxS){
               if(posSQ[u][1]>-1){
                 posSQ[u][1]-= movUpSQ;
               }
             }
             else if(minSQ[z][0]<minS && maxSQ[z][0]>maxS){
               if(posSQ[u][1]>-1){
                 posSQ[u][1]-= movUpSQ;
               }
             }
             else if(minSQ[z][0]<minS && maxSQ[z][0]>minS && maxSQ[z][0]<maxS){
               if(posSQ[u][1]>-1){
                 posSQ[u][1]-= movUpSQ;
               }
             }
             else{
               if(posSQ[u][1] < height-width/14){
               posSQ[u][1] += speedSQ[u]/10;
               speedSQ[u] += gravitySQ;      
               println("Speed:"+speedSQ[u]);
               }
             }
        }
      }
    }
    
    filtroSQ();
    
    for(int r=0; r<307200; r++){
      array1SQ[r] = array2SQ[r];
    }
    numSQ = 0;
    
    for( int u=0; u<14; u++){
      image(square,posSQ[u][0],posSQ[u][1]);
    }
  }
}

void filtroSQ(){
  for( int u=0; u<14; u++){
    if(posSQ[u][1] < 0){
      posSQ[u][1] = 0;  
      speedSQ[u] = 1;      
    }    
    else if(posSQ[u][1] > height-(width/14)){
      posSQ[u][1] = height-(width/14); 
      speedSQ[u] = 1;     
    }
  }
}

