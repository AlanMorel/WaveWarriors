public class Wave {
  public ArrayList<Enemy> enemies;

  public static final int BASE_NUMBER_OF_ENEMIES = 2;
  public static final float ENEMIES_PER_WAVE_FACTOR = 3.0;
  public static final int MAXIMUM_DISTANCE_AWAY_FROM_SCREEN = 600;
  public static final int MINIMUM_DISTANCE_AWAY_FROM_SCREEN = 75;

  public Wave(final int waveNum) {
    this.enemies = new ArrayList<Enemy>();
    createEnemies(waveNum);
  }

  public void update() {
    updateEnemies();
<<<<<<< HEAD
    updateBullets();
=======
    updateFiredBullets();
>>>>>>> origin/master
  }

  public void display() {
    displayEnemies();
    displayEnemyHealthBars();
<<<<<<< HEAD
    displayBullets();
=======
    displayFiredBullets();
>>>>>>> origin/master
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
<<<<<<< HEAD
    for (Enemy enemy : enemies) {
      if (enemy.isDead()) {
        deadEnemies.add(enemy);
=======
    for (final Enemy e : enemies) {
      if (e.isDead()) {
        deadEnemies.add(e);
>>>>>>> origin/master
      }
    }
    enemies.removeAll(deadEnemies);
  }

  private void displayEnemies() {
<<<<<<< HEAD
    for (Enemy enemy : enemies) {
      enemy.display();
=======
    for (final Enemy e : enemies) {
      e.display();
>>>>>>> origin/master
    }
  }

  private void displayEnemyHealthBars() {
    for (Enemy enemy : enemies) {
      enemy.displayHealthBar();
    }
  }

<<<<<<< HEAD
  private void displayBullets() {
    for (Enemy enemy : enemies) {
      enemy.drawBullets();
    }
  }
  
  private void updateBullets() {
    for (Enemy enemy : enemies) {
      for (Bullet bullet : enemy.bullets) {
        bullet.update(); 
=======
  private void displayFiredBullets() {
    for (final Enemy e : enemies) {
      e.displayFiredBullets();
    }
  }
  
  private void updateFiredBullets() {
    for (final Enemy e : enemies) {
      for (final Bullet b : e.getFiredBullets()) {
        b.update(); 
>>>>>>> origin/master
      }
    } 
  }
  
  public boolean isDefeated() {
    return enemies.size() == 0;
  }
}

