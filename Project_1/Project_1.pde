// Defining constants

////////////// RESOLUTION /////////////
int RESOLUTIONX = 1024;
int RESOLUTIONY = 768;

////////////// COLORS ///////////////
// Black   #000000   (0,0,0)
color BLACK = color(0, 0 ,0);
// White   #FFFFFF   (255,255,255)
color WHITE = color(255, 255 ,255);
// Red   #FF0000   (255,0,0)
color RED = color(255, 0, 0);
// Lime   #00FF00   (0,255,0)
color LIME = color(0, 255, 0);
// Blue   #0000FF   (0,0,255)
color BLUE = color(0, 0 ,255);
// Yellow   #FFFF00   (255,255,0)
color YELLOW = color(255, 255 ,0);
// Cyan / Aqua   #00FFFF   (0,255,255)
color CYAN = color(0, 255 , 255);
// Magenta / Fuchsia   #FF00FF   (255,0,255)
color MAGENTA = color(255, 0 , 255);
// Silver   #C0C0C0   (192,192,192)
color SILVER = color(192, 192 , 192);
// Gray   #808080   (128,128,128)
color GREY = color(128, 128 ,128);
// Maroon   #800000   (128,0,0)
color MAROON = color(128, 0 ,0);
// Olive   #808000   (128,128,0)
color OLIVE = color(128, 128 ,0);
// Green   #008000   (0,128,0)
color GREEN = color(0, 128 ,0);
// Purple   #800080   (128,0,128)
color PURPLE = color(128, 0 , 128);
// Teal   #008080   (0,128,128)
color TEAL = color(0, 128 ,128);
// Navy   #000080   (0,0,128)
color NAVY = color(0, 0 ,128);

//////////////// Variables //////////////

PImage backGround;
BUG[] bugs;
int currentNumberOfBugs;
boolean init = false;


////////////////////////////////////////////
////////// USER PARAMETERS /////////////////
////////////////////////////////////////////
// These are a set of variables that the  //
// user can change to modify the behavior //
// of the "bugs" in our 3d space.         //
////////////////////////////////////////////
float PREDEFINED_SPAWN_X = 512;          // specify the specific spawn location of new bugs (x value)
float PREDEFINED_SPAWN_Y = 434;          // specify the specific spawn location of new bugs (y value)
float PREDEFINED_SPAWN_Z = 128;          // specify the specific spawn location of new bugs (z value)
boolean RANDOM_SPAWN = true;             // set this to false if you wish to use a specific spawn location, otherwise new spawns will occur at random locations
int LIFE_SPAN_LOWER_LIMIT = 250;         // specify the shortest possible life span of the bugs (reccomend not to go lower than 250)
int LIFE_SPAN_UPPER_LIMIT = 2500;        // specify the longest possible life span of the bugs (reccomended value is around 1000 ~ 2500)
float SPEED_LOWER_LIMIT = 5;             // specify the slowest possible speed of the bugs (reccomended value is 1~5)
float SPEED_UPPER_LIMIT = 10;            // specify the fastest possible speed of the bugs (reccomended value is around 5~10)
float BUG_SIZE_LOWER_LIMIT = 32;         // specify the smallest possible bug (reccomended around 32)
float BUG_SIZE_UPPER_LIMIT = 64;         // specify the largest possible bug (reccomended around 64)
int MAXIMUM_NUMBER_OF_BUGS = 20;         // specify the maximum number of bugs on screen (reccomend not exceeding 20)
int STARTING_NUMBER_OF_BUGS = 4;         //specify the amount of bugs to start with (reccomend 3)

