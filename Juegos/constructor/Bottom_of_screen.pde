void staticSquares(){
  int x = width-width/5;
  fill(255,0,0);
  rectMode(CORNER);
  rect(x,0,width,(height/6));
  fill(0,255,0);
  rectMode(CORNER);
  rect(x,(height/6),width,(height/3));
  fill(0,0,255);
  rectMode(CORNER);
  rect(x,(height/3),width,(height/2));
  fill(125,0,125);
  rectMode(CORNER);
  rect(x,(height/2),width,(4*height/6));
  fill(125,125,0);
  rectMode(CORNER);
  rect(x,(4*height/6),width,(5*height/6));
  fill(0,125,125);
  rectMode(CORNER);
  rect(x,(5*height/6),width,height);
}

void staticShapes(){  
  pushMatrix();
  fill(200);
  rectMode(CENTER);
  rect(width-width/10,height/12,width/10,height/12);
  fill(200);
  rectMode(CENTER);
  rect(width-width/10,3*height/12,height/12,width/10);
  fill(200);
  rectMode(CENTER);
  rect(width-width/10,5*height/12,height/12,height/12);
  fill(200);
  ellipseMode(CENTER);
  ellipse(width-width/10,7*height/12,height/12,height/12);
  fill(200);
  triangle(width-30-width/10,9+9*height/12,width+30-width/10,9+9*height/12,width-width/10,-18+9*height/12);
  popMatrix();
     
  star(width-width/10, 11*height/12, 0);
     
  pushMatrix();
  fill(255,0,0);
  ellipseMode(CENTER);
  ellipse(width-2.5*width/7,5+width/7-(5*movCircle),width/7,width/7);
  fill(255,0,0);
  ellipseMode(CENTER);
  ellipse(width-2.5*width/7,width/7,width/7,width/7);
  fill(200);
  rectMode(CENTER);
  rect(25+width/4,width/6,width/2,width/25);
  popMatrix();
}

void botones(PVector pos){
  float x = width-width/5;
  if(pos.x > x && pos.y < height/6){ shape = 1; }
  else if(pos.x > x && pos.y < height/3 && pos.y > height/6){ shape = 2; }
  else if(pos.x > x && pos.y < height/2 && pos.y > height/3){ shape = 3; }
  else if(pos.x > x && pos.y < (2*height/3) && pos.y > height/2){ shape = 4; }
  else if(pos.x > x && pos.y < (5*height/6) && pos.y > (2*height/3)){ shape = 5; }
  else if(pos.x > x && pos.y < height && pos.y > (5*height/6)){ shape = 6; }
}

void whiteSquares(){
  float x = width-width/5;
  switch(shape){
    case 0:      
      break;
    case 1:
      fill(255);
      stroke(0);
      rectMode(CORNER);
      rect(x,0,width,(height/6));
      break;
    case 2:
      fill(255);
      stroke(0);
      rect(x,(height/6),(width/5),(height/6));
      break;
    case 3:
      fill(255);
      stroke(0);
      rect(x,(height/3),(width/5),(height/6));
      break;
    case 4:
      fill(255);
      stroke(0);
      rect(x,(height/2),(width/5),(height/6));
      break;
    case 5:
      fill(255);
      stroke(0);
      rect(x,(4*height/6),(width/5),(height/6));
      break;
    case 6:
      fill(255);
      stroke(0);
      rect(x,(5*height/6),(width/5),(height/6));
      break;    
  }
  staticShapes();
}
