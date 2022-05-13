int gridX = 9;
int gridY = 9;
int border = 20;
float gridW, gridH;

Cluster[] clusters = new Cluster[gridX * gridY];
int n = 0;

void mousePressed(){
  save("cluster.png");
}

void setup(){
  size(1080, 1080);
  colorMode(RGB, 255, 255, 255, 100);
  background(255, 255, 245);
  smooth(8); 
  strokeWeight(2);
  stroke(24, 24, 24);
  
  gridW = width / gridX;
  gridH = height / gridY;
  
  for(int y = 0; y < gridY; y++){
    for(int x = 0; x < gridX; x++){
      clusters[n] = new Cluster((gridW * x), (gridH * y));
      n++;
    }
  } 
}

void draw(){
  
  for(int i = 0; i < n; i++){
    clusters[i].display();  
  }  
  noLoop(); 
}


class Cluster{
  
  PVector[] endpoints = new PVector[10];
  PVector[] controlpoints = new PVector[10];
  PVector[] points = new PVector[10];
  float x, y;
  int lineSeg = 10;
  
  Cluster(float x_, float y_){
    x = x_;
    y = y_;
     
    for(int i = 0; i < 10; i++){
      endpoints[i] = new PVector(generateX(), generateY());
      controlpoints[i] = new PVector(generateX(), generateY());
      points[i] = new PVector(generateX(), generateY());
    }
    
    endpoints[0] = new PVector(random(border, (width / gridX) - border), random((height / gridY) / 2, (height / gridY) - border));
    endpoints[1] = new PVector(random(border, (width / gridX) - border), random(border, (height / gridY) / 2 - border));
  }
  
  void connectedLines(){
    
    //float ax1 = generateX();
    //float ay1 = generateY();
    //float ax2 = generateX();
    //float ay2 = generateY();
    
    //float bx1 = generateX();
    //float by1 = generateY();
    //float bx2 = generateX();
    //float by2 = generateY();

    //lineDivide(ax1, ay1, ax2, ay2, bx1, by1, bx1, by1);
    
    lineDivide(controlpoints[0].x, controlpoints[0].y, controlpoints[1].x, controlpoints[1].y, controlpoints[2].x, controlpoints[2].y, controlpoints[3].x, endpoints[3].y);
  }
  
  void lineDivide(float ax1_, float ay1_, float ax2_, float ay2_, float bx1_, float by1_, float bx2_, float by2_){
    for(int i = 0; i <= lineSeg; i++){
      float axstep = ax1_ + i * (ax2_ - ax1_) / lineSeg;
      float aystep = ay1_ + i * (ay2_ - ay1_) / lineSeg;
      float bxstep = bx1_ + i * (bx2_ - bx1_) / lineSeg;
      float bystep = by1_ + i * (by2_ - by1_) / lineSeg;
      stroke(89, 89, 89, 80);
      strokeWeight(1.1);
      line(axstep, aystep, bxstep, bystep);
      stroke(0);
    } 
  }
  
  void circles(int steps_){
    for(int i = 0; i < steps_; i++){
      noFill();
      strokeWeight(1.5);
      stroke(24, 24, 24);
      circle(points[i].x, points[i].y, random(4, 6));
      strokeWeight(1);
    }
  }
  
  void lines(int steps_){
    for(int i = 0; i < steps_; i++){
      if(random(1) < 0.9){
        strokeWeight(1.5);
        stroke(24, 24, 24, 80);
        line(controlpoints[i].x, controlpoints[i].y, controlpoints[i + 1].x, controlpoints[i + 1].y);
      } else {
        strokeWeight(8);
        stroke(24, 24, 24, 60);
        line(controlpoints[i].x, controlpoints[i].y, controlpoints[i + 1].x, controlpoints[i + 1].y);
        strokeWeight(2);
        stroke(0);
      }

      fill(24, 24, 24);
      if(i == 0) circle(controlpoints[i].x, controlpoints[i].y, 3);
      if(i == steps_ - 1) circle(controlpoints[i + 1].x, controlpoints[i + 1].y, 3);
      noFill();
    }
  }
  
  void curves(int steps_){
    strokeWeight(1.5);
    stroke(0);
    noFill();
    beginShape();
    curveVertex(endpoints[0].x, endpoints[0].y);
    for(int i = 0; i < steps_; i++){
      curveVertex(controlpoints[i].x, controlpoints[i].y);    
    }
    curveVertex(endpoints[1].x, endpoints[1].y);
    endShape();
 
    fill(24, 24, 24, 80);
    circle(endpoints[0].x, endpoints[0].y, 3);
    circle(endpoints[1].x, endpoints[1].y, 3);
    noFill();
  }
  
  float generateX(){
    return random(border, (width / gridX) - border);
  }
  
  float generateY(){
    return random(border, (height / gridY) - border);
  }
  
  void display(){
    pushMatrix();
    translate(x, y);
    connectedLines();
    if(random(1) <= 0.55){
      lines(int(random(6)));
    } else {
      if(random(1) > 0.3) curves(int(random(2, 4)));
    }
    circles(int(random(3)));
    popMatrix();
  }
  
}
