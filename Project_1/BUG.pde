class BUG {
  PVector position;
  float bugSize;
  float initialBugSize;
  float speed;
  float initialSpeed;
  PVector target;
  boolean isColliding;
  boolean alive;
  boolean consumed;
  boolean hasReproduced;
  int collisionTimer;
  int age;
  int lifespan;

  color fillOrig = CYAN;
  color fillHit = YELLOW;
  color fillNow = MAGENTA;

  BUG() {
    position = new PVector(random(RESOLUTIONX - 128), random(RESOLUTIONY -128), random(0,256));
    initialSpeed = 0.005 * random(1, 5);
    initialBugSize = random(32, 64);
    bugSize = initialBugSize;
    speed = initialSpeed;
    target = new PVector(random(-RESOLUTIONX + RESOLUTIONX) + RESOLUTIONX, random(-RESOLUTIONY, RESOLUTIONY) + RESOLUTIONY, random(512) + 256);
    isColliding = false;
    collisionTimer = 50;
    alive = true;
    consumed = false;
    age = 0;
    lifespan = 256;
    hasReproduced = true;
  }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// RANDOM SPAWN
    BUG(int lifespanLowerLimit, int lifespanUpperLimit, float speedLowerLimit, float speedUpperLimit, float bugSizeLowerLimit, float bugSizeUpperLimit) {
    position = new PVector(random(RESOLUTIONX - 128), random(RESOLUTIONY -128), random(0,256));
    initialSpeed = 0.005 * random(speedLowerLimit, speedUpperLimit);
    initialBugSize = random(bugSizeLowerLimit, bugSizeUpperLimit);
    bugSize = initialBugSize;
    speed = initialSpeed;
    
    target = new PVector();
    if(position.x >= (RESOLUTIONX/2)){
      target.x = random(-RESOLUTIONX, 0);
    }
    else {
      target.x = random(RESOLUTIONX, RESOLUTIONX*2);
    }
    if(position.y >= (RESOLUTIONY/2)){
      target.z = random(-RESOLUTIONY, 0);
    }
    else {
      target.y = random(RESOLUTIONY, RESOLUTIONY*2);
    }
    if(position.z >= 128){
      target.z = random(-256, 0);
    }
    else {
      target.z = random(256, 512);
    }
    
    isColliding = false;
    collisionTimer = 50;
    alive = true;
    consumed = false;
    age = 0;
    lifespan = (int)random(lifespanLowerLimit, lifespanUpperLimit);
    hasReproduced = true;
  }  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// SPECIFIED SPAWN
  BUG(float _x, float _y, float _z, int lifespanLowerLimit, int lifespanUpperLimit, float speedLowerLimit, float speedUpperLimit, float bugSizeLowerLimit, float bugSizeUpperLimit) {
    position = new PVector(_x, _y, _z);
    initialSpeed = 0.005 * random(speedLowerLimit, speedUpperLimit);
    initialBugSize = random(bugSizeLowerLimit, bugSizeUpperLimit);
    bugSize = initialBugSize;
    speed = initialSpeed;
    
    target = new PVector();
    if(position.x >= (RESOLUTIONX/2)){
      target.x = random(-RESOLUTIONX, 0);
    }
    else {
      target.x = random(RESOLUTIONX, RESOLUTIONX*2);
    }
    if(position.y >= (RESOLUTIONY/2)){
      target.y = random(-RESOLUTIONY, 0);
    }
    else {
      target.y = random(RESOLUTIONY, RESOLUTIONY*2);
    }
    if(position.z >= 128){
      target.z = random(-256, 0);
    }
    else {
      target.z = random(256, 512);
    }
    
    isColliding = false;
    collisionTimer = 50;
    alive = true;
    consumed = false;
    age = 0;
    lifespan = (int)random(lifespanLowerLimit, lifespanUpperLimit);
    hasReproduced = true;
  }
  
  void update() {
    if(alive){
      position.x = position.x + target.x * speed;
      position.y = position.y + target.y * speed;
      position.z = position.z + target.z * speed;
      
      
      if(position.x > RESOLUTIONX - (bugSize + 128)) {
        if(target.x >= 1) {
          target.x = random(-RESOLUTIONX, 0);
        }
      }
      else if (position.x < (bugSize +128)){
        if(target.x < 1) {
           target.x = random(RESOLUTIONX, RESOLUTIONX * 2);
        }
      }
     /////////////////////////////////////////////////Y
      if(position.y > RESOLUTIONY - (bugSize + 128)) {
        if(target.y >= 1) {
          target.y = random(-RESOLUTIONY, 0);
        }
      }
      else if (position.y < (bugSize +128)){
              if(target.y < 1) {
          target.y = random(RESOLUTIONY, RESOLUTIONY*2);
        }
      }
      ////////////////////////////////////////////////Z
      if(position.z > 256){
        if(target.z >= 1) {
          target.z = random(-256, 0);
        }
      }
      else if(position.z < 0) {
        if(target.z <= 1) {
          target.z = random(256, 512);
        }
      }
      
      ///////////////////////////////////////////////Collision Handling
      if (isColliding && collisionTimer > 0) {
        fillNow = fillHit;
        collisionTimer--;
      } 
      else {
        isColliding = false;
        fillNow = fillOrig;
      }
      ageing();
    }
    
  }
  
  void draw() {
    noFill();
    stroke(fillNow);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(bugSize);
    popMatrix();
  }

  void run() {
    update();
    draw();
  }

  void ageing(){
    if(alive) {
      age++;
      speed = lerp(initialSpeed, 0, ((((float)age)/((float)lifespan)))); //as it gets older, it becomes slower
      bugSize = lerp(initialBugSize, 8, ((((float)age)/((float)lifespan)))); //as it gets older, it becomes smaller
      fillOrig = lerpColor(CYAN, BLACK, ((((float)age)/((float)lifespan)))); //as it ages, it turns dark
    }
    if(age > lifespan){
      alive = false;
    }
    if(consumed){
      fillNow = RED;
    }
  }

  boolean isAlive() {
    return alive;
  }

  PVector position() {
    return position;
  }

  PVector target(){
    return target;
  }

  float getSize() {
    return bugSize;
  }

  int getAge() {
    return age;
  }

  void setCollision() {
    if(alive){
      hasReproduced = false;
      isColliding = true;
      collisionTimer = 100;
    }
    else {
      consumed = true;
    }
  }

  boolean inCollision() {
    return isColliding;
  }
  
  boolean reproduction() {
    if(!hasReproduced){
      hasReproduced = true;
      return false;
    }
    else{
      return hasReproduced;
    } 
  }
  
  boolean hasBeenConsumed() {
    return consumed;
  }
  
  void consumed() {
    lifespan = lifespan * 2; 
  }
}
