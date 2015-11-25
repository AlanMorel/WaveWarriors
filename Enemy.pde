public class Enemy extends Entity {

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

  private ArrayList<Bullet> bullets;
  private int fireDelay;

  public static final float BASE_BULLET_SPEED = 2;
  public static final int BULLET_SPEED_FACTOR = 2;

  public static final int BASE_HEALTH = 5;
  public static final int HEALTH_FACTOR = 2;

  public static final int ENEMY_RADIUS = 50;
  public static final float MAX_COLOR_VALUE = 90;

  public static final float SPEED_FACTOR = 1.1;
  public static final float SPEED_TO_REACH_SCREEN_FACTOR = 1.4;
  public static final float SPEED_WILDCARD = 0.4;

  public static final float HP_BAR_HEIGHT = 10.0;
  public static final float HP_BAR_DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float HP_BAR_ROUNDED_CORNER_RADIUS = 3;
  public static final float HP_BAR_WIDTH_FACTOR = 4.5;

  public Enemy(final int wave, final float x, final float y) {
    super(x, y, BASE_HEALTH + wave * HEALTH_FACTOR, ENEMY_RADIUS);

    this.speed = random(-SPEED_WILDCARD * wave, SPEED_WILDCARD * wave) * SPEED_FACTOR;
    this.wave = wave;

    this.rFillColor = random(MAX_COLOR_VALUE);
    this.gFillColor = random(MAX_COLOR_VALUE);
    this.bFillColor = random(MAX_COLOR_VALUE);

    bullets = new ArrayList<Bullet>();
    updateFireDelay();

    setNewTargetPosition();
  }

  public void makeBestMovement(final Player[] players) {
    advanceToNearestPlayer();
    updateShootingStatus();
  }

  public void retreatFromNearestPlayer() {
    final Player nearestPlayer = getNearestPlayer();
    final float deltaY = y - (nearestPlayer.y + yTargetOffset);
    final float deltaX = x - (nearestPlayer.x + xTargetOffset);
    final float direction  = atan2(deltaY, deltaX);

    x = constrain(x + (speed*cos(direction)), (radius + 11), width - (radius + 11));
    y = constrain(y + (speed*sin(direction)), (radius + 11), height - (radius + 11));
  }

  public void updateFireDelay() {
    fireDelay = (int)random(100, 300);
  }

  public void updateShootingStatus() {
    if ((--fireDelay == 0)) {
      fireAtNearestPlayer();
      updateFireDelay();
    }
  }

  public void fireAtNearestPlayer() {
    Player nearestPlayer = getNearestPlayer();

    Bullet bullet = new Bullet(x, y, BASE_BULLET_SPEED + wave*BULLET_SPEED_FACTOR, getBulletAccuracy());
    bullets.add(bullet);
    bullet.fireAtPlayer(nearestPlayer);
  }

  public void draw() {
    drawEnemy();
  }

  private void drawEnemy() {
    fill(rFillColor, gFillColor, bFillColor);
    stroke(0);
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
  }

  public void advanceToNearestPlayer() {
    if (frameNumber++ >= framesBeforeUpdatingTarget) {
      setNewTargetPosition();
    }

    Player nearestPlayer = getNearestPlayer();
    float deltaY = y - (nearestPlayer.y + yTargetOffset);
    float deltaX = x - (nearestPlayer.x + xTargetOffset);
    float direction  = atan2(deltaY, deltaX);

    boolean hasReachedTargetPosition = (abs(deltaX) < 0.9) && (abs(deltaY) < 0.9);
    if (!hasReachedTargetPosition) {
      x = constrain(x - (speed*cos(direction)), (radius + 11), width - (radius + 11));
      y = constrain(y - (speed*sin(direction)), (radius + 11), height - (radius + 11));
    }
  }

  private Player getNearestPlayer() {

    Player closestPlayer = game.players[0];
    float minDistance = dist(x, y, closestPlayer.x, closestPlayer.y);

    for (int id = 0; id < 4; id++) {
      if (game.players[id] == null) {
        continue;
      }
      float distanceFromPlayer = dist(x, y, game.players[id].x, game.players[id].y);
      if (distanceFromPlayer < minDistance) {
        minDistance = distanceFromPlayer;
        closestPlayer = game.players[id];
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

  private void advanceToScreen() {
    if (x < (radius + 10)) {
      x += speed * SPEED_TO_REACH_SCREEN_FACTOR;
    } else if (x > width - (radius + 10)) {
      x -= speed * SPEED_TO_REACH_SCREEN_FACTOR;
    }

    if (y < (radius + 10)) {
      y += speed * SPEED_TO_REACH_SCREEN_FACTOR;
    } else if (y > height - (radius + 10)) {
      y -= speed * SPEED_TO_REACH_SCREEN_FACTOR;
    }
  }

  private void displayHealthBar() {
    final float hpBarX = x;
    final float hpBarY = y - radius - HP_BAR_HEIGHT - HP_BAR_DISTANCE_ABOVE_ENEMY;

    stroke(0);
    strokeWeight(1.5);
    rectMode(CORNER);

    fill(255, 102, 102);
    rect(hpBarX, hpBarY, maxHp * HP_BAR_WIDTH_FACTOR, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);

    fill(77, 255, 136);
    rect(hpBarX, hpBarY, hp * HP_BAR_WIDTH_FACTOR, HP_BAR_HEIGHT, HP_BAR_ROUNDED_CORNER_RADIUS);
  }

  public void hit() {
    hp -= 1;
  }

  public void drawBullets() {
    for (Bullet bullet : bullets) {
      bullet.draw();
    }
  }

  public int getBulletAccuracy() {
    if (wave <= 3) {
      return Bullet.LOW_ACCURACY;
    } else if (wave <= 7) {
      return Bullet.MEDIUM_ACCURACY;
    } else {
      return Bullet.HIGH_ACCURACY;
    }
  }

  private boolean isOnScreen() {
    return (x > (radius + 10)) && (x < width - (radius + 10)) && (y > (radius + 10)) && (y < height - (radius + 10));
  }
}

