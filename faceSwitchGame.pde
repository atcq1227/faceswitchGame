import processing.video.*;

final String SUBJECT = "Matt";

Meteor meteor;

float meteorVelocity = 1;

color backgroundColor = 255;

PImage img;

PImage explosion;

int currentKey;

int lives = 5;

int score = 0;

int state = 0;

int frame = 0;

Capture cap;

String command;

JSONObject json;

int time = 0;

int tasks = 1;

void setup() {
  size(800,800);
  
  json = new JSONObject();
  
  json.setString("Subject", SUBJECT);
  
  meteor = new Meteor(int(random(10, width - 10)), 10, meteorVelocity);
  
  img = loadImage("earth-curve.png");
  img.resize(width + 70, 122);
  
  explosion = loadImage("explosion.gif");
  explosion.resize(50,50);
  
  //String[] cameras = cap.list();
  
  cap = new Capture(this, 320, 240, 30);
  
  cap.start();
  
  generateNewCurrentKey();
  
  println(currentKey);
}

void draw() {
  if(state == 0) {
    drawSplash();
  }
  
  else if(state == 1) {
    playGame();
  }
  
  else if(state == 2) {
    saveJSONObject(json, "data/" + SUBJECT + ".json");
    drawGameOver();
  }
  
  if(keyPressed) {
    if(key == 'e') {
      state = 2;
    }
  }
}

void captureEvent(Capture cap) {
  cap.read();
  
  if(frame % 6 == 0) {
    set(0,0,cap);
    saveFrame("data/image" + frame + ".jpg");
  }
  
  frame++;
}

boolean isTouching() {
  boolean isTouching = false;
  
  loadPixels();
  
  if(!(pixels[int(meteor.getX()) + int((meteor.getY() + 25)) * width] == -1) && meteor.getY() > width/2 + 50) {
    isTouching = true;
  }
  
  return isTouching;
}

boolean isDestroyed() {
  
  if(keyPressed) {
    if(key == CODED) {
      return keyCode == currentKey;
    }
    
    else {
      return key == currentKey;
    }
  }
  
  else if(mousePressed) {
    return currentKey == 1;
  }
  
  else {
    return false;
  }
  
}

void spawnNew() {
  meteor = new Meteor(int(random(25, width - 25)), 25, meteorVelocity);
}

void generateNewCurrentKey() {
  
  float rand = random(0,4);
  
  println(rand);
  
  if(rand < 1) {
    currentKey = 33;
    command = "OPEN MOUTH";
  }
  
  else if(rand < 2) {
    currentKey = 34;
    command = "RAISE EYEBROWS";
  }
  
  else if(rand < 3) {
    currentKey = 123;
    command = "SMILE";
  }
  
  else {
    currentKey = 1;
    command = "SNARL";
  }
  
}

void drawExplosion(int x, int y) {
  image(explosion, x, y);
}

void displayText() {
  fill(0);
  textSize(24);
  text("score: " + score, 50, 50);
  
  text("lives: " + lives, width - 150, 50);
  
  textSize(32);
  text(command, width / 2 - 100, height / 2);
}

void drawSplash() {
  background(255);
  
  fill(0);
  textSize(36);
  text("Save The Earth: With Your Face Edition", 50, height/2);
  textSize(24);
  text("Press any key to begin", width/3, height/2 + 100);
  
  if(keyPressed) {
    state = 1;
  }
}

void playGame() {
  background(backgroundColor);
  
  displayText();
  
  meteor.illustrate();
  meteor.move();
  
  imageMode(CENTER);
  image(img, width/2, height - 60);
  
  if(isTouching()) {
    spawnNew();
    lives--;
  }
  
  if(isDestroyed()) {
    meteorVelocity += 0.2;
    score++;
    
    json.setString("Command " + tasks, command);
    
    json.setInt("Time " + tasks, millis() - time); 
    
    time = millis();
    
    tasks++;
    
    generateNewCurrentKey();
    
    println(currentKey);
    
    spawnNew();
  }
  
  if(gameOver()) {
    state = 2;
  }
}

boolean gameOver() {
  return lives == 0;
}

void drawGameOver() {
  background(255);
  
  fill(0);
  textSize(36);
  text("Game over", 50, height/2);
  
  if(keyPressed) {
    lives = 5;
    score = 0;
    state = 1;
  }
}