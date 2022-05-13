int total = 1440;
int r;
ArrayList<Particle> particles = new ArrayList<Particle>();
Particle p;
color[] combo = {color(239, 50, 15, 80), color(240, 134, 14, 80), color(11, 52, 126, 80)};
 
 void mousePressed(){
  save("particleConnect.png"); 
 }
 
void setup() {
  fullScreen(P3D);
  blendMode(ADD);
  colorMode(RGB, 255, 255, 255, 100);
  frameRate(165);
  smooth(8);

  for(int i = 0; i < total; i++){
    r = (int) random(30, 200);
    float x = r * cos(i);
    float y = r * sin(i);
    particles.add(new Particle(new PVector((width / 2) + x ,(height / 2) + y), i));
  }

}
 
void draw() {
  background(24, 24, 24, 100);
  
  for(int i = particles.size() - 1; i >= 0; i--){
    p = particles.get(i);
    for(int y = particles.size() - 1; y >= 0 ; y--){
      p.connect(particles.get(y));
    }
    p.applyForce(new PVector(random(-0.1, 0.1), random(-0.1, 0.1)));
    p.run();
    
    if(particles.size() < total + 100){
      r = (int) random(30, 200);
      float x = r * cos(i);
      float y = r * sin(i);
      particles.add(new Particle(new PVector((width / 2) + x ,(height / 2) + y), i));
    }

    if(p.isDead()){
      particles.remove(i);
    }
  }
  
  //saveFrame("pc-######.png");
}
 
 
class Particle {
  PVector pos, vel, acc;
  float lifespan;
  int i;
  color myc;
 
  Particle(PVector l_, int index) {
    i = index;
    float velx = l_.x - width / 2;
    float vely = l_.y - height / 2;
    acc = new PVector(velx, vely).normalize().mult(0.1);
    vel = new PVector(velx, vely).normalize().mult(2.5);
    pos = l_;
    lifespan = 255.0;
    myc = combo[int(random(3))];
  }

  void run() {
    update();
    acc.mult(0);
  }
 
  void update() {
    vel.add(acc);
    pos.add(vel);
    lifespan -= random(0.5, 3);
  }
  
  void connect(Particle p_){
    float distance = pos.dist(p_.pos);
    float ld = map(lifespan, 255, 0, 15, 60);
    if(distance < ld && p_.pos != pos){
      stroke(myc);
      strokeWeight(1.5);
      line(pos.x, pos.y, p_.pos.x, p_.pos.y);
    }
  }
  
  void applyForce(PVector f_){
    acc.add(f_);
  }
 
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
