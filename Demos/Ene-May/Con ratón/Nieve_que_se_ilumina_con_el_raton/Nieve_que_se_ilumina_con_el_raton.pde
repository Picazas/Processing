
int[] nieveSueloX = new int[6]; 
int[] nieveSueloY = new int[6];
float[][] copos;
float[][] lights;    //{width,height}
float maxCount = 8;
int[] count;
int[] act;
int[] actL;
int num;


void setup(){
  size(700,500);
  background(0);
  num = width/2;
  copos = new float[num][2];
  lights = new float[num][2];
  count = new int[num];
  act = new int[num];
  actL = new int[num];
 
  for(int x=0; x<num; x++){
      lights[x][0] = 4;
      lights[x][1] = 2;
      copos[x][0] = 2*x;
      copos[x][1] = random(-height,-5);
      act[x] = 1;
      actL[x] = 0;
  }
}

void draw(){

  fill(0);
  rect(0,0,width,height);

  for(int x=0; x<num; x++){  

    if(act[x]==0 && actL[x]==0){
      lights[x][0] = 4;
      lights[x][1] = 2;
      copos[x][1] = random(-height,-5);
      count[x] = 0;
      act[x] = 1;
      actL[x] = 0;
    }
    
    if(act[x] == 1){
      fill(255);
      ellipseMode(CENTER);
      ellipse(copos[x][0],copos[x][1],5,5);
      copos[x][1]++;
    }
    
    if(actL[x] == 1){
      fill(255);
      ellipseMode(CENTER);
      ellipse(copos[x][0],copos[x][1],lights[x][0],lights[x][1]);
      lights[x][0]++;
      lights[x][1]++;
      count[x]++;
    }
    
    if(copos[x][1] > height + 10){
      act[x] = 0;
      actL[x] = 1;
    }
    else if(mouseX-3 < copos[x][0] && copos[x][0] < mouseX+3 && copos[x][1] > mouseY-3 && copos[x][1] < mouseY+3){
      act[x] = 0;
      actL[x] = 1;
    }

    if(count[x] > maxCount){
      actL[x] = 0;
    }
    
  }
}
