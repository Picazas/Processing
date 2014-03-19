
PImage f1, f2, f3, f4, f5, f0;
int[][] pos = new int [6][3]; //Position in {x,y,z}
int[][] posf = new int [6][3]; //Final position in {x,y,z}
int[][] vel = new int[6][3]; //How quickly they go
int[] act = new int[6];
int count = 0;
int z = 1;
float[] escala = new float [6];


void setup(){
  size(700,500,P3D);
  background(0);
  f0 = loadImage ("cara1SF.png");
  f1 = loadImage ("cara2SF.png");
  f2 = loadImage ("cara3SF.png");
  f3 = loadImage ("cara4SF.png");
  f4 = loadImage ("cara5SF.png");
  f5 = loadImage ("cara6SF.png");
  
  for (int i = 0; i < 6; i++) {
    for(int r=0; r<3; r++){
      pos[i][r]=0;
      posf[i][r]=0;
      vel[i][r]=0;
      act[i]=0;
      escala[i]=0;
    }
  }
}

void draw(){
  println(count);
  background(0);
  
  for (int w = 0; w < 6; w++) {
    if(count == 80*w){
      if(act[w]==0){
        act[w] = 1;
        pos[w][0]= width/2;
        pos[w][1]= height/2;
        pos[w][2]= -300;
        vel[w][0] = int(random(-3,3));
        vel[w][1] = int(random(-3,3));
        vel[w][2] = int(random(6,10));
        escala[w] = random(0.1,1.1);
      }
    }
  
    if(act[w] == 1){
      pushMatrix();
      scale(escala[w]);
      imageMode(CENTER);
      translate(0,0,pos[w][2]);
      pos[w][0] += vel[w][0]; 
      pos[w][1] += vel[w][1];
      pos[w][2] += vel[w][2];
      switch(w){        
        case 0: image(f0,pos[w][0],pos[w][1]); break;
        case 1: image(f1,pos[w][0],pos[w][1]); break;
        case 2: image(f2,pos[w][0],pos[w][1]); break;
        case 3: image(f3,pos[w][0],pos[w][1]); break;
        case 4: image(f4,pos[w][0],pos[w][1]); break;
        case 5: image(f5,pos[w][0],pos[w][1]); break;        
      }
      popMatrix();
    }
    if(pos[w][0] < -50 || pos[w][0] > width+50 || pos[w][1] < -50
    || pos[w][1] > height+50 /*|| pos[w][2] > 0*/){
      for(int r=0; r<3; r++){
        pos[w][r]=0;
        posf[w][r]=0;
        vel[w][r]=0;
        act[w]=0;
        escala[w]=0;
      }        
    }          
  }
  count++; 
  if (count==482){  count=0; }
}
