

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
      pushMatrix();
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
      popMatrix();
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
  
    background(255);
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

//////////////////////////////////////  STRANDS  ////////////////////////////////////////////

void threads(int[] userList){
  
  if( countScene > time){
    ending();    
  }
  else if(end[scene]==1 || control == 1){
    ending();
  }
  else{  
    /*fill(0,0,0,35);
    rect(0,0,2*width,2*height);*/
    background(0);
       
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

