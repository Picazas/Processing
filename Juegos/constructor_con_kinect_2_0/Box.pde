class Box  {

  Body body;
  float W, H;
 
  Box(float x,float y, float w, float h) {
//The location is initalized in the constructor via arguments
    W = w;
    H = h;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld (W/2);
    float box2dH = box2d.scalarPixelsToWorld (H/2);
    ps.setAsBox(box2dW,box2dH);
    
    FixtureDef fd = new FixtureDef();
    fd.shape=ps;
    fd.density = 5;
    fd.friction = 0.5;
    fd.restitution = 0.8;
    
    body.createFixture(fd);
  }
 
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);  //Take the body's position 
    float a = body.getAngle();                //Take the angle from the body
 
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    
//We draw the Box object using Processing’s rect() function.
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,W,H);
    popMatrix();
  }
  
  void killBody(){
    box2d.destroyBody(body);
  }
  
}
