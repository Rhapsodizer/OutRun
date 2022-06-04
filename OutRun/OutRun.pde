PFont f; // initialize font object
PGraphics blur;

int cols, rows; // grid variables
int scale = 20; // dimension of the square grid unit

int w = 1000, h = 900; //dimensions 

float speed = 0; // grid speed
float speed_m = 0; // mountain speed

float[][] terrain; // terrain grid
int border = 20; // define the width of the valley

// Player positions array
int[] playerPos = {-80, 0, 80};
int posIdx = 1;

// Cars
int dim = 5;
Car[] cars;
int counter = -1;
boolean trig = false;
int elapsed = millis();
int score = 0;


void setup() {
  size(800, 600, P3D);
  
  // Set up font
  printArray(PFont.list());
  f = createFont("Verdana", 14);
  textFont(f);
  textAlign(LEFT);
  
  // Set up world grid
  cols = w/scale;
  rows = h/scale;
  
  // Set up mountains
  terrain = new float[cols][rows];
  // Set up cars
  cars = new Car[dim];
}

void draw(){
  // Set background
  background(0);
  setGradient(-800, -900, -1000, 3500, 1200, color(0,0,130), color(0,0,0));
  
  // Draw fps on screen
  fill(255);
  text("FPS: " + frameRate, 5, 20);
  // Draw score
  text("Score: " + score, width-100, 20);
  
  // Set speeds
  speed -= 4;
  if (speed<=-scale){
    speed=0;
  }
  speed_m -= 0.1;

  // Set perlin noise for mountains
  float y_offset = speed_m;
  for (int y = 0; y < rows; y++) {
    float x_offset = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(x_offset, y_offset), 0, 1, -50, 150);
      x_offset += 0.2;
    }
    terrain[border-1][y] = 0;
    terrain[cols-border+1][y] = 0;
    y_offset += 0.2;
  }

  // Sun
  noStroke();
  fill(255,100,25);
  pushMatrix();
  translate(width/2, height/2-100, -400);
  circle(0, 0, 400);
  popMatrix();
  
  // Translate and rotate world
  translate(width/2, height/2);
  rotateX(PI/2.2); 
  
  // Draw central grid
  stroke(217,25,255);
  pushMatrix();
  translate(-w/2, -h/2-speed);
  noFill();
  for (int y = 0; y < rows-1; y++) {
    for (int x = border-1; x < cols-border+1; x++) {
      rect(x*scale+1, y*scale+1, scale, scale);
    }
  }
  popMatrix();
  
  // Draw lateral mountains
  pushMatrix();
  translate(-w/2, -h/2-0.2);
  
  fill(0,0,200);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < border; x++) {
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = cols-border+1; x < cols; x++) {
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
  popMatrix();
  
  // Draw player
  fill(255);
  pushMatrix();
  translate(playerPos[posIdx], 380, 5);
  box(40, 50, 10);
  popMatrix();
  
  // Draw cars
  trigger();
  if (trig == true) {
    if(++counter == dim){
      counter = 0;
    }   
    cars[counter] = new Car();
    trig = false;
  }
  for (int i=0; i<dim; i++) {
    if (cars[i]!=null){
      cars[i].update();
      int[] collision = cars[i].display();
      // Check collision
      if (collision[0] == playerPos[posIdx] && collision[1]<380 && collision[1]>330) {
        score = 0;
      } 
      if (collision[0] != playerPos[posIdx] && collision[1]==400){
        score++;
      }
    }
  }
}

// Custom function for generating a gradient
void setGradient(int x, int y, int z, float w, float h, color c1, color c2) {
  noFill();
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, z, x+w, i, z);
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    if (posIdx > 0) {
      --posIdx;
    }
  }
  if (key == 'd' || keyCode == RIGHT) {
    if (posIdx < playerPos.length-1) {
      ++posIdx;
    }
  }
}

void trigger() {
  if (millis() > elapsed + int(random(1000, 2000))) {
    trig = true;
    elapsed = millis();
  }
}
