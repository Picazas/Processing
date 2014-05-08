
int ax=335;
int ay=257;
float lado=40;
float alto=200;

void setup()  {
  size(650, 650, P3D);
  noStroke();
  fill(204);
}

void draw()  {
  background(0);
  lights();

  alto=mouseX;
  leftSide();   
  rightSide();
      
  println("X"+ax);
  println("Y"+ay);
  
  if(keyPressed){
    if(key=='a'){ax++;}
    if(key=='s'){ay++;}
  }
}

void leftSide(){
  pushMatrix();
  translate(width/2,height*4/5,-200);
  for(int q=6; q>0; q--){
    for(int r=0; r<q+1; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(-ay)); 
      fill(0,100+r*25,0);
      translate(lado*(r-q+6), -alto*r/12, -lado*6/10-lado*q);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
  }
  popMatrix();
 
}

void rightSide(){
  pushMatrix();
  translate(width/2,height*4/5,-200);
  for(int q=6; q>0; q--){
    for(int r=0; r<q+1; r++){
      pushMatrix();
      rotateX(radians(ax)); 
      rotateY(radians(ay)); 
      fill(0,100+r*25,0);      
      translate(-lado*(r-q+6),-alto*r/12, -lado*6/100-lado*q);
      box(lado,alto*r/6,lado);         
      popMatrix();
    }
  }
  popMatrix();
 
}