////////////// SETUP ///////////////
void setup() {
   size(1024 , 768, P3D);
   noStroke();
   backGround = loadImage("https://upload.wikimedia.org/wikipedia/commons/3/3d/Beautiful_striking_leaves_wallpaper_top_down_view.JPG");
   lights();
   
   bugs = new BUG[STARTING_NUMBER_OF_BUGS];
   currentNumberOfBugs = STARTING_NUMBER_OF_BUGS;

   for (int i=0; i<bugs.length; i++) {
     if(RANDOM_SPAWN) {
       bugs[i] = new BUG(LIFE_SPAN_LOWER_LIMIT, LIFE_SPAN_UPPER_LIMIT, SPEED_LOWER_LIMIT, SPEED_UPPER_LIMIT, BUG_SIZE_LOWER_LIMIT, BUG_SIZE_UPPER_LIMIT);
     }
     else{
       bugs[i] = new BUG(PREDEFINED_SPAWN_X, PREDEFINED_SPAWN_Y, PREDEFINED_SPAWN_Z, LIFE_SPAN_LOWER_LIMIT, LIFE_SPAN_UPPER_LIMIT, SPEED_LOWER_LIMIT, SPEED_UPPER_LIMIT, BUG_SIZE_LOWER_LIMIT, BUG_SIZE_UPPER_LIMIT);
     }
   }
}


void draw() {
  background(backGround);

  for (int i=0; i<currentNumberOfBugs; i++) {
    bugs[i].run();
    if(i > 0){
      if(collisionCheck(bugs[i-1], bugs[i])){
        if(bugs[i-1].reproduction() != true && bugs[i].reproduction() != true){
          bugs = reproduce(bugs);
        }
      }
      if(bugs[i].hasBeenConsumed()){
        bugs = consume(bugs);
      }
    }
  }
}


boolean collisionCheck (BUG bug1, BUG bug2){
  float x1 = abs(bug1.position.x);
  float y1 = abs(bug1.position.y);
  float z1 = abs(bug1.position.z);

  float x2 = abs(bug2.position.x);
  float y2 = abs(bug2.position.y);
  float z2 = abs(bug2.position.z);

  float largestBug = max(bug1.getSize(), bug2.getSize());

  if(abs(x1-x2) < largestBug && abs(y1-y2) < largestBug && abs(z1-z2) < largestBug) {
    if(bug1.inCollision() != true && bug2.inCollision() != true){
      if(bug1.isAlive() != true){
        bug1.hasBeenConsumed();
        bug2.consumed();
      }
      else if(bug2.isAlive() != true){
        bug2.hasBeenConsumed();
        bug1.consumed();
      }
      bug1.setCollision();
      bug2.setCollision();
    }
    return true;
  }
  return false;
}

BUG[] reproduce(BUG[] oldBugs){
  if(currentNumberOfBugs < MAXIMUM_NUMBER_OF_BUGS){
    currentNumberOfBugs++;
    BUG[] newBugs = new BUG[currentNumberOfBugs];
    for(int i = 0; i < currentNumberOfBugs-1; i++){
      newBugs[i] = oldBugs[i];
    }
    if(RANDOM_SPAWN){
      newBugs[currentNumberOfBugs-1] = new BUG(LIFE_SPAN_LOWER_LIMIT, LIFE_SPAN_UPPER_LIMIT, SPEED_LOWER_LIMIT, SPEED_UPPER_LIMIT, BUG_SIZE_LOWER_LIMIT, BUG_SIZE_UPPER_LIMIT);
    }
    else{
      newBugs[currentNumberOfBugs-1] = new BUG(PREDEFINED_SPAWN_X, PREDEFINED_SPAWN_Y, PREDEFINED_SPAWN_Z, LIFE_SPAN_LOWER_LIMIT, LIFE_SPAN_UPPER_LIMIT, SPEED_LOWER_LIMIT, SPEED_UPPER_LIMIT, BUG_SIZE_LOWER_LIMIT, BUG_SIZE_UPPER_LIMIT);
    }
    return newBugs;
  }
  else{
    return oldBugs;
  }
}

BUG[] consume(BUG[] oldBugs){
    currentNumberOfBugs--;
    BUG[] newBugs = new BUG[currentNumberOfBugs];
    
    for(int i = 0; i < currentNumberOfBugs; i++){
      if(oldBugs[i].hasBeenConsumed()){
        newBugs[i] = oldBugs[currentNumberOfBugs];
      }
      else {
        newBugs[i] = oldBugs[i];
      }
    }
    return newBugs;
}
