int countX = 150;
int countY = 11;
int spaceSize = 12;
float gridW, gridH;
int frame = 0;

ArrayList<Word> words = new ArrayList<Word>();

OpenSimplexNoise noise;

void mousePressed(){
  save("splineWords.jpg");
}

void setup(){
  size(4000, 4000);
  colorMode(RGB, 255, 255, 255, 100);
  background(24, 24, 24, 100); 
  smooth(8);
  noise = new OpenSimplexNoise();
  gridH = height / countY;
  gridW = width / countX;
  
  for(int y = 0; y < countY; y++){
    int x = 0;
    while(x < countX){
      Word w = new Word(gridW * x, gridH * y, countX - x);
      words.add(w);
      x += w.wordLength + spaceSize;
    }
  }
  println("done");
}

void draw(){
}

class Word{
  ArrayList<PVector> vecs = new ArrayList<PVector>();
  ArrayList<PVector> offSetVecs = new ArrayList<PVector>();
  float x, y;
  int wordLength;
  
  Word(float x_, float y_, int remainingSlots){
    x = x_;
    y = y_;
    wordLength = (int) map(randomGaussian(), -1, 1, 3, 6);
    
    while(wordLength > remainingSlots && remainingSlots > 3){
      wordLength = (int) map(randomGaussian(), -1, 1, 3, 6);
    }
    
    if(wordLength < remainingSlots - 15){
      for(int i = 0; i < wordLength; i++){
        generateCharacterPoints(i + 1);
      }
      println("finished: generating character points");
      
      for(int i = 0; i < vecs.size() - 1; i++){
        pushMatrix();
        translate(x, y);
        lineBetween(i % (vecs.size() - 3));
        popMatrix();
      }
    }   
  }
    
  void generateCharacterPoints(int index){
    ArrayList<PVector> tempVecs = new ArrayList<PVector>();
    int radius = int(gridW + 90);
    int pointNum = (int) map(randomGaussian(), -1, 1, 4, 5);
    int n = 0;
    while(n < pointNum){
      float xoff = 82 * index;
      PVector center = new PVector((gridW / 2) * index + xoff, gridH / 2);
      float rndX = map(randomGaussian(), -1, 1, xoff + (gridW), xoff + (gridW * index) + gridW); 
      float yoff = random(-100, 100);
      float rndY = map(randomGaussian(), -1, 1, xoff + (yoff / 2), gridH - yoff); 
      //float rndX = map(noise(index * n), 0, 1, xoff + (gridW), xoff + (gridW * index) + gridW); 
      PVector controlP = new PVector(rndX, rndY);
      if(center.dist(controlP) <= radius){
        vecs.add(controlP);
        tempVecs.add(controlP);
        n++;
      }
    }
   
    for(int i = 0; i < tempVecs.size(); i++){
      PVector cp = tempVecs.get(i);
      float noiseX = noise(0 + i);
      float xoff = map(noiseX, 0, 1, -10, 10);
      float noiseY = noise(100 + i);
      float yoff = map(noiseY, 0, 1, -90, 90);
      offSetVecs.add(new PVector(cp.x + xoff, cp.y + yoff));
    }
  }
  
  void lineBetween(int num_){
    float t = 0; // t range = 0 - 1
    for(int i = 0; i < 100; i++){
      float x1 = curvePoint(vecs.get(num_).x, vecs.get(num_ + 1).x, vecs.get(num_ + 2).x, vecs.get(num_ + 3).x, t);
      float y1 = curvePoint(vecs.get(num_).y, vecs.get(num_ + 1).y, vecs.get(num_ + 2).y, vecs.get(num_ + 3).y, t);
      float x2 = curvePoint(offSetVecs.get(num_).x, offSetVecs.get(num_ + 1).x, offSetVecs.get(num_ + 2).x, offSetVecs.get(num_ + 3).x, t);
      float y2 = curvePoint(offSetVecs.get(num_).y, offSetVecs.get(num_ + 1).y, offSetVecs.get(num_ + 2).y, offSetVecs.get(num_ + 3).y, t);
      strokeWeight(2);
      stroke(255, 255, 254, 20);
      line(x1, y1, x2, y2);
      t += 0.01;
    }
    //String name = "sw" + frame + ".png";
    //saveFrame(name);
    //frame++;
  }
}
