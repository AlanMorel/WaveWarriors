public class Game {

  private PImage background;
  public ArrayList<Player> players;
  private boolean paused;
  
  private Wave wave;
  private int waveLevel;

  public static final int FIRST_WAVE_LEVEL = 1;

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
  }
  
  private void updateWave() {
    if (wave.isDefeated()) {
      wave = new Wave(++waveLevel);
    } 
    wave.update();
  }
  
  private void updatePlayers() {
    for (final Player p : players) {
      p.update();
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
    for (final Player p : players) {
      p.shoot();
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
    ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
    for (final Player p : players) {
      for (Bullet bullet : p.bullets) {
        for (Enemy enemy : wave.enemies) {
          if (collided(bullet.x, bullet.y, Bullet.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS)) {
            enemy.hit();
            toRemove.add(bullet);
          }
        }
      }
      for (Bullet bullet : toRemove) {
        p.bullets.remove(bullet);
      }
    }
  }

  public void checkEnemyBulletCollisions() {
    for (Enemy enemy : wave.enemies) {
      ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
      for (Bullet bullet : enemy.getFiredBullets()) {
        for (final Player p : players) {
          if (collided(bullet.x, bullet.y, Bullet.BULLET_RADIUS / 2, p.x, p.y, p.radius)) {
            p.hit();
            toRemove.add(bullet);
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
  
  public float playerDist(Player p1, Player p2) {
    return dist(p1.x, p1.y, p2.x, p2.y);
  }
  
  private void healAllPlayers() {
    for (final Player p : players) {
      p.respawn();
    } 
  }
  
  private void drawPlayers() {
    for (final Player p : players) {
      p.display();
    }
  }
}

