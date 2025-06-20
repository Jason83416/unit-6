// Jason Zhao
// Breakout Game with Modes, 2 Lives (No Sound or GIF) — Simplified Bricks, Semicircle Paddle

// ==== GLOBALS & SETTINGS ====
final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;
final int GAMEOVER = 3;
int mode = INTRO;

// Paddle
float paddleX;
final float paddleRadius = 40;
final float paddleY = 550;
boolean moveLeft = false;
boolean moveRight = false;

// Ball
float ballX, ballY;
float ballVX = 3, ballVY = -3; // slightly slower
final float ballSize = 20;

// Bricks
float[] brickX = new float[28];
float[] brickY = new float[28];
color[] brickC = new color[28];
boolean[] brickVisible = new boolean[28];

// Game state
int score = 0;
int lives = 2;

void setup() {
  size(600, 600);
  resetGame();
}

void draw() {
  background(0);

  if (moveLeft) paddleX -= 6;
  if (moveRight) paddleX += 6;
  paddleX = constrain(paddleX, paddleRadius, width - paddleRadius);

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
  // Paddle (semi-circle)
  fill(255);
  arc(paddleX, paddleY + paddleRadius, paddleRadius * 2, paddleRadius * 2, PI, TWO_PI);

  // Ball
  ellipse(ballX, ballY, ballSize, ballSize);
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
  if (ballY + ballSize/2 >= paddleY && dist(ballX, ballY, paddleX, paddleY + paddleRadius) < paddleRadius + ballSize/2) {
    ballVY *= -1;
  }

  // Bricks
  int remaining = 0;
  for (int i = 0; i < brickX.length; i++) {
    if (!brickVisible[i]) continue;
    fill(brickC[i]);
    ellipse(brickX[i], brickY[i], 30, 30);
    if (dist(ballX, ballY, brickX[i], brickY[i]) < (30 + ballSize) / 2) {
      brickVisible[i] = false;
      score++;
      ballVY *= -1;
    } else {
      remaining++;
    }
  }

  // Win condition
  if (remaining == 0) mode = GAMEOVER;

  // Score/lives
  fill(255);
  textAlign(LEFT);
  text("Score: " + score, 10, 20);
  textAlign(RIGHT);
  text("Lives: " + lives, width - 10, 20);
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
  boolean win = true;
  for (boolean b : brickVisible) if (b) win = false;
  text(win ? "YOU WON!" : "GAME OVER!", width/2, height/2);
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
  paddleX = width / 2;
  resetBall();
  score = 0;
  lives = 2;
  int index = 0;
  float startX = 40;
  float startY = 50;
  for (int r = 0; r < 4; r++) {
    color c = color(random(255), random(255), random(255));
    for (int i = 0; i < 7; i++) {
      brickX[index] = startX + i * 50 + 15;
      brickY[index] = startY + r * 50 + 15;
      brickC[index] = c;
      brickVisible[index] = true;
      index++;
    }
  }
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  ballVX = 3;
  ballVY = -3;
}

