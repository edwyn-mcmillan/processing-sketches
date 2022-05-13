int num = 0;
int gridCountX = 15;
int gridCountY = 15;
int maxnum = gridCountX * gridCountY;
int gridW, gridH;

OpenSimplexNoise noise;
float inc = 0.1;
float xoff = 0;
float zoff = 0;

Walker[][] walkers = new Walker[gridCountX][gridCountY];

void mousePressed(){
  noLoop();
  save("randomGrid.jpg");
}

void setup(){
  size(1080, 1080, P2D);
  colorMode(RGB, 255, 255, 255, 100);
  background(24, 24, 24);
  smooth(8);
  noise = new OpenSimplexNoise();
  
  gridW = width / gridCountX;
  gridH = height / gridCountY;
  
  for(int y = 0; y < gridCountY - 1; y++){
     for(int x = 0; x < gridCountX - 1; x++){
         int ox = (gridW * x) + gridW;
         int oy = (gridH * y) + gridH;                
         walkers[y][x] = new Walker(ox, oy);
         num++;
     }
  }  
}

void draw(){ 
  for(int y = 0; y < gridCountY - 1; y++){
    for(int x = 0; x < gridCountX - 1; x++){    
      float xvel = map(noise(xoff), 0, 1, -1, 1);
      float yvel = random(-1, 1);
      xoff += inc;

      walkers[y][x].update(xvel, yvel);
       
       // connect corners
       if(y == 0 && x == 0){
         walkers[y][x].lineToCorners(walkers[y + 1][x], walkers[y][x + 1]);
         walkers[y][x].applyForce(walkers[y + 1][x], walkers[y][x + 1]);
       } 
       if(y == 0 && x == (gridCountX - 2)){
         walkers[y][x].lineToCorners(walkers[y + 1][x], walkers[y][x - 1]);
         walkers[y][x].applyForce(walkers[y + 1][x], walkers[y][x - 1]);
       } 
       if(y == (gridCountY - 2) && x == 0){
         walkers[y][x].lineToCorners(walkers[y - 1][x], walkers[y][x + 1]);
         walkers[y][x].applyForce(walkers[y - 1][x], walkers[y][x + 1]);
       } 
       if(y == (gridCountY - 2) && x == (gridCountX - 2)){
         walkers[y][x].lineToCorners(walkers[y - 1][x], walkers[y][x - 1]);
         walkers[y][x].applyForce(walkers[y - 1][x], walkers[y][x - 1]);
       } 
       
       //connect edges
       if(y == 0 && x != 0 && x != (gridCountX - 2)){
         walkers[y][x].lineToCorners(walkers[y][x - 1], walkers[y][x + 1]);
         walkers[y][x].applyForce(walkers[y][x - 1], walkers[y][x + 1]);
       } 
       if(y == (gridCountY - 2) && x != 0 && x != (gridCountX - 2)){
         walkers[y][x].lineToCorners(walkers[y][x - 1], walkers[y][x + 1]);
         walkers[y][x].applyForce(walkers[y][x - 1], walkers[y][x + 1]);
       } 
       if(x == 0 && y != 0 && y != (gridCountY - 2)){
         walkers[y][x].lineToCorners(walkers[y - 1][x], walkers[y + 1][x]);
         walkers[y][x].applyForce(walkers[y - 1][x], walkers[y + 1][x]);
       } 
       if(x == (gridCountX - 2) && y != 0 && y != (gridCountY - 2)){
         walkers[y][x].lineToCorners(walkers[y - 1][x], walkers[y + 1][x]);
         walkers[y][x].applyForce(walkers[y - 1][x], walkers[y + 1][x]);
       } 
       
       // connect internal
       if(y > 0 && y < (gridCountY - 2) && x > 0 && x < (gridCountX - 2)){
         walkers[y][x].lineTo(walkers[y - 1][x], walkers[y + 1][x], walkers[y][x + 1], walkers[y][x - 1]);
         walkers[y][x].applyForceN(walkers[y - 1][x], walkers[y + 1][x], walkers[y][x + 1], walkers[y][x - 1]);
       }
    }
    zoff += inc;
  }
}

class Walker{
  
  PVector pos, vel;
  float xvel, yvel;
  
  Walker(int x_, int y_){
    pos = new PVector(x_, y_);
    xvel = 0.1;
    yvel = 0.1;
    vel = new PVector(xvel, yvel);
  }
  
  void update(float xvel_, float yvel_){
    PVector rnd = new PVector(xvel_, yvel_);
    rnd.mult(2);
    pos.add(rnd);
  }
    
  void applyForce(Walker w1, Walker w2){
    PVector meanVel = w1.vel.add(w2.vel);
    meanVel.div(2);
    meanVel.limit(1);
    pos.add(meanVel);
  }
  
  void applyForceN(Walker w1, Walker w2, Walker w3, Walker w4){
    PVector meanVel = w1.vel.add(w2.vel);
    meanVel = meanVel.add(w3.vel);
    meanVel = meanVel.add(w4.vel);
    meanVel.div(4);
    meanVel.limit(1);
    pos.add(meanVel);
  }
  
  void lineTo(Walker w1, Walker w2, Walker w3, Walker w4){
    blendMode(ADD);
    stroke(255, 1);
    strokeWeight(1);
    line(pos.x, pos.y, w1.pos.x, w1.pos.y);
    line(pos.x, pos.y, w2.pos.x, w2.pos.y);
    line(pos.x, pos.y, w3.pos.x, w3.pos.y);
    line(pos.x, pos.y, w4.pos.x, w4.pos.y);
  }
  
  void lineToCorners(Walker w1, Walker w2){
    blendMode(ADD);
    stroke(255, 1);
    strokeWeight(1);
    line(pos.x, pos.y, w1.pos.x, w1.pos.y);
    line(pos.x, pos.y, w2.pos.x, w2.pos.y);
  }
}
