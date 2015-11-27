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
    removeDeadEnemies();
    advanceEnemies();
  }

  public void draw() {
    drawEnemies();
    drawEnemyHealthBars();
    drawBullets();
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

  private void advanceEnemies() {
    for (Enemy enemy : enemies) {
      if (enemy.isOnScreen()) {
        enemy.makeBestMovement(game.players);
      } else {
        enemy.advanceToScreen();
      }
    }
  }

  private boolean randomBoolean() {
    return random(1) > .5;
  }

  private void removeDeadEnemies() {
    ArrayList<Enemy> toRemove = new ArrayList<Enemy>();
    for (Enemy enemy : enemies) {
      if (enemy.isDead()) {
        toRemove.add(enemy);
      }
    }
    for (Enemy enemy : toRemove) {
      enemies.remove(enemy);
    }
  }

  private void drawEnemies() {
    for (Enemy enemy : enemies) {
      enemy.draw();
    }
  }

  private void drawEnemyHealthBars() {
    for (Enemy enemy : enemies) {
      enemy.displayHealthBar();
    }
  }

  private void drawBullets() {
    for (Enemy enemy : enemies) {
      enemy.drawBullets();
    }
  }
  
  public boolean isDefeated() {
    return enemies.size() == 0;
  }
}

