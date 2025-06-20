// Jason Zhao
// Breakout Game (Lite) — Paddle Bounce Sound, Score, Lives, Modes

import ddf.minim.*;
import java.awt.Toolkit;  // For system beep

Minim minim;
AudioPlayer bounceSound;

// MODES 
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
float ballVX = 3, ballVY = -3;
final float ballSize = 20;

// Game state
int score = 0;
int lives = 2;

void setup() {
  size(600, 600);
  ellipseMode(CENTER); // Ensure ellipse is drawn from center
  minim = new Minim(this);
  bounceSound = minim.loadFile("bounce.wav"); // Must be in "data" folder
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
  text("BREAKOUT", width/2, height/2 - 60);

  fill(0, 150, 255);
  rectMode(CENTER);
  rect(width/2, height/2, 150, 50, 10);

  fill(255);
  textSize(18);
  text("START GAME", width/2, height/2 + 6);
}

void drawGame() {
  // Reset drawing modes
  rectMode(CORNER);
  ellipseMode(CENTER);

  // Paddle
  fill(255);
  arc(paddleX, paddleY + paddleRadius, paddleRadius * 2, paddleRadius * 2, PI, TWO_PI);

  // Ball
  fill(255, 100, 100); // Give the ball a distinct color
  ellipse(ballX, ballY, ballSize, ballSize);
  ballX += ballVX;
  ballY += ballVY;

  // Wall bounce
  if (ballX < ballSize/2 || ballX > width - ballSize/2) {
    ballVX *= -1;
    Toolkit.getDefaultToolkit().beep();
  }
  if (ballY < ballSize/2) {
    ballVY *= -1;
    Toolkit.getDefaultToolkit().beep();
  }

  // Bottom miss
  if (ballY > height) {
    lives--;
    if (lives > 0) resetBall();
    else mode = GAMEOVER;
  }

  // Paddle bounce
  if (ballY + ballSize/2 >= paddleY &&
      dist(ballX, ballY, paddleX, paddleY + paddleRadius) < paddleRadius + ballSize/2) {
    ballVY *= -1;
    if (bounceSound != null) {
      bounceSound.rewind();
      bounceSound.play();
    }
    score++;
  }

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
  text("GAME OVER!", width/2, height/2);
  text("CLICK TO RESTART", width/2, height/2 + 40);
}

void mousePressed() {
  if (mode == INTRO) {
    float bx = width/2;
    float by = height/2;
    float bw = 150;
    float bh = 50;
    if (mouseX > bx - bw/2 && mouseX < bx + bw/2 &&
        mouseY > by - bh/2 && mouseY < by + bh/2) {
      mode = GAME;
    }
  } else if (mode == PAUSE) {
    mode = GAME;
  } else if (mode == GAME) {
    mode = PAUSE;
  } else if (mode == GAMEOVER) {
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
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  ballVX = 3;
  ballVY = -3;
}
