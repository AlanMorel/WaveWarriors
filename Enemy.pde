public class Enemy extends Entity {
  
  private int id;
  private int remainingHealth;
  private float speed;
  private int wave;
  
  // Each enemy will have its own favored position from which to attack the player (e.g., 50 pixels east and 40 pixels north of the nearest player)
  private int xTargetOffset;
  private int yTargetOffset;
  
  // The enemy will occasionally change it's aforementioned favored attack position, allowing for more realistic movement.
  private int framesBeforeUpdatingTarget;
  private int frameNumber;
  
  private float rFillColor;
  private float gFillColor;
  private float bFillColor;
  
  public static final int BASE_HEALTH = 5;
  public static final int ENEMY_RADIUS = 50;
  public static final int HEALTH_FACTOR = 2;
  public static final float MAX_COLOR_VALUE = 90;
  public static final float SPEED_FACTOR = 1.1;
  public static final float SPEED_TO_REACH_SCREEN_FACTOR = 1.4;  // Causes slower enemies to more quickly reach the battleground.
  public static final float SPEED_WILDCARD = 0.4;
  
  public static final float HP_BAR_HEIGHT = 10.0;
  public static final float HP_BAR_DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float HP_BAR_ROUNDED_CORNER_RADIUS = 20;
  public static final float HP_BAR_WIDTH_FACTOR = 4.5;

  public Enemy(int wave, int id, float x, float y) {
    super(x, y, BASE_HEALTH + (int)wave*HEALTH_FACTOR, ENEMY_RADIUS);
    this.id = id;
    this.remainingHealth = hp;
    this.speed = random(-SPEED_WILDCARD*wave, SPEED_WILDCARD*wave)*SPEED_FACTOR;
    this.wave = wave;
    
    this.rFillColor = random(MAX_COLOR_VALUE);
    this.gFillColor = random(MAX_COLOR_VALUE);
    this.bFillColor = random(MAX_COLOR_VALUE);
    
    setNewTargetPosition();
  }

  public void draw() {
    drawEnemy();
  }

  private void drawEnemy() {
    fill(rFillColor, gFillColor, bFillColor);
    stroke(255);
    strokeWeight(5);
    ellipse(x, y, radius*2, radius*2);
  }

  public void advanceToNearestPlayer(final Player[] players) {
    if (frameNumber++ >= framesBeforeUpdatingTarget) {
      setNewTargetPosition();
    }
        
    final Player nearestPlayer = getNearestPlayer(players);
    final float deltaY = y - (nearestPlayer.y + yTargetOffset);
    final float deltaX = x - (nearestPlayer.x + xTargetOffset);
    final float direction  = atan2(deltaY, deltaX);
    
    final boolean hasReachedTargetPosition = (abs(deltaX) < 0.9) && (abs(deltaY) < 0.9);
    if (!hasReachedTargetPosition) {
      x = constrain(x - (speed*cos(direction)), (radius + 11), width - (radius + 11));
      y = constrain(y - (speed*sin(direction)), (radius + 11), height - (radius + 11));
    }
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

  private void setNewTargetPosition() {
    this.frameNumber = 0;
    this.framesBeforeUpdatingTarget = (int)random(180, 660); 
    this.xTargetOffset = (int)random(-350, 350);
    this.yTargetOffset = (int)random(-200, 200);
  }
  
  private void advanceOntoScreen() {
    if (x < (radius + 10)) {
      x += speed*SPEED_TO_REACH_SCREEN_FACTOR;
    } else if (x > width - (radius + 10)) {
      x -= speed*SPEED_TO_REACH_SCREEN_FACTOR; 
    }
    
    if (y < (radius + 10)) {
      y += speed*SPEED_TO_REACH_SCREEN_FACTOR; 
    } else if (y > height - (radius + 10)) {
      y -= speed*SPEED_TO_REACH_SCREEN_FACTOR;
    }
  }
  
  private void displayHealthBar() {
    final float hpCapacity = getRemainingHP();
    final float barPositionX = x;
    final float barPositionY = y - radius - HP_BAR_HEIGHT - HP_BAR_DISTANCE_ABOVE_ENEMY;
    
    stroke(0);
    strokeWeight(1.5);
    fill(255, 102, 102);
    rectMode(CORNER);
    rect(barPositionX, barPositionY, hpCapacity*HP_BAR_WIDTH_FACTOR, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);
  
    drawRemainingHPBar(getRemainingHP(), barPositionX, barPositionY);  
  }
  
  private void drawRemainingHPBar(float hpRemaining, float barPositionX, float barPositionY) {
    strokeWeight(0);
    fill(77, 255, 136);
    rect(barPositionX, barPositionY, hpRemaining*HP_BAR_WIDTH_FACTOR, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);
  }
  
  private boolean noHealthLeft() {
    return remainingHealth <= 0; 
  }
  
  public int getRemainingHP() {
    return remainingHealth; 
  }
  
  public int getHPCapacity() {
    return hp;
  }
}

