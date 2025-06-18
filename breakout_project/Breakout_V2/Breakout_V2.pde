// Breakout Game - Organized into Sections
// Jason Zhao

// setup
int mode, INTRO = 0, GAME = 1, PAUSE = 2, OVER = 3;
float paddleX, paddleY, pd = 80;
float ballX, ballY, ballVX, ballVY;
int lives, score;
ArrayList<Brick> bricks;
int rows = 5, cols = 8;
float bd, margin = 50, gap = 10;
color[] colors = { #FF6464, #FFA500, #FFFF64, #64C8FF, #96FF96 };


void setup() {
  size(800, 600);
  paddleY = height - 40;
  textAlign(CENTER, CENTER);
  resetGame();
  mode = INTRO;
}

// LOOP
void draw() {
  background(0, 30, 60);
  if      (mode == INTRO) showIntro();
  else if (mode == GAME)  runGame();
  else if (mode == PAUSE) showPause();
  else                     showGameOver();
}


//brick
class Brick {
  float x, y, d;
  color c;
  Brick(float x, float y, float d, color c) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.c = c;
  }
  void display() {
    noStroke();
    fill(c);
    ellipse(x, y, d, d);
  }
}
