public class Wave {
  
  private Game game;
  public ArrayList<Enemy> enemies;

  public static final int BASE_NUMBER_OF_ENEMIES = 2;
  public static final float ENEMIES_PER_WAVE_FACTOR = 3.0;

  public Wave(final Game game, final int waveNum) {
    this.game = game;
    this.enemies = new ArrayList<Enemy>();
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

      boolean enemySpawnsOnSide = randomBoolean();
      
      if (enemySpawnsOnSide) {
        yPos = random(0, height);
        boolean left = randomBoolean();
        xPos = left ? random(-200, -75) : random(width + 75, width + 200);
      } else {
        xPos = random(0, height);
        boolean top = randomBoolean();
        yPos = top ? random(-200, -75) : random(height + 75, height + 200);
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
    return enemies.size() == 0;
  }
}

