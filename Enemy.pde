public class Enemy extends Entity {

  private int id;
  private int remainingHealth;
  private float speed;
  private int wave;
  
  // Each enemy will have its own favored position from which to attack the player (e.g., 50 pixels east and 40 pixels north of the nearest player)
  private float xTargetOffset;
  private float yTargetOffset;
  
  // The enemy will occasionally change it's aforementioned favored attack position, allowing for more realistic movement.
  private int framesBeforeUpdatingTarget;
  private int frameNumber;
  
  public static final int ENEMY_RADIUS = 50;
  public static final int HEALTH_FACTOR = 10;
  public static final float SPEED_FACTOR = 1.4;
  public static final float SPEED_WILDCARD = 0.9;

  public Enemy(int wave, int id, float x, float y) {
    super(x, y, (int)wave*HEALTH_FACTOR, ENEMY_RADIUS);
    this.id = id;
    this.remainingHealth = hp;
    this.speed = (wave + random(-SPEED_WILDCARD, SPEED_WILDCARD)) * SPEED_FACTOR;
    this.wave = wave;
    
    setTargetPosition();
  }

  public void draw() {
    drawEnemy();
    drawHealthBar();
  }

  private void drawEnemy() {
    fill(0);
    stroke(255);
    strokeWeight(5);
    ellipse(x, y, radius*2, radius*2);
  }

  private void drawHealthBar() {
    fill(0, 0, 0, 255);
    textAlign(CENTER);
    textSize(16);
    
  }
  
  public void advanceToNearestPlayer(final Player[] players) {
    updateTargetPosition();
    
    final Player nearestPlayer = getNearestPlayer(players);
    final float deltaY = y - (nearestPlayer.y + yTargetOffset);
    final float deltaX = x - (nearestPlayer.x + xTargetOffset);
    final float direction  = atan2(deltaY, deltaX);
    
    x = constrain(x - speed*cos(direction), radius, width - radius);
    y = constrain(y - speed*sin(direction), radius, height - radius);
  }
  
  private Player getNearestPlayer(final Player[] players) {
    if (players.length < 1) {
      System.out.println("Error: No players detected.");
      return null; 
    }
    
    Player closestPlayer = players[0];
    float minPlayerDistance = dist(x, y, closestPlayer.x, closestPlayer.y);
      
    for (int p = 0; p < game.numPlayers; p++) {
      final float distanceFromPlayer = dist(x, y, players[p].x, players[p].y);
      if (distanceFromPlayer < minPlayerDistance) {
        minPlayerDistance = distanceFromPlayer;
        closestPlayer = players[p]; 
      }
    }
    
    return closestPlayer; 
  }
  
  private void updateTargetPosition() {
    if (frameNumber++ >= framesBeforeUpdatingTarget) {
      setTargetPosition();
    }
  }
  
  private void setTargetPosition() {
    this.frameNumber = 0;
    this.framesBeforeUpdatingTarget = (int)random(300, 800); 
    this.xTargetOffset = random(-500, 500);
    this.yTargetOffset = random(-500, 500);
  }
  
  private void advanceOntoScreen() {
    if (x < radius) {
      x += speed;
    } else if (x > width + radius) {
      x -= speed; 
    }
    
    if (y < radius) {
      y += speed; 
    } else if (y > height + radius) {
      y -= speed;
    }
  }
  
  private boolean noHealthLeft() {
    return remainingHealth <= 0; 
  }
}

