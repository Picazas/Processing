
int ax=687;
int ay=625;
float lado=40;
float alto=200;

void setup()  {
  size(720, 720, P3D);
  noStroke();
  fill(204);
}

void draw()  {
  background(0);
  lights();

  alto=mouseX;
  leftSide();   
      
  println("X"+ax);
  println("Y"+ay);
  
  if(keyPressed){
    if(key=='a'){ax++;}
    if(key=='s'){ay++;}
  }

}

void leftSide(){
  
  for(int q=6; q>0; q--){
    for(int r=0; r<q+1; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r-q+6), height/2, -lado*6/10-200-lado*q);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
  }
  /*
  for(int r=0; r<7; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*r, height/2, -lado*6/10-200);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
    for(int r=0; r<6; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r+1), height/2, -lado*6/10-200-lado);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
    for(int r=0; r<5; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r+2), height/2, -lado*6/10-200-lado*2);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
    for(int r=0; r<4; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r+3), height/2, -lado*6/10-200-lado*3);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
    for(int r=0; r<3; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r+4), height/2, -lado*6/10-200-lado*4);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
    for(int r=0; r<2; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);
      translate(width/2-lado*(r+5), height/2, -lado*6/10-200-lado*5);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100,0);
      translate(width/2-lado*6, height/2, -lado*6/10-200-lado*6);
      box(lado,0,lado);         
      popMatrix();*/
}
