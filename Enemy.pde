public class Enemy extends Entity {

  private float speed;
  private int waveNum;

  // Each enemy will have its own favored position from which to attack the player (e.g., 50 pixels east and 40 pixels north of the nearest player)
  private int xTargetOffset;
  private int yTargetOffset;

  // The enemy will occasionally change it's aforementioned favored attack position, allowing for more realistic movement.
  private int framesBeforeUpdatingTarget;
  private int frameNumber;

  private float rFillColor;
  private float gFillColor;
  private float bFillColor;

  private ArrayList<Bullet> firedBullets;
  private ArrayList<Bullet> magazine;
  private int fireDelay;
  private float bulletSpeed;
  private float shootingMarginOfError;

  public static final float BASE_BULLET_SPEED = 2;
  public static final int BULLET_SPEED_FACTOR = 0.2;

  public static final int BASE_HEALTH = 4;
  public static final int HEALTH_FACTOR = 1;

  public static final int ENEMY_RADIUS = 50;
  public static final float MAX_COLOR_VALUE = 90;

  public static final float WAVE_SPEED_FACTOR = 0.15;
  public static final float SPEED_TO_REACH_SCREEN = 0.8;
  public static final float MINIMUM_SPEED = 0.1;
  public static final float MAXIMUM_SPEED = 1.1;

  public static final int MAGAZINE_CAPACITY = 15;

  public static final float HP_BAR_HEIGHT = 10.0;
  public static final float HP_BAR_DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float HP_BAR_ROUNDED_CORNER_RADIUS = 3;
  public static final float HP_BAR_WIDTH_FACTOR = 4.5;

  public Enemy(final int waveNum, final float x, final float y) {
    final float hpCapacity = getHpCapacity();
    super(x, y, hpCapacity, ENEMY_RADIUS);
    this.waveNum = waveNum;
        
    this.speed = getSpeed();
    this.shootingMarginOfError = getShootingMarginOfError();
    this.bulletSpeed = getBulletSpeed();
    
    this.rFillColor = random(MAX_COLOR_VALUE);
    this.gFillColor = random(MAX_COLOR_VALUE);
    this.bFillColor = random(MAX_COLOR_VALUE);

    this.firedBullets = new ArrayList<Bullet>();
    this.magazine = new ArrayList<Bullet>();
    reloadMagazine();
    
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

    fill(255, 102, 102);
    final float barWidth = maxHp * HP_BAR_WIDTH_FACTOR;
    rect(hpBarX - barWidth/2, hpBarY, barWidth, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);

    fill(77, 255, 136);
    final float remainingHealthWidth = hp * HP_BAR_WIDTH_FACTOR;
    rect(hpBarX - barWidth/2, hpBarY, remainingHealthWidth, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);
  }



  // Update Methods
  public void update() {
    if (magazine.isEmpty()) {
      reloadMagazine(); 
    }
    advanceToNearestAlivePlayer();
    updateShootingStatus();
  }

  public void updateFireDelay() {
    fireDelay = (int)random(100, 300);
  }

  public void updateShootingStatus() {
    if ((--fireDelay == 0)) {
      fireAtNearestAlivePlayer();
      updateFireDelay();
    }
  }



  // Shooting Methods
  private Bullet getNextBullet() {
    if (magazine.isEmpty()) {
      reloadMagazine(); 
    }
    return magazine.remove(magazine.size() - 1);
  }
  
  public void fireAtNearestAlivePlayer() {
    final Player nearestPlayer = getNearestAlivePlayer();
    fireAtPlayer(nearestPlayer);
  }

  public void fireAtPlayer(final Player player) {
    final float targetX = player.x + random(-radius - marginOfError, radius + marginOfError);
    final float targetY = player.y + random(-radius - marginOfError, radius + marginOfError);

    final float deltaX = x - targetX;
    final float deltaY = y - targetY;
    final float direction = atan2(deltaY, deltaX);

    final Bullet bullet = getNextBullet();
    bullet.setPosition(x, y);
    bullet.setVelocity(bulletSpeed, direction);
    firedBullets.add(bullet);
  }
  
  private ArrayList<Bullet> getFiredBullets() {
    return firedBullets; 
  }
  
  private void reloadMagazine() {
    while(magazine.size() < MAGAZINE_CAPACITY) {
      magazine.add(new Bullet(rFillColor, gFillColor, bFillColor)); 
    }
  }
  
  public void hit() {
    hp -= 1;
  }
  


  // Movement methods
  public void advanceToNearestAlivePlayer() {
    if (frameNumber++ >= framesBeforeUpdatingTarget) {
      setNewTargetPosition();
    }

    Player nearestPlayer = getNearestAlivePlayer();
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
    Player closestPlayer = game.players.get(0);
    float minDistance = Integer.MAX_VALUE;
    for (final Player p : game.players) {
      if ((p == null) || (p.down)) {
        continue;
      }
      final float distanceFromPlayer = dist(x, y, p.x, p.y);
      if (distanceFromPlayer < minDistance) {
        minDistance = distanceFromPlayer;
        closestPlayer = p;
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

  
  
  // Calculation Methods
  public float getBulletSpeed() {
    return BASE_BULLET_SPEED + (BULLET_SPEED_FACTOR * waveNum);
  }
  
  public float getHpCapacity() {
    return BASE_HEALTH + waveNum * HEALTH_FACTOR;
  }
  
  public float getShootingMarginOfError() {
    final float numerator = pow((waveNum + 17), 2);
    final float denominator = pow(1.1, waveNum + 17) - 1;
    return numerator / denominator;  // The margin of error gradually decreases, as wave increases.
  }
  
  public float getSpeed() {
    return random(MINIMUM_SPEED, MAXIMUM_SPEED) + (waveNum * WAVE_SPEED_FACTOR);
  }
  
  
  
  // Helper Methods
  private boolean isOnScreen() {
    return (x > (radius + 10)) && (x < width - (radius + 10)) && (y > (radius + 10)) && (y < height - (radius + 10));
  }
}

