final static float NUM_HORIZONTAL_LINES = 32;
final static float NUM_VERTICAL_LINES = 56.89;

float movingGridOffset;  // Increasing offset causes grid to appear to move.

void setup() {
  size(1280, 720);
  int movingGridOffSet = 0;
}

void draw() {
  background(0, 255, 191);
  drawHorizontalLines();
  drawVerticalLines();
}

void drawHorizontalLines() {
  for (int i = 0; i < NUM_HORIZONTAL_LINES; i++) {
    stroke(0, 153, 153, i % 2 == 0 ? 50 : 90);
    float lineY = (height/NUM_HORIZONTAL_LINES * i);
    line(0, lineY, width, lineY);
  }
}

void drawVerticalLines() {
  for (int i = 0; i < NUM_VERTICAL_LINES; i++) {
    stroke(0, 153, 153, 60);
    float lineX = (width/NUM_VERTICAL_LINES * i) + (movingGridOffset % (width/NUM_VERTICAL_LINES));
    line(lineX, 0, lineX, height);
  }
  movingGridOffset ++;
}
