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

<<<<<<< HEAD
  private ArrayList<Bullet> bullets;
=======
  private ArrayList<Bullet> firedBullets;
>>>>>>> origin/master
  private ArrayList<Bullet> magazine;
  private int fireDelay;
  private float bulletSpeed;

  public static final float BASE_BULLET_SPEED = 2;
  public static final int BULLET_SPEED_FACTOR = 1;

  public static final int BASE_HEALTH = 5;
  public static final int HEALTH_FACTOR = 2;

  public static final int ENEMY_RADIUS = 50;
  public static final float MAX_COLOR_VALUE = 90;

  public static final float WAVE_SPEED_FACTOR = 1.1;
  public static final float SPEED_TO_REACH_SCREEN = 0.8;
  public static final float MINIMUM_SPEED = 0.1;
  public static final float MAXIMUM_SPEED = 1;
<<<<<<< HEAD

  public static final int MAGAZINE_CAPACITY = 15;

=======
  
  public static final int MAGAZINE_CAPACITY = 15;
  
>>>>>>> origin/master
  public static final int LOW_ACCURACY = 1;
  public static final int MEDIUM_ACCURACY = 2;
  public static final int HIGH_ACCURACY = 3;

  public static final int LOW_ACCURACY_MARGIN_OF_ERROR = 175;
  public static final int MEDIUM_ACCURACY_MARGIN_OF_ERROR = 110;
  public static final int HIGH_ACCURACY_MARGIN_OF_ERROR = 75;

  // Players within these ranges will be hit with nearly 100% certainty.
  public static final int LOW_ACCURACY_CERTAIN_HIT_RANGE = 250;
  public static final int MEDIUM_ACCURACY_CERTAIN_HIT_RANGE = 400;
  public static final int HIGH_ACCURACY_CERTAIN_HIT_RANGE = 550;

  public static final float HP_BAR_HEIGHT = 10.0;
  public static final float HP_BAR_DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float HP_BAR_ROUNDED_CORNER_RADIUS = 3;
  public static final float HP_BAR_WIDTH_FACTOR = 4.5;

  public Enemy(final int wave, final float x, final float y) {
    super(x, y, BASE_HEALTH + wave * HEALTH_FACTOR, ENEMY_RADIUS);
    this.speed = (random(MINIMUM_SPEED, MAXIMUM_SPEED) * wave);
    println("Enemy speed:" + speed);
    this.wave = wave;
    
    this.rFillColor = random(MAX_COLOR_VALUE);
    this.gFillColor = random(MAX_COLOR_VALUE);
    this.bFillColor = random(MAX_COLOR_VALUE);

    this.bulletSpeed = BASE_BULLET_SPEED + (BULLET_SPEED_FACTOR * wave);
<<<<<<< HEAD
    this.bullets = new ArrayList<Bullet>();
    this.magazine = new ArrayList<Bullet>();
    reloadMagazine(magazine);

=======
    this.firedBullets = new ArrayList<Bullet>();
    this.magazine = new ArrayList<Bullet>();
    reloadMagazine(magazine);
    
>>>>>>> origin/master
    updateFireDelay();
    setNewTargetPosition();
  }
  
  public void display() {
    fill(rFillColor, gFillColor, bFillColor);
    stroke(0);
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
  }

<<<<<<< HEAD
  public void display() {
    fill(rFillColor, gFillColor, bFillColor);
    stroke(0);
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
  }

  public void update() {
    if (magazine.isEmpty()) {
      reloadMagazine(magazine);
=======
  public void update() {
    if (magazine.isEmpty()) {
      reloadMagazine(magazine); 
>>>>>>> origin/master
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

  public void fireAtNearestAlivePlayer() {
    final Player nearestPlayer = getNearestAlivePlayer();
    fireAtPlayer(nearestPlayer);
<<<<<<< HEAD
  }

  public void fireAtPlayer(final Player player) {
    if (magazine.isEmpty()) {
      reloadMagazine(magazine);
    }

    float targetX = player.x;
    float targetY = player.y;
    float range = dist(x, y, targetX, targetY);    

    if ((getFiringAccuracy() == LOW_ACCURACY) && (range > LOW_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
    } else if ((getFiringAccuracy() == MEDIUM_ACCURACY) && (range > MEDIUM_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
    } else if ((getFiringAccuracy() == HIGH_ACCURACY) && (range > HIGH_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
    }
    float deltaX = x - targetX;
    float deltaY = y - targetY;
    final float direction = atan2(deltaY, deltaX);

    final Bullet bullet = magazine.remove(magazine.size() - 1);
    bullet.setPosition(x, y);
    bullet.setVelocity(bulletSpeed, direction);
    bullets.add(bullet);
  }

=======
  }

  public void fireAtPlayer(final Player player) {
    if (magazine.isEmpty()) {
      reloadMagazine(magazine); 
    }
    
    float targetX = player.x;
    float targetY = player.y;
    float range = dist(x, y, targetX, targetY);    

    if ((getFiringAccuracy() == LOW_ACCURACY) && (range > LOW_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
    } else if ((getFiringAccuracy() == MEDIUM_ACCURACY) && (range > MEDIUM_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
    } else if ((getFiringAccuracy() == HIGH_ACCURACY) && (range > HIGH_ACCURACY_CERTAIN_HIT_RANGE)) {
      targetX = player.x + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
      targetY = player.y + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
    }
    float deltaX = x - targetX;
    float deltaY = y - targetY;
    final float direction = atan2(deltaY, deltaX);
    
    final Bullet bullet = magazine.remove(magazine.size() - 1);
    bullet.setPosition(x, y);
    bullet.setVelocity(bulletSpeed, direction);
    firedBullets.add(bullet);
  }
  
>>>>>>> origin/master
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

  private Player getNearestAlivePlayer() {
<<<<<<< HEAD
    Player closestPlayer = game.players.get(0);
    float minDistance = Integer.MAX_VALUE;
    for (Player player : game.players) {
      if (player.down) {
        continue;
      }
      float distanceFromPlayer = dist(x, y, player.x, player.y);
=======
    Player closestPlayer = game.players[0];
    float minDistance = Integer.MAX_VALUE;
    for (int i = 0; i < game.players.length; i++) {
      if ((game.players[i] == null) || (game.players[i].down)) {
        continue;
      }
      final float distanceFromPlayer = dist(x, y, game.players[i].x, game.players[i].y);
>>>>>>> origin/master
      if (distanceFromPlayer < minDistance) {
        minDistance = distanceFromPlayer;
        closestPlayer = player;
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

  private void reloadMagazine(final ArrayList<Bullet> magazine) {
<<<<<<< HEAD
    while (magazine.size () < MAGAZINE_CAPACITY) {
      magazine.add(new Bullet(rFillColor, gFillColor, bFillColor));
=======
    while(magazine.size() < MAGAZINE_CAPACITY) {
      magazine.add(new Bullet(rFillColor, gFillColor, bFillColor)); 
>>>>>>> origin/master
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

  public void hit() {
    hp -= 1;
  }

  public void displayFiredBullets() {
    for (final Bullet b : firedBullets) {
      b.display();
    }
  }

  public int getFiringAccuracy() {
    if (wave <= 3) {
      return LOW_ACCURACY;
    } else if (wave <= 7) {
      return MEDIUM_ACCURACY;
    } else {
      return HIGH_ACCURACY;
    }
  }
  
  private ArrayList<Bullet> getFiredBullets() {
    return firedBullets; 
  }

  private boolean isOnScreen() {
    return (x > (radius + 10)) && (x < width - (radius + 10)) && (y > (radius + 10)) && (y < height - (radius + 10));
  }
}

