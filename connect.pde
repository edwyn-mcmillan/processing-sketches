OpenSimplexNoise noise;
int orbitNum = 250;
float nOffset = 0.0;
float mOffset = 20000.0;
float inc = 100;

Orbit[] bodies = new Orbit[orbitNum];

void mousePressed(){
  noLoop();
  save("connect.png");
}

void setup() {
  size(1920, 1920);
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 0);
  smooth(8);
  noise = new OpenSimplexNoise();

  for (int i = 0; i < orbitNum; i++) {
    float randomX = map(noise(nOffset), 0, 1, 0, width);
    float randomY = map(noise(nOffset + 20000), 0, 1, 0, height);
    bodies[i] = new Orbit(randomX, randomY, i);
    nOffset += inc;
  }
}

void draw() {

  for (int i = 0; i < orbitNum; i++) {
    bodies[i].update();
    bodies[i].display();

    for (int j = 0; j < orbitNum; j++) {
      if(bodies[i].id != bodies[j].id){
        PVector offset = bodies[j].oPos;
        float r = bodies[j].r;
        float theta = bodies[j].theta;
        bodies[i].connectPoints(offset, r, theta);
      }      
    }
  }
}

class Orbit {

  PVector oPos, pos;
  float r, theta, vel, acc;
  boolean direction;
  int ld;
  int id;
   
  Orbit(float x_, float y_, int id_) {
    oPos = new PVector(x_, y_);
    pos = new PVector(x_, y_);
    ld = (int) random(50, 150);
    id = id_;

    if (randomGaussian() > 0) {
      direction = true;
    } else {
      direction = false;
    }

    r = map(randomGaussian(), -1, 1, 20, 500);
    theta = 0;
    vel = 0;
    acc = random(0.0009, 0.004);
  }

  void update() {
    if (direction) {
      vel += acc;
    } else {
      vel -= acc;
    }
    theta += vel;
    vel = 0;
  }

  void display() {
    stroke(200, 80, 80, 1);
    pos.x = oPos.x + (r * cos(theta));
    pos.y = oPos.y + (r * sin(theta));
  }

  PVector getCoords() {
    float gx = oPos.x + r * cos(theta);
    float gy = oPos.y + r * sin(theta);
    return new PVector(gx, gy);
  }

  void connectPoints(PVector offset_, float r_, float theta_) {

    PVector nPos = new PVector();
    nPos.x = offset_.x + (r_ * cos(theta_));
    nPos.y = offset_.y + (r_ * sin(theta_));

    float distance = pos.dist(nPos);
    if (distance < ld) {
      float alpha = map(distance, ld, 0, 0.01, 2);
      blendMode(ADD);
      stroke(frameCount % 360, 100, 100, alpha);
      strokeWeight(1.5);
      line(pos.x, pos.y, nPos.x, nPos.y);
    }
  }
}
