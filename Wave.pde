public class Wave {
  private boolean isDefeated;
  private Game game;
  private int waveNum;
  private int numEnemies;
  private ArrayList<Enemy> enemies;
  
  public static final int BASE_NUMBER_OF_ENEMIES = 10;
  public static final float ENEMIES_PER_WAVE_FACTOR = 6.0;
 
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
    updateEnemies();
    drawEnemies();
  }
  
  private void createEnemies() {
    for (int id = 0; id < numEnemies; id++) {
      float xPos = -1;
      float yPos = -1;
      
      final boolean enemySpawnsOnSide = randomBoolean();
      if (enemySpawnsOnSide) {
        yPos = random(0, height);
        final boolean enemySpawnsOnLeft = randomBoolean();
        xPos = enemySpawnsOnLeft ? random(-300, -50) : random(width + 50, width + 300);
      } else {
        xPos = random(0, height);
        final boolean enemySpawnsOnTop = randomBoolean();
        yPos = enemySpawnsOnTop ? random(-300, -50) : random(height + 50, height + 300);
      }
      
      enemies.add(new Enemy(this.waveNum, id, xPos, yPos));
    }
  }
  
  private void advanceEnemies() {
    for (final Enemy e : enemies) {
      if (enemyIsOnScreen(e)) {
        e.advanceToNearestPlayer(game.getPlayers());
      } else {
        e.advanceOntoScreen();
      }
      println("xPos " + e.x + ", yPos " + e.y);
    }
  }
  
  private boolean randomBoolean() {
    return random(100) > 50;
  }
  
  private boolean enemyIsOnScreen(final Enemy e) {
    final boolean withinVerticalSides = e.x > e.radius && e.x < width - e.radius;
    final boolean withinHorizontalSides = e.y > e.radius && e.y < height - e.radius;
    return withinVerticalSides && withinHorizontalSides;
  }
  
  private void updateEnemies() {
    for (final Enemy e : enemies) {
      if (e.noHealthLeft()) {
        enemies.remove(e); 
      }
    }
    
    advanceEnemies();
  }
  
  private void drawEnemies() {
    for (final Enemy e : enemies) {
      e.draw(); 
    }
  }
}
