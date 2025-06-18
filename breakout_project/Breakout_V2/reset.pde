// === LIFE & BALL RESET ===
void loseLife() {
  lives--;
  if (lives <= 0) mode = OVER;
  else initBall();
}

void initBall() {
  ballX = width/2;
  ballY = height/2;
  ballVX = random(-3, 3);
  ballVY = 5;
  paddleX = width/2;
}

// === GAME RESET & BRICK INITIALIZATION ===
void resetGame() {
  lives = 3;
  score = 0;
  initBall();
  bricks = new ArrayList<Brick>();
  bd = (width - 2*margin - (cols - 1)*gap) / cols;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float x = margin + c*(bd + gap) + bd/2;
      float y = margin + r*(bd + gap) + bd/2;
      bricks.add(new Brick(x, y, bd, colors[r]));
    }
  }
}
