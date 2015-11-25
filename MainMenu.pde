public class MainMenu {

  private PImage background, foreground;
  private float offset;

  private int selection;
  private int PLAY_GAME = 0;
  private int EXIT_GAME = 1;

  private float SQUARE_SIDE = 32;

  public MainMenu() {
    this.background = loadImage("mainmenubackground.png");
    this.foreground = loadImage("mainmenuforeground.png");
    
    this.offset = 0;
    
    this.selection = PLAY_GAME;
  }

  public void update() {
    updateSelector();
    updateOffset();
  }

  public void draw() {
    image(background, 0, 0);

    stroke(150, 150, 150, 50);
    drawHorizontalLines();
    drawVerticalLines();

    drawSelector();
    drawPlayerCircles();

    image(foreground, 0, 0);
  }

  public void updateSelector() {
    if (keys[ENTER]) {
      if (selection == PLAY_GAME) {
        game = new Game(isPlayer1Ready(), isPlayer2Ready(), isPlayer3Ready(), isPlayer4Ready());
        state = GAME_STATE;
      } else {
        exit();
      }
    }
    if (keys[UP] || keys['W']) {
      selection--;
    }
    if (keys[DOWN] || keys['S']) {
      selection++;
    }
    if (selection < 0) {
      selection = 0;
    } else if (selection > 1) {
      selection = 1;
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
  
  private void drawSelector() {
    rectMode(CENTER);
    stroke(0, 0, 0, 50);
    fill(0, 25);
    rect(width/2, selection == PLAY_GAME ? 375 : 460, 325, 75, 15);
  }

  private void updateOffset() {
    offset = (offset + 1) % SQUARE_SIDE;
  }

  private void drawPlayerCircles() {
    drawCircle(1, isPlayer1Ready());
    drawCircle(2, isPlayer2Ready());
    drawCircle(3, isPlayer3Ready());
    drawCircle(4, isPlayer4Ready());
  }

  private void drawCircle(int player, boolean ready) {
    if (ready) {
      fill(0, 200, 0, 100);
      stroke(0, 200, 0, 255);
    } else {
      fill(255, 0, 0, 100);
      stroke(255, 0, 0, 255);
    }
    
    ellipse((player - 1) * 340 + 125, 600, 75, 75);
  }

  private boolean isPlayer1Ready() {
    return true;
  }

  private boolean isPlayer2Ready() {
    return true;
  }

  private boolean isPlayer3Ready() {
    return false;
  }

  private boolean isPlayer4Ready() {
    return false;
  }
}

