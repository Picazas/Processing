class Star{
  
  Body body;
  
  Star(float x,float y){
     makeBody(new Vec2(x, y));
  }

   void makeBody(Vec2 center) {

    Vec2[] vertices = new Vec2[10];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(0, 23.66));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(5, 8.66));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(20.81, 8.66));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(8, -0.5));
    vertices[4] = box2d.vectorPixelsToWorld(new Vec2(8, -15));
    vertices[5] = box2d.vectorPixelsToWorld(new Vec2(0, -10));
    vertices[6] = box2d.vectorPixelsToWorld(new Vec2(-8, -15));
    vertices[7] = box2d.vectorPixelsToWorld(new Vec2(-8, -0.5));
    vertices[8] = box2d.vectorPixelsToWorld(new Vec2(-20.81, 8.66));
    vertices[9] = box2d.vectorPixelsToWorld(new Vec2(-5, 8.66));

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape ps = new PolygonShape();
    ps.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    body.createFixture(ps, 1.0);


    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);  //Take the body's position 
    float a = body.getAngle();                //Take the angle from the body
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();
 
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    
    fill(175);
    beginShape();
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }
  
  void killBody(){
    box2d.destroyBody(body);
  }
  
}
