void setup(){
  size(4000, 4000);
  background(240);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
}

void mousePressed(){
  save("tree.png");
}

void draw(){
  tree(width / 2, height / 1.1, 600, 0.0, 50);
  noLoop();
}

void tree(float x, float y, float length, float angle, float brightness){
  float x2 = x - (length * sin(angle));
  float y2 = y - (length * cos(angle));

  strokeWeight(length / 25);
  stroke(120 - length, 60, brightness, length * 10);
  line(x, y, x2, y2);
  
  if(length > 50){    
  // smaller tree to the left
  tree(x2, y2, length * random(0.7, 0.9), angle + random(0.1, 0.4), brightness + random(-10, 10));
  // smaller tree to the right
  tree(x2, y2, length * random(0.7, 0.9), angle - random(0.1, 0.4), brightness + random(-10, 10)); 
  tree((x+x2) / 2, (y + y2) / 2, length * random(0.7, 0.9), angle + random(-0.4, 0.4), brightness + random(-10, 10));
  } 
}
