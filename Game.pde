public class Game {

  private PImage background;
  public Player[] players;
  private boolean paused;
  
  private Wave wave;
  private int waveLevel;

  public static final int FIRST_WAVE_LEVEL = 3;
  public static final int MAX_NUMBER_OF_PLAYERS = 4;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {

    this.background = loadImage("gamebackground.png");
    this.players = new Player[MAX_NUMBER_OF_PLAYERS];

    if (player1) {
      this.players[0] = new Player(1, 100, 100, false);
    }

    if (player2) {
      this.players[1] = new Player(2, 1100, 100, true);
    }

    if (player3) {
      this.players[2] = new Player(3, 100, 500, false);
    }

    if (player4) {
      this.players[3] = new Player(4, 1100, 500, false);
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

    wave.update();

    checkCollisions();
  }

  public void draw() {
    image(background, 0, 0);
    
    if (wave.isDefeated()) {
      this.wave = new Wave(this, ++waveLevel);
      healAllPlayers();
    }
    
    drawPlayers();
    wave.draw();

    if (paused) {
      drawPauseMenu();
    }
  }

  void mouseClicked() {
    for (int id = 0; id < 4; id++) {
      if (players[id] != null) {
        players[id].shoot();
      }
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

  public void checkCollisions() {
    checkPlayerBulletCollisions();
    checkEnemyBulletCollisions();
  }

  public void checkPlayerBulletCollisions() {
    for (int id = 0; id < 4; id++) {
      if (players[id] != null) {
        ArrayList<Bullet2> toRemove = new ArrayList<Bullet2>();
        for (Bullet2 bullet : players[id].bullets) {
          for (Enemy enemy : wave.enemies) {
            if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS)) {
              enemy.hit();
              toRemove.add(bullet);
            }
          }
        }
        for (Bullet2 bullet : toRemove) {
          players[id].bullets.remove(bullet);
        }
      }
    }
  }

  public void checkEnemyBulletCollisions() {
    for (Enemy enemy : wave.enemies) {
      ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
      for (Bullet bullet : enemy.getFiredBullets()) {
        for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
          if (players[id] != null) {
            if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, players[id].x, players[id].y, players[id].radius)) {
              players[id].hit();
              toRemove.add(bullet);
            }
          }
        }
      }
      for (Bullet bullet : toRemove) {
        enemy.getFiredBullets().remove(bullet);
      }
    }
  }

  public boolean collided(float x1, float y1, float r1, float x2, float y2, float r2) {
    return dist(x1, y1, x2, y2) < r1 + r2;
  }
  
  private void healAllPlayers() {
    for (final Player p : players) {
      p.respawn();
    } 
  }
  
  private void drawPlayers() {
    for (int id = 0; id < 4; id++) {
      if (players[id] != null) {
        players[id].draw();
      }
    }
  }
}

