public class MainMenu {

  private PImage background, foreground;
  private float offset;
  private boolean buttonSelectorIsOnPlay;

  private float SQUARE_SIDE = 32;

  private float EXIT_BUTTON_CENTER_Y = 483;
  private float PLAY_BUTTON_CENTER_Y = 395;
  
  private float SELECTOR_HEIGHT = 67;
  private float SELECTOR_RADIUS = 40;
  private float SELECTOR_WIDTH = 275;

  public MainMenu() {
    background = loadImage("mainmenubackground.png");
    foreground = loadImage("mainmenuforeground.png");
    offset = 0;
    buttonSelectorIsOnPlay = true;
  }

  public void update(){
     updateButtonSelector();
     updateOffset();
  }

  public void draw() {
    image(background, 0, 0);

    stroke(0, 150, 150, 50);
    drawHorizontalLines();
    drawVerticalLines();

    drawButtonSelector();

    image(foreground, 0, 0);
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
    for (int i = 0; i < height / SQUARE_SIDE; i++) {
      float y = i * SQUARE_SIDE;
      line(0, y, width, y);
    }
  }

  private void drawVerticalLines() {
    for (int i = 0; i < width / SQUARE_SIDE; i++) {
      float x = i * SQUARE_SIDE + offset;
      line(x, 0, x, height);
    }
  }

  private void drawButtonSelector() {
    rectMode(CENTER);
    fill(255, 50);
    rect(width/2, buttonSelectorIsOnPlay ? PLAY_BUTTON_CENTER_Y : EXIT_BUTTON_CENTER_Y, SELECTOR_WIDTH, SELECTOR_HEIGHT, SELECTOR_RADIUS);
  }
  
  private void updateOffset(){
     offset = (offset + 1) % SQUARE_SIDE;
  }
}

