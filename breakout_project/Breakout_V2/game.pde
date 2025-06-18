// GAMEPLAY
void runGame() {
  // Paddle movement
  paddleX = constrain(mouseX, pd/2, width - pd/2);
  fill(200); noStroke(); ellipse(paddleX, paddleY, pd, pd);

  // Ball rendering
  fill(255); ellipse(ballX, ballY, 20, 20);

  // Draw bricks
  for (Brick b : bricks) b.display();

  // HUD (Score & Lives)
  fill(255); textSize(24);
  text("Score: " + score, 80, height - 20);
  text("Lives: " + lives, width - 80, height - 20);

  // Move ball
  ballX += ballVX;
  ballY += ballVY;

  // Wall collisions
  if (ballX < 10 || ballX > width - 10) ballVX *= -1;
  if (ballY < 10) ballVY *= -1;

  // Paddle collision
  if (dist(ballX, ballY, paddleX, paddleY) < (10 + pd/2)) {
    ballVY = -abs(ballVY);
  }

  // Brick collision 
  for (int i = 0; i < bricks.size(); i++) {
    Brick b = bricks.get(i);
    if (dist(ballX, ballY, b.x, b.y) < (10 + b.d/2)) {
      bricks.remove(i);
      score++;
      ballVY *= -1;
      break;
    }
  }

  // Bottom boundary check
  if (ballY > height) loseLife();

  // Win condition
  if (bricks.isEmpty()) mode = OVER;
}
//GAME 
void showIntro() {
  fill(255);
  textSize(32);
  text("Click to Start", width/2, height/2);
}

void showPause() {
  fill(255, 200);
  textSize(48);
  text("Paused", width/2, height/2);
}

void showGameOver() {
  fill(255);
  textSize(48);
  text(score == rows*cols ? "You Win!" : "Game Over", width/2, height/2 - 20);
  textSize(24);
  text("Click to Restart", width/2, height/2 + 30);
}
