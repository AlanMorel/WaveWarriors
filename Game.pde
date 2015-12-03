public class Game {

  private PImage background;
  public ArrayList<Player> players;
  private boolean paused;

  public ArrayList<PowerUp> powerUps;

  private boolean isIntroducingWave;
  private Wave wave;
  private int waveLevel;
  private int waveLevelFontTransparency;
  private int waveTextX;
  private int introFrame;

  PFont waveFont;

  public static final int FIRST_WAVE_LEVEL = 1;
  public static final int BASE_FONT_SIZE = 100;
  public static final int INTRO_FRAME_LENGTH = 150;

  public static final int POWER_UP_SPAWN_DELAY = 1000;
  private int lastPowerUpSpawn;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {
    this.background = loadImage("gamebackground.png");
    this.players = new ArrayList<Player>();

    if (player1) {
      players.add(new Player(1, 100, 100, false));
    }

    if (player2) {
      players.add(new Player(2, 1100, 100, false));
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
    this.waveFont = loadFont("Silom-100.vlw");
    this.waveLevelFontTransparency = 0;
    this.waveTextX = 0;
    this.introFrame = 0;

    this.isIntroducingWave = true;

    this.powerUps = new ArrayList<PowerUp>();
    this.lastPowerUpSpawn = 0;
  }

  public void update() {
    if (keys[BACKSPACE] || controller1.start.pressed()) {
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

    updateWaveFont();
    updateIntroductionStatus();
    checkCollisions();

    if (!isIntroducingWave) {
      updateWave();  // Don' allow wave to advance while introductory text is on screen
    }

    checkPowerUpSpawn();
  }

  private void updateWave() {
    if (wave.isDefeated()) {
      isIntroducingWave = true;
      wave = new Wave(++waveLevel);
    } 
    wave.update();
  }

  private void updateWaveFont() {
    if (isIntroducingWave) {
      introFrame++;
    }
  }

  private void updateIntroductionStatus() {
    if (introFrame >= INTRO_FRAME_LENGTH) {
      isIntroducingWave = false;
      waveTextX = 0;
      introFrame = 0;
    }
  }

  private void updatePlayers() {
    for (final Player p : players) {
      p.update();
    }
  } 

  public void draw() {
    image(background, 0, 0);

    drawPlayers();
    drawPowerUps();

    if (isIntroducingWave) {
      introduceWave(waveLevel);
    }

    if (paused) {
      drawPauseMenu();
    }
    wave.display();
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
    checkPlayerPowerUpCollisions();
  }

  public void checkPlayerBulletCollisions() {
    ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
    for (Player player : players) {
      for (Bullet bullet : player.bullets) {
        for (Enemy enemy : wave.enemies) {
          if (collided(bullet.x, bullet.y, Bullet.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS)) {
            toRemove.add(bullet);
            enemy.hit();
            if (player.powerUp != null && player.powerUp.isDamage()) {
              enemy.hit();
            }
          }
        }
      }
      for (Bullet bullet : toRemove) {
        player.bullets.remove(bullet);
      }
    }
  }

  public void checkEnemyBulletCollisions() {
    for (Enemy enemy : wave.enemies) {
      ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
      for (Bullet bullet : enemy.getFiredBullets ()) {
        for (Player player : players) {
          if (collided(bullet.x, bullet.y, Bullet.BULLET_RADIUS / 2, player.x, player.y, player.radius)) {
            toRemove.add(bullet);
            player.hit();
          }
        }
      }
      for (Bullet bullet : toRemove) {
        enemy.getFiredBullets().remove(bullet);
      }
    }
  }

  public void checkPlayerPowerUpCollisions() {
    ArrayList<PowerUp> toRemove = new ArrayList<PowerUp>();
    for (PowerUp powerUp : powerUps) {
      for (Player player : players) {
        if (collided(powerUp.x, powerUp.y, PowerUp.POWER_UP_RADIUS / 2, player.x, player.y, player.radius)) {
          player.powerUp = powerUp;
          player.pickUpTime = frameCount;
          toRemove.add(powerUp);
        }
      }
    }
    for (PowerUp powerUp : toRemove) {
      powerUps.remove(powerUp);
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

  private void drawPowerUps() {
    for (PowerUp powerUp : powerUps) {
      powerUp.draw();
    }
  }

  private void introduceWave(final int waveLevel) {
    noStroke();
    fill(0, 255 - abs(INTRO_FRAME_LENGTH / 2 - introFrame) * 4);
    rectMode(CENTER);
    rect(width/2, height/2, width, height/2);
    
    textAlign(CENTER);
    textFont(waveFont, BASE_FONT_SIZE + 25);
    fill(255);
    
    if ((waveTextX < width/3.5) || (waveTextX > width*2/3.5)) {
      waveTextX += 30; 
    } else {
      waveTextX += 3;
    }
    
    text("Wave", waveTextX, height/2 - 50);
    text("#" + waveLevel, width - waveTextX, height/2 + 125);
  }

  private void checkPowerUpSpawn() {
    if (shouldSpawnPowerUp()) {
      spawnPowerUp();
    }
  }

  private boolean shouldSpawnPowerUp() {
    return frameCount - lastPowerUpSpawn >= POWER_UP_SPAWN_DELAY;
  }

  private PowerUp getRandomPowerUp() {
    float x = random(width - 100) + 50;
    float y = random(height - 100) + 50;
    int type = int(random(3));
    return new PowerUp(x, y, type);
  }

  private void spawnPowerUp() {
    PowerUp powerUp = getRandomPowerUp();
    powerUps.add(powerUp);
    lastPowerUpSpawn = frameCount;
  }
}

