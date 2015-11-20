public class Game {

  private PImage background;
  private Player[] players;
  private boolean paused;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {

    this.background = loadImage("gamebackground.png");
    this.players = new Player[4];

    if (player1) {
      this.players[0] = new Player(1, 100, 100);
    }

    if (player2) {
      this.players[1] = new Player(2, 500, 100);
    }

    if (player3) {
      this.players[2] = new Player(3, 100, 500);
    }

    if (player4) {
      this.players[3] = new Player(4, 500, 500);
    }

    this.paused = false;
  }

  public void update() {

    if (keys[BACKSPACE]) {
      paused = !paused;
      keys[BACKSPACE] = false;
    }

    if (paused) {
      return;
    }

    for (int id = 0; id < 4; id++) {
      if (players[id] != null) {
        players[id].update();
      }
    }
  }

  public void draw() {
    image(background, 0, 0);

    for (int id = 0; id < 4; id++) {
      if (players[id] != null) {
        players[id].draw();
      }
    }

    if (paused) {
      drawPauseMenu();
    }
  }

  public void drawPauseMenu() {
    rectMode(CORNER);
    noStroke();
    fill(0, 150);
    rect(0, 0, width, height);

    textSize(100);
    fill(255, 255);
    text("Game Paused", width / 2, height / 2);
  }
}

