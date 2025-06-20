// Jason Zhao
// Breakout Game with Modes, 2 Lives (No Sound or GIF)

// ==== GLOBALS & SETTINGS ====
final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;
final int GAMEOVER = 3;
int mode = INTRO;

// Paddle
float paddleX;
final float paddleW = 80;
final float paddleH = 20;
final float paddleY = 550;
boolean moveLeft = false;
boolean moveRight = false;

// Ball
float ballX, ballY;
float ballVX = 4, ballVY = -4;
final float ballSize = 20;

// Bricks
ArrayList<Brick> bricks;
final int rows = 4;
final int cols = 7;
final float brickSize = 30;
final float gap = 10;

// Game state
int score = 0;
int lives = 2;

void setup() {
  size(600, 600);
  bricks = new ArrayList<Brick>();
  resetGame();
}

void draw() {
  background(0);

  if (moveLeft) paddleX -= 6;
  if (moveRight) paddleX += 6;
  paddleX = constrain(paddleX, 0, width - paddleW);
  
  if (mode == INTRO) drawIntro();
  else if (mode == GAME) drawGame();
  else if (mode == PAUSE) drawPause();
  else if (mode == GAMEOVER) drawGameOver();
}

void drawIntro() {
  background(30, 30, 90);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("CLICK TO START BREAKOUT!", width/2, height/2);
}

void drawGame() {
  // Paddle
  fill(255);
  rect(paddleX, paddleY, paddleW, paddleH);
  
  // Ball
  ellipse(ballX, ballY, ballSize, ballSize);
  
  // Move ball
  ballX += ballVX;
  ballY += ballVY;

  // Wall bounce
  if (ballX < ballSize/2 || ballX > width - ballSize/2) ballVX *= -1;
  if (ballY < ballSize/2) ballVY *= -1;

  // Bottom
  if (ballY > height) {
    lives--;
    if (lives > 0) resetBall();
    else mode = GAMEOVER;
  }

  // Paddle bounce
  if (ballY + ballSize/2 >= paddleY && ballX > paddleX && ballX < paddleX + paddleW) {
    ballVY *= -1;
  }

  // Bricks
  for (int i = bricks.size() - 1; i >= 0; i--) {
    Brick b = bricks.get(i);
    b.display();
    if (b.hit(ballX, ballY, ballSize)) {
      bricks.remove(i);
      score++;
      ballVY *= -1;
    }
  }

  // Win condition
  if (bricks.size() == 0) mode = GAMEOVER;

  // Score/lives
  fill(255);
  text("Score: " + score, 10, 20);
  text("Lives: " + lives, width - 70, 20);
}

void drawPause() {
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("PAUSED\nCLICK TO RESUME", width/2, height/2);
}

void drawGameOver() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  if (bricks != null && bricks.size() == 0) text("YOU WON!", width/2, height/2);
  else text("GAME OVER!", width/2, height/2);
  text("CLICK TO RESTART", width/2, height/2 + 40);
}

void mousePressed() {
  if (mode == INTRO) {
    mode = GAME;
  } else if (mode == PAUSE) mode = GAME;
  else if (mode == GAME) mode = PAUSE;
  else if (mode == GAMEOVER) {
    resetGame();
    mode = INTRO;
  }
}

void keyPressed() {
  if (keyCode == LEFT) moveLeft = true;
  if (keyCode == RIGHT) moveRight = true;
}

void keyReleased() {
  if (keyCode == LEFT) moveLeft = false;
  if (keyCode == RIGHT) moveRight = false;
}

void resetGame() {
  paddleX = width / 2 - paddleW / 2;
  resetBall();
  score = 0;
  lives = 2;
  bricks.clear();
  float startX = 40;
  float startY = 50;
  for (int r = 0; r < 4; r++) {
    color brickColor = color(random(255), random(255), random(255));
    for (int i = 0; i < 7; i++) {
      float x = startX + i * 50;
      float y = startY + r * 50;
      bricks.add(new Brick(x, y, 30, brickColor));
    }
  }
}

void resetBall() {
  ballX = width/2;
  ballY = height/2;
  ballVX = 4;
  ballVY = -4;
}

class Brick {
  float x, y, size;
  color c;
  Brick(float x, float y, float size, color c) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.c = c;
  }
  void display() {
    fill(c);
    ellipse(x + size/2, y + size/2, size, size);
  }
  boolean hit(float bx, float by, float bSize) {
    return dist(bx, by, x + size/2, y + size/2) < (bSize + size)/2;
  }
}
