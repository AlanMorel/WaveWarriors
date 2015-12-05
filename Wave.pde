public class Wave {
  
  public ArrayList<Enemy> enemies;
  
  private int waveNum;
  
  public static final int BASE_NUMBER_OF_ENEMIES = 3;
  public static final int ENEMIES_PER_WAVE_FACTOR = 1;
  public static final int MAXIMUM_DISTANCE_AWAY_FROM_SCREEN = 500;
  public static final int MINIMUM_DISTANCE_AWAY_FROM_SCREEN = 100;

  public Wave(final int waveNum) {
    this.enemies = new ArrayList<Enemy>();
    this.waveNum = waveNum;
    createEnemies(waveNum);
  }

  public void update() {
    updateEnemies();
    updateFiredBullets();
  }

  public void display() {
    displayEnemies();
    displayEnemyHealthBars();
    displayFiredBullets();
  }

  private void createEnemies(int waveNum) {
    for (int id = 0; id < BASE_NUMBER_OF_ENEMIES + (int) (waveNum*ENEMIES_PER_WAVE_FACTOR); id++) {
      float xPos = -1;
      float yPos = -1;

      final boolean enemySpawnsOnSide = randomBoolean();
      if (enemySpawnsOnSide) {
        yPos = random(0, height);
        final boolean left = randomBoolean();
        xPos = left ? random(-MAXIMUM_DISTANCE_AWAY_FROM_SCREEN, -MINIMUM_DISTANCE_AWAY_FROM_SCREEN) : 
            random(width + MINIMUM_DISTANCE_AWAY_FROM_SCREEN, width + MAXIMUM_DISTANCE_AWAY_FROM_SCREEN);
      } else {
        xPos = random(0, height);
        final boolean top = randomBoolean();
        yPos = top ? random(-MAXIMUM_DISTANCE_AWAY_FROM_SCREEN, -MINIMUM_DISTANCE_AWAY_FROM_SCREEN) : 
            random(height + MINIMUM_DISTANCE_AWAY_FROM_SCREEN, height + MAXIMUM_DISTANCE_AWAY_FROM_SCREEN);
      }

      enemies.add(new Enemy(waveNum, xPos, yPos));
    }
  }

  private void updateEnemies() {
    removeDeadEnemies();
    for (final Enemy e : enemies) {
      if (e.isOnScreen()) {
        e.update();
      } else {
        e.advanceToScreen();
      }
    }
  }

  private boolean randomBoolean() {
    return random(1) > .5;
  }

  private void removeDeadEnemies() {
    final ArrayList<Enemy> deadEnemies = new ArrayList<Enemy>();
    for (final Enemy e : enemies) {
      if (e.isDead()) {
        deadEnemies.add(e);
      }
    }
    enemies.removeAll(deadEnemies);
  }

  private void displayEnemies() {
    for (final Enemy e : enemies) {
      e.display();
    }
  }

  private void displayEnemyHealthBars() {
    for (Enemy enemy : enemies) {
      enemy.displayHealthBar();
    }
  }

  private void displayFiredBullets() {
    for (final Enemy e : enemies) {
      e.displayFiredBullets();
    }
  }
  
  private void updateFiredBullets() {
    for (final Enemy e : enemies) {
      for (final Bullet b : e.getFiredBullets()) {
        b.update(); 
      }
    } 
  }
  
  public boolean isDefeated() {
    return enemies.isEmpty();
  }
  
  public int getWaveNum() {
    return this.waveNum;
  }
}

