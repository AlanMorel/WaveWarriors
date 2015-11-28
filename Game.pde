public class Game {

  private PImage background;
  public ArrayList<Player> players;
  private boolean paused;
  
  private Wave wave;
  private int waveLevel;

  public static final int FIRST_WAVE_LEVEL = 1;
  public static final int MAX_NUMBER_OF_PLAYERS = 4;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {

    this.background = loadImage("gamebackground.png");
    this.players = new ArrayList<Player>();

    if (player1) {
      players.add(new Player(1, 100, 100, false));
    }

    if (player2) {
      players.add(new Player(2, 1100, 100, true));
    }

    if (player3) {
      players.add(new Player(3, 100, 500, false));
    }

    if (player4) {
      players.add(new Player(4, 1100, 500, false));
    }

    this.paused = false;
    this.waveLevel = FIRST_WAVE_LEVEL;
    this.wave = new Wave(waveLevel);
  }

  public void update() {
    if (keys[BACKSPACE]) {
      paused = !paused;
      keys[BACKSPACE] = false;
    }

    if (paused) {
      return;
    }

    updatePlayers();
    if (wave.isDefeated()) {
      healAllPlayers(); 
    }
    
    updateWave();
    checkCollisions();
<<<<<<< HEAD
=======
  }
  
  private void updateWave() {
    if (wave.isDefeated()) {
      wave = new Wave(++waveLevel);
    } 
    wave.update();
  }
  
  private void updatePlayers() {
    for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
      if (players[id] != null) {
        players[id].update();
      }
    } 
>>>>>>> origin/master
  }
  
  private void updateWave() {
    if (wave.isDefeated()) {
      wave = new Wave(++waveLevel);
    } 
    wave.update();
  }
  
  private void updatePlayers() {
    for (Player player : players) {
      player.update();
    }
  }

  public void draw() {
    image(background, 0, 0);
    
    drawPlayers();
    wave.display();

    if (paused) {
      drawPauseMenu();
    }
  }

  void mouseClicked() {
<<<<<<< HEAD
    for (Player player : players) {
      player.shoot();
=======
    for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
      if (players[id] != null) {
        players[id].shoot();
      }
>>>>>>> origin/master
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
<<<<<<< HEAD
    for (Player player : players) {
      ArrayList<Bullet2> toRemove = new ArrayList<Bullet2>();
      for (Bullet2 bullet : player.bullets) {
        for (Enemy enemy : wave.enemies) {
          if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS)) {
            enemy.hit();
            toRemove.add(bullet);
=======
    for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
      if (players[id] != null) {
        ArrayList<Bullet2> toRemove = new ArrayList<Bullet2>();
        for (Bullet2 bullet : players[id].bullets) {
          for (Enemy enemy : wave.enemies) {
            if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS)) {
              enemy.hit();
              toRemove.add(bullet);
            }
>>>>>>> origin/master
          }
        }
      }
      for (Bullet2 bullet : toRemove) {
        player.bullets.remove(bullet);
      }
    }
  }

  public void checkEnemyBulletCollisions() {
    for (Enemy enemy : wave.enemies) {
      ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
<<<<<<< HEAD
      for (Bullet bullet : enemy.bullets) {
        for (Player player : players) {
          if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, player.x, player.y, player.radius)) {
            player.hit();
            toRemove.add(bullet);
=======
      for (Bullet bullet : enemy.getFiredBullets()) {
        for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
          if (players[id] != null) {
            if (collided(bullet.x, bullet.y, Bullet2.BULLET_RADIUS / 2, players[id].x, players[id].y, players[id].radius)) {
              players[id].hit();
              toRemove.add(bullet);
            }
>>>>>>> origin/master
          }
        }
      }
      for (Bullet bullet : toRemove) {
<<<<<<< HEAD
        enemy.bullets.remove(bullet);
=======
        enemy.getFiredBullets().remove(bullet);
>>>>>>> origin/master
      }
    }
  }

  public boolean collided(float x1, float y1, float r1, float x2, float y2, float r2) {
    return dist(x1, y1, x2, y2) < r1 + r2;
  }
  
  public float playerDist(Player p1, Player p2) {
    return dist(p1.x, p1.y, p2.x, p2.y);
  }
  
  private void healAllPlayers() {
    for (final Player p : players) {
      if (p != null) {
        p.respawn();
      }
    } 
  }
  
  private void drawPlayers() {
<<<<<<< HEAD
    for (Player player : game.players) {
      player.draw();
=======
    for (int id = 0; id < MAX_NUMBER_OF_PLAYERS; id++) {
      if (players[id] != null) {
        players[id].draw();
      }
>>>>>>> origin/master
    }
  }
}

