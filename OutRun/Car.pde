class Car {
  
  int speed = 0;
  int[] pos = {-80, 0, 80};
  int posIdx;
  
  // Contructor
  Car() {
    posIdx = int(random(3));
  }
  
  // Custom method for updating the variables
  void update() {
    speed -= 4;
  }
  
  // Custom method for drawing the object
  int[] display() {
    int posY = -300-speed;
    stroke(255);
    fill(0,70,25);
    pushMatrix();
    translate(pos[posIdx], posY, 5);
    box(40, 50, 10);
    popMatrix();
    int[] vec = {pos[posIdx], posY};
    return vec;
  }
}
