int num = 0;
int curvePoints = 140;
int lines = 21;
int lineH, lineW;

Walker[] endpoints = new Walker[lines * 2];
Walker[][] controls = new Walker[lines][curvePoints];

float cx1, cy1;
float t1 = 0.0;
float t2 = 1000.0;
float inc = 0.1;

void mousePressed(){
  noLoop();
  save("spuriousSplines.png");
}

void setup() {
  size(1920, 1920);
  colorMode(RGB, 255, 255, 255, 100);
  background(24, 24, 24);
  smooth(8);
  noFill();
  
  lineH = height / lines;
  lineW = width / curvePoints;
  
  for(int j = 0; j < lines; j++){
    float lmt = random(1, 20);
    endpoints[j] = new Walker(lineW, lineH * j + lineH, lmt);
    endpoints[j + lines] = new Walker(width - lineW, lineH * j + lineH, lmt);
    for(int i = 0; i < curvePoints; i++){   
      float x = lineW * i + lineW;
      float y = lineH * j + lineH;
      controls[j][i] = new Walker(x, y, lmt);
    }
  }  
}


void draw() {
  for(int j = 0; j < lines - 1; j++){
    float n1 = noise(t1);
    float n2 = noise(t2);
    beginShape();
    endpoints[j].update(n1, n2, 1);
    endpoints[j].display(false);
    curveVertex(endpoints[j].pos.x, endpoints[j].pos.y);
    for(int i = 0; i < curvePoints; i++){
      cx1 = controls[j][i].pos.x;
      cy1 = controls[j][i].pos.y;
      n1 = noise(t1);
      n2 = noise(t2);
      controls[j][i].update(n1, n2, i);
      controls[j][i].display(true); 
      curveVertex(cx1, cy1);
      t1 += inc;
      t2 += inc;
    }
    curveVertex(endpoints[j + lines].pos.x, endpoints[j + lines].pos.y);
    endpoints[j + lines].update(n1, n2, 1);
    endpoints[j + lines].display(false);
    endShape();
  }
  
  t1 += inc;
  t2 += inc; 
}


class Walker{
  
  PVector pos, vel;
  Float lmt;
  
  Walker(float x_, float y_, float lmt_){
    pos = new PVector(x_, y_);  
    lmt = lmt_;
  }
  
  void update(float n1_, float n2_, int i_){
    float i = map(i_, 0, curvePoints, 5, 70);
    float n1 = n1_;
    float n2 = n2_;
    float x = map(n1, 0, 1, -0.06 * i, 0.07 * i);
    float y = map(n2, 0, 1, -0.088 * i, 0.1 * i);
    vel = new PVector(x, y);
    vel.limit(lmt);
    pos.add(vel);
  }
  
  void display(boolean target){
    if(target){
      strokeWeight(1);
      stroke(255, 255, 245, 5);
    }
  }
}
