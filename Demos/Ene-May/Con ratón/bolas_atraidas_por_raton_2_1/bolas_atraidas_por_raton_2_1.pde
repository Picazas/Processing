//Al estarse el ratón quieto los cuerpos son atraidos por él, mientras que si está en 
//movimiento las particulas salen despedidas hacia las paredes. Las partículas son puntos
//negros. En comparación con la 2.0, en esta la fuerza es proporcional al moviemiento del 
//ratón.

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

PBox2D box2d;

PVector now = new PVector(0,0,0);
PVector before = new PVector(0,0,0);
ArrayList<Boundary> boundaries;
ArrayList<Particle> particles;
int count = 0;

void setup() {
  size(640,360);
  smooth();

  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  particles = new ArrayList<Particle>();
  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(width/2,0,width,10));
  boundaries.add(new Boundary(0,height/2,10,height));
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  
  for(int r=0; r<250; r++){
    Particle p = new Particle(random(width),random(height),2);
    particles.add(p);
  }
  
}

void draw() {
  background(255);
  box2d.step();
  
  now.x = mouseX;
  now.y = mouseY;
  
  if ((before.x-now.x)==0 || (before.y-now.y)==0) {
    for (Particle b: particles) {
      b.attract(now.x,now.y);
    }
  }
  else{
    int r = 0;
    float dx = abs(before.x-now.x);
    float dy = abs(before.y-now.y);
    for (Particle b: particles) {
        r++;
        int x = int(r/65);
        switch(x){
          case 0:
            b.moveAway(random(0,width),0,dx,dy);
            break;
          case 1:
            b.moveAway(random(0,width),height,dx,dy);
            break;
          case 2:
            b.moveAway(0,random(0,height),dx,dy);
            break;
          case 3:
            b.moveAway(width,random(0,height),dx,dy);
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
  
  if(count == 5){
    before.x = now.x;
    before.y = now.y;
    count = 0;
  }
  else count++;
}




