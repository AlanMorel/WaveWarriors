public class Enemy extends Entity {

  public float speed;
  private int waveNum;

  // Each enemy will have its own favored position from which to attack the player (e.g., 50 pixels east and 40 pixels north of the nearest player)
  private int xTargetOffset;
  private int yTargetOffset;

  // The enemy will occasionally change it's aforementioned favored attack position, allowing for more realistic movement.
  private int framesBeforeUpdatingTarget;
  private int frameNumber;

  public float rFillColor;
  public float gFillColor;
  public float bFillColor;

  public ArrayList<Bullet> firedBullets;
  public int fireDelay;
  public float bulletSpeed;
  public float shootingMarginOfError;

  public static final float BASE_BULLET_SPEED = 2;
  public static final float BULLET_SPEED_FACTOR = 0.05;

  public static final int BASE_HEALTH = 100;
  public static final int HEALTH_FACTOR = 5;

  public static final int ENEMY_RADIUS = 25;
  public static final float MAX_COLOR_VALUE = 100;

  public static final float WAVE_SPEED_FACTOR = 0.05;
  public static final float SPEED_TO_REACH_SCREEN = 1;
  public static final float MINIMUM_SPEED = 0.1;
  public static final float MAXIMUM_SPEED = 1.0;

  public static final float HP_BAR_HEIGHT = 10.0;
  public static final float HP_BAR_DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float HP_BAR_ROUNDED_CORNER_RADIUS = 3;

  public Enemy(final int waveNum, final float x, final float y) {
    super(x, y, (int)(BASE_HEALTH + waveNum * HEALTH_FACTOR), ENEMY_RADIUS * 2);
        
    this.speed = getEnemySpeedForWave(waveNum);
    this.shootingMarginOfError = getShootingMarginOfErrorForWave(waveNum);
    this.bulletSpeed = getBulletSpeedForWave(waveNum);
    
    this.rFillColor = random(MAX_COLOR_VALUE);
    this.gFillColor = random(MAX_COLOR_VALUE);
    this.bFillColor = random(MAX_COLOR_VALUE);

    this.firedBullets = new ArrayList<Bullet>();
    
    updateFireDelay();
    setNewTargetPosition();
  }
  
  // Display Methods
  public void display() {
    fill(rFillColor, gFillColor, bFillColor);
    stroke(0);
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
  }
  
  public void displayFiredBullets() {
    for (final Bullet b : firedBullets) {
      b.display();
    }
  }
  
  private void displayHealthBar() {
    final float hpBarX = x;
    final float hpBarY = y - radius - HP_BAR_HEIGHT - HP_BAR_DISTANCE_ABOVE_ENEMY;

    stroke(0);
    strokeWeight(1.5);
    rectMode(CORNER);

    fill(0, 0, 0);
    final float barWidth = radius*2;
    rect(hpBarX - barWidth/2, hpBarY, barWidth, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);

    setHPBarColor();
    final float remainingHealthWidth = radius*hp/maxHp * 2;
    rect(hpBarX - barWidth/2, hpBarY, remainingHealthWidth, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);
  }

  // Update Methods
  public void update() {
    advanceToNearestAlivePlayer();
    updateShootingStatus();
  }

  public void updateFireDelay() {
    fireDelay = (int)random(100, 500);
  }

  public void updateShootingStatus() {
    if (--fireDelay == 0) {
      fireAtPlayer(getNearestAlivePlayer());
      updateFireDelay();
    }
  }



  public void fireAtPlayer(Player player) {
    if (player == null) {
      println("Cannot fire at nearest player - no players detected."); 
      return;
    }
    
    float direction = (float) (Math.atan2(player.y - y, player.x - x) * 180.0 / Math.PI);
    final Bullet bullet = new Bullet(rFillColor, gFillColor, bFillColor);
    bullet.setPosition(x, y);
    bullet.setVelocity(bulletSpeed, direction);
    firedBullets.add(bullet);
  }
  
  private ArrayList<Bullet> getFiredBullets() {
    return firedBullets; 
  }
  
  public void hitByBullet() {
    hp -= 25;
  }
  
  public void hitByLaser() {
    hp -= 5;
  }
  
  public void hitByNuke() {
    hp -= maxHp / 2;
  }
  
  // Movement methods
  public void advanceToNearestAlivePlayer() {
    if (frameNumber++ >= framesBeforeUpdatingTarget) {
      setNewTargetPosition();
    }

    Player nearestPlayer = getNearestAlivePlayer();

    if (nearestPlayer == null) {
      println("Cannot fire at nearest player - no players detected."); 
      return;
    }
    
    float deltaY = y - (nearestPlayer.y + yTargetOffset);
    float deltaX = x - (nearestPlayer.x + xTargetOffset);
    float direction  = atan2(deltaY, deltaX);

    boolean hasReachedTargetPosition = (abs(deltaX) < 0.9) && (abs(deltaY) < 0.9);
    if (!hasReachedTargetPosition) {
      x = constrain(x - (speed*cos(direction)), (radius + 11), width - (radius + 11));
      y = constrain(y - (speed*sin(direction)), (radius + 11), height - (radius + 11));
    }
  }
  
  private void advanceToScreen() {
    if (x < (radius + 10)) {
      x += SPEED_TO_REACH_SCREEN;
    } else if (x > width - (radius + 10)) {
      x -= SPEED_TO_REACH_SCREEN;
    }

    if (y < (radius + 10)) {
      y += SPEED_TO_REACH_SCREEN;
    } else if (y > height - (radius + 10)) {
      y -= SPEED_TO_REACH_SCREEN;
    }
  }

  private Player getNearestAlivePlayer() {
    Player closestPlayer = null;
    float minDistance = Integer.MAX_VALUE;
    for (Player player : game.players) {
      if (player == null || player.down) {
        continue;
      }
      final float distanceFromPlayer = dist(x, y, player.x, player.y);
      if (distanceFromPlayer < minDistance) {
        minDistance = distanceFromPlayer;
        closestPlayer = player;
      }
    }
    return closestPlayer;
  }

  public void setNewTargetPosition() {
    this.frameNumber = 0;
    this.framesBeforeUpdatingTarget = (int)random(180, 660); 
    this.xTargetOffset = (int)random(-350, 350);
    this.yTargetOffset = (int)random(-200, 200);
  }

  // Calculation Methods
  public float getBulletSpeedForWave(final int waveNum) {
    return BASE_BULLET_SPEED + (BULLET_SPEED_FACTOR * waveNum);
  }
  
  public float getShootingMarginOfErrorForWave(final int waveNum) {
    final float numerator = pow((waveNum + 17), 2);
    final float denominator = pow(1.1, waveNum + 17) - 1;
    return numerator / denominator;  // The margin of error gradually decreases, as wave increases.
  }
  
  public float getEnemySpeedForWave(final int waveNum) {
    return random(MINIMUM_SPEED, MAXIMUM_SPEED) + (waveNum * WAVE_SPEED_FACTOR);
  }
  
  // Helper Methods
  private boolean isOnScreen() {
    return (x > (radius + 10)) && (x < width - (radius + 10)) && (y > (radius + 10)) && (y < height - (radius + 10));
  }
}

