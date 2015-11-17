public class MainMenu {

  private PImage background, foreground;
  private float movingGridOffset;  // Increasing offset causes grid to appear to move.
  private boolean buttonSelectorIsOnPlay;

  final static float EXIT_BUTTON_CENTER_Y = 483;
  final static float NUM_HORIZONTAL_LINES = 32;
  final static float NUM_VERTICAL_LINES = 56.89;
  final static float PLAY_BUTTON_CENTER_Y = 395;
  final static float SELECTOR_HEIGHT = 67;
  final static float SELECTOR_RADIUS = 40;
  final static float SELECTOR_WIDTH = 275;

  public MainMenu() {
    background = loadImage("mainmenubackground.png");
    foreground = loadImage("mainmenuforeground.png");
    movingGridOffset = 0;
    buttonSelectorIsOnPlay = true;
  }

  public void display() {
    background(0, 255, 191);
    
    image(background, 0, 0);

    drawHorizontalLines();
    drawVerticalLines();

    image(foreground, 0, 0);

    updateButtonSelector();
    drawButtonSelector();
  }


  public void updateButtonSelector() {
    if (keyPressed && key == CODED) {
      if (keyCode == DOWN) {
        buttonSelectorIsOnPlay = false;
      } else if (keyCode == UP) {
        buttonSelectorIsOnPlay = true;
      }
    }
  }


  private void drawHorizontalLines() {
    for (int i = 0; i < NUM_HORIZONTAL_LINES; i++) {
      stroke(0, 153, 153, i % 2 == 0 ? 50 : 90);
      float lineY = (height/NUM_HORIZONTAL_LINES * i);
      line(0, lineY, width, lineY);
    }
  }


  private void drawVerticalLines() {
    for (int i = 0; i < NUM_VERTICAL_LINES; i++) {
      stroke(0, 153, 153, 60);
      float lineX = (width/NUM_VERTICAL_LINES * i) + (movingGridOffset % (width/NUM_VERTICAL_LINES));
      line(lineX, 0, lineX, height);
    }
    movingGridOffset++;
  }


  private void drawButtonSelector() {
    rectMode(CENTER);
    fill(255, 50);
    rect(width/2, buttonSelectorIsOnPlay ? PLAY_BUTTON_CENTER_Y : EXIT_BUTTON_CENTER_Y, SELECTOR_WIDTH, SELECTOR_HEIGHT, SELECTOR_RADIUS);
  }
}

