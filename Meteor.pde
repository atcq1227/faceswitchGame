class Meteor {
  int x;
  int y;
  
  float velocity;
  
  PImage img;
  
  boolean isTouching;
  
  Meteor(int x, int y, float velocity) {
    this.x = x;
    this.y = y;
    this.velocity = velocity;
    
    this.img = loadImage("meteor.png");
    
    img.resize(50, 50);
    
    imageMode(CENTER);
  }
  
  void illustrate() {
    image(img, x, y);
  }
  
  void move() {
    y += velocity;
  } 
  
  boolean isTouching(int x, int y) {
    return x == this.x && y == this.y;
  }
  
  int getX() {
    return x;
  }
  
  int getY() {
    return y;
  }
}