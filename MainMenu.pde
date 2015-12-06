public class MainMenu {

  private PImage background, foreground, ready, notReady;
  private float offset;

  private ArrayList<Cursor> cursors;

  private int selection;
  private int PLAY_GAME = 0;
  private int EXIT_GAME = 1;

  private float SQUARE_SIDE = 32;

  public MainMenu() {
    this.background = loadImage("mainmenubackground.png");
    this.foreground = loadImage("mainmenuforeground.png");
    this.ready = loadImage("xboxready.png");
    this.notReady = loadImage("xboxnotready.png");

    this.offset = 0;

    this.selection = PLAY_GAME;

    this.cursors = new ArrayList<Cursor>();

    if (isPlayer1Ready()) {
      cursors.add(new Cursor(controller1, 1));
    }
    if (isPlayer2Ready()) {
      cursors.add(new Cursor(controller1, 2));
    }
    if (isPlayer3Ready()) {
      cursors.add(new Cursor(controller3, 3));
    }
    if (isPlayer4Ready()) {
      cursors.add(new Cursor(controller4, 4));
    }
  }

  public void update() {
    updateSelector();
    updateOffset();
    for (Cursor cursor : cursors) {
      cursor.update();
    }
  }

  public void draw() {
    imageMode(CORNER);
    image(background, 0, 0);

    stroke(150, 150, 150, 50);
    drawHorizontalLines();
    drawVerticalLines();

    drawSelector();
    drawReadyStatuses();

    for (Cursor cursor : cursors) {
      cursor.draw();
    }

    image(foreground, 0, 0);
  }

  public void updateSelector() {
    for (Cursor cursor : cursors) {
      if (cursor.x > 500 && cursor.x < 750) {
        if (cursor.y > 350 && cursor.y < 400) {
          selection = 0;
        } else if (cursor.y >= 425 && cursor.y < 500) {
          selection = 1;
        }
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
    if (keys[ENTER] || controller1.A.pressed()) {
      if (selection == PLAY_GAME) {
        game = new Game(isPlayer1Ready(), isPlayer2Ready(), isPlayer3Ready(), isPlayer4Ready());
        state = GAME_STATE;
      } else {
        exit();
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

  private void drawSelector() {
    rectMode(CENTER);
    stroke(0, 0, 0, 50);
    fill(0, 25);
    rect(width/2, selection == PLAY_GAME ? 375 : 460, 325, 75, 15);
  }

  private void updateOffset() {
    offset = (offset + 1) % SQUARE_SIDE;
  }

  private void drawReadyStatuses() {
    drawReadyStatus(1, isPlayer1Ready());
    drawReadyStatus(2, isPlayer2Ready());
    drawReadyStatus(3, isPlayer3Ready());
    drawReadyStatus(4, isPlayer4Ready());
  }

  private void drawReadyStatus(int player, boolean playerReady) {
    image(playerReady ? ready : notReady, (player - 1) * 340 + 70, 550);
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

