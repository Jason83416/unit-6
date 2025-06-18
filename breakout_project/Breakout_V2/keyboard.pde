// === INPUT HANDLERS ===
void mousePressed() {
  if      (mode == INTRO) mode = GAME;
  else if (mode == GAME)  mode = PAUSE;
  else if (mode == PAUSE) mode = GAME;
  else                    { resetGame(); mode = INTRO; }
}

void keyPressed() {
  if (mode == GAME) {
    if (keyCode == LEFT)  paddleX = max(pd/2, paddleX - 20);
    if (keyCode == RIGHT) paddleX = min(width - pd/2, paddleX + 20);
  }
}
