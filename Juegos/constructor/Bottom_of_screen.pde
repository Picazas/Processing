void staticF(){
  fill(255,0,0);
  rect(width-width/5,0,width,height/6);
  fill(0,255,0);
  rect(width-width/5,height/6,width,height/3);
  fill(0,0,255);
  rect(width-width/5,height/3,width,height/2);
  fill(125,0,125);
  rect(width-width/5,height/2,width,4*height/6);
  fill(125,125,0);
  rect(width-width/5,4*height/6,width,5*height/6);
  fill(0,125,125);
  rect(width-width/5,5*height/6,width,height);
  
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
     
  star();
     
  fill(255,0,0);
  ellipseMode(CENTER);
  ellipse(width-2.5*width/7,5+width/7,width/7,width/7);
  fill(255,0,0);
  ellipseMode(CENTER);
  ellipse(width-2.5*width/7,width/7,width/7,width/7);
  fill(200);
  rect(25+width/4,width/6,width/2,width/25);
}
