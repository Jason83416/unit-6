// Jason Zhao
// Breakout Game
// Programming 11 - Unit 4 Extension (No external libraries)

// Mode framework
final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;
final int GAMEOVER = 3;
int mode;

// Animated GIF (optional: place intro.gif in data folder)
PImage introGif;

// Paddle
float paddleX;
final float paddleDiameter = 80;
float paddleY;

// Ball
float ballX, ballY;
float ballVX, ballVY;

// Game state
int lives;
int score;

// Bricks (as circles)
ArrayList<Brick> bricks;
int rows = 5;
int cols = 8;
float brickDiameter;
float margin = 50;
float gap = 10;
color[] rowColors;

// Font
PFont font;

void setup() {
  size(800, 600);

  // Load animated GIF (optional)
  introGif = loadImage("intro.gif");

  // Font
  font = createFont("Arial Bold", 24);
  textFont(font);
  textAlign(CENTER, CENTER);

  // Paddle position
  paddleY = height - 40;

  // Row colors for bricks
  rowColors = new color[]{
    color(255, 100, 100),
    color(255, 165, 0),
    color(255, 255, 100),
    color(100, 200, 255),
    color(150, 255, 150)
  };

  resetGame();
  mode = INTRO;
}

void draw() {
  background(0, 30, 60);
  switch(mode) {
    case INTRO:    drawIntro();    break;
    case GAME:     drawGame();     break;
    case PAUSE:    drawPause();    break;
    case GAMEOVER: drawGameOver(); break;
  }
}

void drawIntro() {
  if (introGif != null) {
    imageMode(CENTER);
    image(introGif, width/2, height/2);
  }
  fill(255);
  text("Breakout: Underwater Edition", width/2, 50);
  text("Click to Start", width/2, height - 50);
}

void drawGame() {
  // Paddle follows mouse
  paddleX = constrain(mouseX, paddleDiameter/2, width - paddleDiameter/2);

  // Draw paddle
  fill(200);
  noStroke();
  ellipse(paddleX, paddleY, paddleDiameter, paddleDiameter);

  // Draw ball
  fill(255);
  ellipse(ballX, ballY, 20, 20);

  // Draw bricks
  for (Brick b : bricks) {
    if (b.active) b.display();
  }

  // Display score & lives
  fill(255);
  text("Score: " + score, 80, height - 20);
  text("Lives: " + lives, width - 80, height - 20);

  // Move ball
  ballX += ballVX;
  ballY += ballVY;

  // Wall collisions
  if (ballX < 10 || ballX > width - 10) {
    ballVX *= -1;
  }
  if (ballY < 10) {
    ballVY *= -1;
  }

  // Paddle collision
  if (dist(ballX, ballY, paddleX, paddleY) < (10 + paddleDiameter/2)) {
    ballVY = -abs(ballVY);
  }

  // Brick collisions
  for (Brick b : bricks) {
    if (b.active && dist(ballX, ballY, b.x, b.y) < (10 + b.d/2)) {
      b.active = false;
      score++;
      ballVY *= -1;
      break;
    }
  }

  // Check out-of-bounds (bottom)
  if (ballY > height) {
    lives--;
    if (lives <= 0) {
      mode = GAMEOVER;
    } else {
      // Reset ball & paddle for next life
      ballX = width/2;
      ballY = height/2;
      ballVX = random(-3, 3);
      ballVY = 5;
      paddleX = width/2;
    }
  }

  // Check win condition
  if (score == rows * cols) {
    mode = GAMEOVER;
  }
}

void drawPause() {
  fill(255, 200);
  textSize(48);
  text("Paused", width/2, height/2);
  textSize(24);
  text("Click to Resume", width/2, height/2 + 50);
}

void drawGameOver() {
  fill(255);
  textSize(48);
  if (score == rows * cols) {
    text("You Win!", width/2, height * 0.4);
  } else {
    text("Game Over", width/2, height * 0.4);
  }
  textSize(24);
  text("Click to Restart", width/2, height * 0.6);
}

void mousePressed() {
  if (mode == INTRO) {
    mode = GAME;
  } else if (mode == GAME) {
    mode = PAUSE;
  } else if (mode == PAUSE) {
    mode = GAME;
  } else if (mode == GAMEOVER) {
    resetGame();
    mode = INTRO;
  }
}

void keyPressed() {
  // Optional keyboard control
  if (mode == GAME && keyCode == LEFT) {
    paddleX = max(paddleDiameter/2, paddleX - 20);
  } else if (mode == GAME && keyCode == RIGHT) {
    paddleX = min(width - paddleDiameter/2, paddleX + 20);
  }
}

void resetGame() {
  // Reset stats
  lives = 3;
  score = 0;

  // Reset paddle & ball
  paddleX = width/2;
  ballX = width/2;
  ballY = height/2;
  ballVX = random(-3, 3);
  ballVY = 5;

  // Build bricks
  bricks = new ArrayList<Brick>();
  brickDiameter = (width - 2 * margin - (cols - 1) * gap) / cols;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float x = margin + c * (brickDiameter + gap) + brickDiameter/2;
      float y = margin + r * (brickDiameter + gap) + brickDiameter/2;
      color ccol = rowColors[r % rowColors.length];
      bricks.add(new Brick(x, y, brickDiameter, ccol));
    }
  }
}

class Brick {
  float x, y, d;
  boolean active;
  color c;
  Brick(float x, float y, float d, color c) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.c = c;
    this.active = true;
  }
  void display() {
    noStroke();
    fill(c);
    ellipse(x, y, d, d);
  }
}
