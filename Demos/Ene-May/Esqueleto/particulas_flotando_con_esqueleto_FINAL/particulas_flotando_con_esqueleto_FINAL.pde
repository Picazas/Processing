
import SimpleOpenNI.*;
SimpleOpenNI kinect;

double visc, diff, vScale, velocityScale;
boolean vectors = false;
int oldMouseX = 1, oldMouseY = 1;
int numParticles;
int c = color(255);
int n;
float cellHeight; 
float cellWidth;
float  limitVelocity;
float[][] body = new float[5][2]; //{part of the body}{x,y}
float[][] oldBody = new float[6][2]; //{part of the body}{x,y}
//Parts of the body: Neck, Right hand, Left hand, Right foot, Left foot.
PVector jointPos = new PVector(0,0,0);
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;
int clickedDepth,clickPosition;
int maxValue=2500;
int count = 0;


Particle[] particles; 
Mov mov;

void setup() {
 
  size(1000,600, P2D);
  //frameRate(150);
  kinect= new SimpleOpenNI(this);
  reScale = (float) width / kinectWidth;
    
  if (kinect.isInit()==false){
   println("Nada de nada chato");
   exit();
   return; 
  }
  
  kinect.setMirror(true);
  kinect.enableDepth();
  kinect.enableUser();
 
  n = Mov.N;   //Number of triangles
  cellHeight = height / n;    //Size of each triangle
  cellWidth = width / n;
  
  mov = new Mov();
  numParticles = (int)pow(2, 16);      //2^16 = 65536 particles
  particles = new Particle[numParticles];
  visc = 0.00025f;
  diff = 0.03f;
  vScale = 3;
  velocityScale = vScale;  //Save the initial triangle scale
  vectors = true;
 
  limitVelocity = 200;
  
  for(int r=0; r<5; r++){
    body[r][0] = 0;
    body[r][1] = 0;
  }
 
  stroke(color(0));
  fill(color(0));
  
  initParticles();
}

void draw() {
  kinect.update();
  int[] depthValues = kinect.depthMap();  
  int[] userMap = kinect.userMap();
  int[] userList = kinect.getUsers();
  PImage cam = createImage(640,480,RGB);
  
  for(int i=0;i<userList.length;i++)
 {
   int userId = userList [i];
   
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
    jointPos.x = jointPos.x * reScale;
    jointPos.y = jointPos.y * reScale;
    if(jointPos.x != 0 && jointPos.y != 0){
      jointPos.x = (width/2) + (jointPos.x/2);
      jointPos.y = height-((height/2) + (jointPos.y/2));
    }
    if(jointPos.x >= width){jointPos.x = width-1;}
    else if(jointPos.x <= 0){jointPos.x = 1;}
    else if(jointPos.y >= height){jointPos.y = height-1;}
    else if(jointPos.y <= 0){jointPos.y = 1;}
    body[0][0] = jointPos.x;
    body[0][1] = jointPos.y;
    handleMouseMotion(jointPos,0); 
     
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos);
    println("RH1:"+jointPos);
    jointPos.x = jointPos.x * reScale;
    jointPos.y = jointPos.y * reScale;
    println("RH2:"+jointPos);
    if(jointPos.x != 0 && jointPos.y != 0){
      jointPos.x = (width/2) + (jointPos.x/2);
      jointPos.y = height-((height/2) + (jointPos.y/2));
    }
    println("RH3:"+jointPos);
    if(jointPos.x >= width){jointPos.x = width-1;}
    else if(jointPos.x <= 0){jointPos.x = 1;}
    else if(jointPos.y >= height){jointPos.y = height-1;}
    else if(jointPos.y <= 0){jointPos.y = 1;}
    body[1][0] = jointPos.x;
    body[1][1] = jointPos.y;
    handleMouseMotion(jointPos,1);
   
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPos);
    jointPos.x = jointPos.x * reScale;
    jointPos.y = jointPos.y * reScale;
    if(jointPos.x != 0 && jointPos.y != 0){
      jointPos.x = (width/2) + (jointPos.x/2);
      jointPos.y = height-((height/2) + (jointPos.y/2));
    }
    if(jointPos.x >= width){jointPos.x = width-1;}
    else if(jointPos.x <= 0){jointPos.x = 1;}
    else if(jointPos.y >= height){jointPos.y = height-1;}
    else if(jointPos.y <= 0){jointPos.y = 1;}
    body[2][0] = jointPos.x;
    body[2][1] = jointPos.y;
    handleMouseMotion(jointPos,2);
   
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,jointPos);
    jointPos.x = jointPos.x * reScale;
    jointPos.y = jointPos.y * reScale;
    if(jointPos.x != 0 && jointPos.y != 0){
      jointPos.x = (width/2) + (jointPos.x/2);
      jointPos.y = height-((height/2) + (jointPos.y/2));
    }
    if(jointPos.x >= width){jointPos.x = width-1;}
    else if(jointPos.x <= 0){jointPos.x = 1;}
    else if(jointPos.y >= height){jointPos.y = height-1;}
    else if(jointPos.y <= 0){jointPos.y = 1;}
    body[3][0] = jointPos.x;
    body[3][1] = jointPos.y;
    handleMouseMotion(jointPos,3);
   
    kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,jointPos);
    jointPos.x = jointPos.x * reScale;
    jointPos.y = jointPos.y * reScale;
    if(jointPos.x != 0 && jointPos.y != 0){
      jointPos.x = (width/2) + (jointPos.x/2);
      jointPos.y = height-((height/2) + (jointPos.y/2));
    }
    if(jointPos.x >= width){jointPos.x = width-1;}
    else if(jointPos.x <= 0){jointPos.x = 1;}
    else if(jointPos.y >= height){jointPos.y = height-1;}
    else if(jointPos.y <= 0){jointPos.y = 1;}
    body[4][0] = jointPos.x;
    body[4][1] = jointPos.y; 
    handleMouseMotion(jointPos,4); 
    
}
   
  background(0); 
  double dt = 1 / frameRate;
  mov.tick(dt, visc, diff); 
  vScale = velocityScale * 60. / frameRate;
  drawParticlesPixels();

}

public void handleMouseMotion(PVector a, int n) {
  a.x = max(1, a.x);      //take highest value, 1 or mouseX.
  a.y = max(1, a.y);
 
  float pointDx = a.x - oldBody[n][0];
  float pointDy = a.y - oldBody[n][1];
  int cellX = floor(a.x / cellWidth);
  int cellY = floor(a.y / cellHeight);
 
  mov.applyForce(cellX, cellY, pointDx, pointDy);
 
  oldBody[n][0] = a.x;
  oldBody[n][1] = a.y;
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
