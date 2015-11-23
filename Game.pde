public class Game {

  private PImage background;
  private int numPlayers;
  private Player[] players;
  private boolean paused;
  private Wave wave;
  private int waveLevel;
  
  public static final int FIRST_WAVE_LEVEL = 3;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {

    this.background = loadImage("gamebackground.png");
    this.numPlayers = 0;
    this.players = new Player[4];

    if (player1) {
      this.players[numPlayers++] = new Player(1, 100, 100);
    }

    if (player2) {
      this.players[numPlayers++] = new Player(2, 500, 100);
    }

    if (player3) {
      this.players[numPlayers++] = new Player(3, 100, 500);
    }

    if (player4) {
      this.players[numPlayers++] = new Player(4, 500, 500);
    }

    this.paused = false;
    this.waveLevel = FIRST_WAVE_LEVEL;
    this.wave = new Wave(this, waveLevel);
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
      
    wave.display();

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
  
  public Player[] getPlayers() {
    return (Player[])players.clone();
  }
}

