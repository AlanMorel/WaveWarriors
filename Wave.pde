public class Wave {
  private boolean isDefeated;
  private Game game;
  private int waveNum;
  private int numEnemies;
  private ArrayList<Enemy> enemies;
  
  public static final int BASE_NUMBER_OF_ENEMIES = 2;
  public static final float ENEMIES_PER_WAVE_FACTOR = 3.0;
 
  Wave(final Game game, final int waveNum) {
    this.game = game;
    final boolean waveNumIsValid = waveNum >= 1;  // Wave number must be positive
    this.isDefeated = false;
    this.waveNum = waveNumIsValid ? waveNum: 1;
    this.numEnemies = BASE_NUMBER_OF_ENEMIES + (int)(waveNum*ENEMIES_PER_WAVE_FACTOR);
    this.enemies = new ArrayList<Enemy>();
    createEnemies();
  }
  
  public void display() {
    removeDeadEnemies();
    advanceEnemies();
    drawEnemies();
    drawEnemyHealthBars();
    drawBullets();
  }
  
  private void createEnemies() {
    for (int id = 0; id < numEnemies; id++) {
      float xPos = -1;
      float yPos = -1;
      
      final boolean enemySpawnsOnSide = randomBoolean();
      if (enemySpawnsOnSide) {
        yPos = random(0, height);
        final boolean enemySpawnsOnLeft = randomBoolean();
        xPos = enemySpawnsOnLeft ? random(-200, -75) : random(width + 75, width + 200);
      } else {
        xPos = random(0, height);
        final boolean enemySpawnsOnTop = randomBoolean();
        yPos = enemySpawnsOnTop ? random(-200, -75) : random(height + 75, height + 200);
      }
      
      enemies.add(new Enemy(game, waveNum, id, xPos, yPos));
    }
  }
  
  private void advanceEnemies() {
    for (final Enemy e : enemies) {
      if (enemyIsOnScreen(e)) {
        e.makeBestMovement(game.getPlayers());
      } else {
        e.advanceOntoScreen();
      }
    }
  }
  
  private boolean randomBoolean() {
    return random(100) > 50;
  }
  
  private boolean enemyIsOnScreen(final Enemy e) {
    final boolean withinVerticalSides = (e.x > (e.radius + 10)) && (e.x < width - (e.radius + 10));
    final boolean withinHorizontalSides = (e.y > (e.radius + 10)) && (e.y < height - (e.radius + 10));
    return withinVerticalSides && withinHorizontalSides;
  }
  
  private void removeDeadEnemies() {
    for (final Enemy e : enemies) {
      if (e.noHealthLeft()) {
        enemies.remove(e); 
      }
    }
  }
  
  private void drawEnemies() {
    for (final Enemy e : enemies) {
      e.draw(); 
    }
  }
  
  private void drawEnemyHealthBars() {
    for (final Enemy e : enemies) {
      e.displayHealthBar();
    } 
  }
  
  private void drawBullets() {
    for (final Enemy e : enemies) {
      e.displayActiveBullets();
    } 
  }
}
