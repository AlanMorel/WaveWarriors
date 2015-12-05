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

  public static final int POWER_UP_SPAWN_DELAY = 500;

  private int lastPowerUpSpawn;

  public Game(boolean player1, boolean player2, boolean player3, boolean player4) {
    this.background = loadImage("gamebackground.png");

    this.players = new ArrayList<Player>();

    if (player1) {
      players.add(new Player(1, 100, 100, controller1, false));
    }

    if (player2) {
      players.add(new Player(2, 1100, 100, controller1, true));
    }

    if (player3) {
      players.add(new Player(3, 100, 500, controller3, false));
    }

    if (player4) {
      players.add(new Player(4, 1100, 500, controller4, false));
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
      updateWave();
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
    for (Player player : players) {
      player.shoot();
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
    checkPlayerLaserCollisions();
  }

  public void checkPlayerLaserCollisions() {
    Enemy target = null;
    float lowestDistance = Integer.MAX_VALUE;
    for (Player player : players) {
      if (!player.laser || player.down || !player.isFiring()) {
        continue;
      }
      float x0 = player.x + (float) (player.radius * Math.sin(Math.toRadians(90 - player.aim)));
      float y0 = player.y + (float) (player.radius * Math.sin(Math.toRadians(player.aim)));
      float x1 = player.x + (float) (width * Math.sin(Math.toRadians(90 - player.aim)));
      float y1 = player.y + (float) (width * Math.sin(Math.toRadians(player.aim)));
      for (Enemy enemy : wave.enemies) {
        if (collided(x0, y0, x1, y1, enemy.x, enemy.y, enemy.radius)) {
          float dist = dist(player.x, player.y, enemy.x, enemy.y);
          if (dist < lowestDistance) {
            lowestDistance = dist;
            target = enemy;
          }
        }
      }
      if (target != null) {
        if (frameCount - player.lastLaser > Player.LASER_RATE / ( player.hasFireRate() ? 2 : 1)) {
          player.lastLaser = frameCount;
          target.hitByLaser();
          if (player.hasDamage()){
              target.hitByLaser();
          }
        }
        player.laserX = player.x + (float) (lowestDistance * Math.sin(Math.toRadians(90 - player.aim)));
        player.laserY = player.y + (float) (lowestDistance * Math.sin(Math.toRadians(player.aim)));
      } else {
        player.laserX = player.x + (float) (width * Math.sin(Math.toRadians(90 - player.aim)));
        player.laserY = player.y + (float) (width * Math.sin(Math.toRadians(player.aim)));
      }
    }
  }

  public void checkPlayerBulletCollisions() {
    ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
    for (Player player : players) {
      for (Bullet bullet : player.bullets) {
        if (bullet.isOutOfBounds()) {
          toRemove.add(bullet);
          continue;
        }
        for (Enemy enemy : wave.enemies) {
          if (collided(bullet.x, bullet.y, Bullet.BULLET_RADIUS / 2, enemy.x, enemy.y, Enemy.ENEMY_RADIUS / 2)) {
            toRemove.add(bullet);
            bulletSound.trigger();
            enemy.hitByBullet();
            if (player.hasDamage()) {
              enemy.hitByBullet();
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
        if (bullet.isOutOfBounds()) {
          toRemove.add(bullet);
          continue;
        }
        for (Player player : players) {
          if (player.hasInvincibility()) {
            continue;
          }
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
          if (powerUp.type == PowerUp.HEAL){
            player.heal();
          } else if (powerUp.type == PowerUp.NUKE){
            for (Enemy enemy : wave.enemies){
              enemy.hitByNuke();
            }
          } else {
            player.powerUp = powerUp;
            player.pickUpTime = frameCount;
          }
          powerUpSound.trigger();
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

  public boolean collided(float x0, float y0, float x1, float y1, float x2, float y2, float r) {
    float a = x1-x0; 
    float b = y1-y0;
    float c = x2-x0;
    float d = y2-y0;

    if ((d*a - c*b)*(d*a - c*b) <= r*r*(a*a + b*b)) {
      if (c*c + d*d <= r*r) {
        return true;
      }
      if ((a-c)*(a-c) + (b-d)*(b-d) <= r*r) {
        return true;
      }
      if (c*a + d*b >= 0 && c*a + d*b <= a*a + b*b) {
        return true;
      }
    }
    return false;
  }

  public float playerDist(Player p1, Player p2) {
    return dist(p1.x, p1.y, p2.x, p2.y);
  }

  private void healAllPlayers() {
    for (Player player : players) {
      player.respawn();
    }
  }

  private void drawPlayers() {
    for (Player player : players) {
      player.display();
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
    return frameCount - lastPowerUpSpawn >= POWER_UP_SPAWN_DELAY && powerUps.size() < 3;
  }

  private PowerUp getRandomPowerUp() {
    float x = random(width - 100) + 50;
    float y = random(height - 100) + 50;
    int type = int(random(7));
    return new PowerUp(x, y, type);
  }

  private void spawnPowerUp() {
    PowerUp powerUp = getRandomPowerUp();
    powerUps.add(powerUp);
    lastPowerUpSpawn = frameCount;
  }
}

