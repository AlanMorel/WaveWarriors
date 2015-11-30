public class Game {

  private PImage background;
  public ArrayList<Player> players;
  private boolean paused;
  
  private boolean isIntroducingWave;
  private Wave wave;
  private int waveLevel;
  private int waveLevelFontTransparency;
  
  PFont waveFont;

  public static final int FIRST_WAVE_LEVEL = 1;
  public static final int BASE_FONT_SIZE = 100;
  public static final int MAX_FONT_OPACITY = 180;

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
    this.waveFont = loadFont("Silom-100.vlw");
    this.waveLevelFontTransparency = 0;
    
    this.isIntroducingWave = true;
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
    
    updateWaveFont();
    updateIntroductionStatus();
    checkCollisions();
    
    if (!isIntroducingWave) {
      updateWave();  // Don' allow wave to advance while introductory text is on screen
    }
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
      waveLevelFontTransparency++;
    } else {
      waveLevelFontTransparency = 0; 
    }
  }
  
  private void updateIntroductionStatus() {
    if (waveLevelFontTransparency >= MAX_FONT_OPACITY) {
      isIntroducingWave = false;
      waveLevelFontTransparency = 0;
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
  
  private void introduceWave(final int waveLevel) {
    drawTransparentScreenWithFill(255, 150 - waveLevelFontTransparency);
    textAlign(CENTER);
    textFont(waveFont, BASE_FONT_SIZE + 50);
    fill(255, 229, 128, waveLevelFontTransparency);
    text("W a v e", width/2, height/2 - 100);
    text("#" + waveLevel, width/2, height/2 + 100);
  }
  
  private void drawTransparentScreenWithFill(float r, float g, float b, float t) {
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    t = constrain(t, 0, 255);
    noStroke();
    fill(r, g, b, t);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
  }
  
  private void drawTransparentScreenWithFill(float black, float t) {
    black = constrain(black, 0, 255);
    t = constrain(t, 0, 255);
    noStroke();
    fill(black, t);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
  }
}

