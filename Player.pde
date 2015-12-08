public class Player extends Entity {

  private static final int GUN = 0;
  private static final int LASER = 1;

  private static final int REVIVE_TIME = 100;
  private static final int ULTIMATE_DURATION = 250;
  private static final int MAX_ENERGY = 150;

  public static final int BULLET_RATE = 10;
  public static final int LASER_RATE = 1;

  public int id;
  public ArrayList<Bullet> bullets;

  public Player partner;
  public int reviveTime;
  public boolean down;

  public PowerUp powerUp;
  public int pickUpTime;

  public int ultimateTime;
  public int energy;

  public Controller controller;

  public int weapon;
  public float aim;

  public int lastShot;

  public int lastLaser;
  public float laserX;
  public float laserY;

  public Player(int id, int x, int y, Controller controller, boolean down) {
    super(x, y, 1, 75);
    this.id = id;
    this.bullets = new ArrayList<Bullet>();
    this.reviveTime = 0;
    this.partner = null;
    this.controller = controller;
    this.down = down;
    this.aim = 0;
    this.weapon = GUN;
    this.energy = 0;
    this.ultimateTime = 0;
  }

  public boolean usingLaser() {
    return weapon == LASER;
  }

  public boolean usingGun() {
    return weapon == GUN;
  }

  public boolean hasSpeed() {
    return powerUp != null && powerUp.type == PowerUp.SPEED;
  }

  public boolean hasDamage() {
    return powerUp != null && powerUp.type == PowerUp.DAMAGE;
  }

  public boolean hasFireRate() {
    return powerUp != null && powerUp.type == PowerUp.FIRE_RATE;
  }

  public boolean hasBulletSpeed() {
    return powerUp != null && powerUp.type == PowerUp.BULLET_SPEED;
  }

  public boolean hasInvincibility() {
    return powerUp != null && powerUp.type == PowerUp.INVINCIBILITY;
  }

  public boolean hasAimBot() {
    return powerUp != null && powerUp.type == PowerUp.AIM_BOT;
  }

  private Player getPartner() {
    for (Player player : game.players) {
      if (player != this && player.down && game.playerDist(player, this) < 75) {
        return player;
      }
    }
    return null;
  }

  public int getReviveDuration() {
    return game.frameCount() - reviveTime;
  }

  private boolean canStartRevivalProcess() {
    return (keys['X'] || controller.X.pressed()) && !down && reviveTime == 0 && getPartner() != null;
  }

  private void startRevivalProcess() {
    partner = getPartner();
    partner.partner = this;
    partner.reviveTime = reviveTime = game.frameCount();
  }

  private boolean hasRevivalProcessBeenCancelled() {
    return !(keys['X'] || controller.X.pressed()) && partner != null;
  }

  private void cancelRevivalProcess() {
    partner.reviveTime = reviveTime = 0;
    partner.partner = partner = null;
  }

  private boolean hasRevivalBeenSuccessful() {
    return getReviveDuration() >= REVIVE_TIME && partner != null;
  }

  private void revive() {
    if (down) {
      hp = maxHp / 2;
      down = false;
    }
    partner = null;
    reviveTime = 0;
  }

  public void heal() {
    hp = maxHp;
  }

  public void gainEnergy() {
    if (isInUltimate() || down) {
      return;
    }
    energy += 1;
  }

  public void update() {
    updateAim();
    checkWeaponChange();
    checkUltimate();

    for (Bullet bullet : bullets) {
      bullet.update(this);
    }

    if (canStartRevivalProcess()) {
      startRevivalProcess();
    } else if (hasRevivalProcessBeenCancelled()) {
      cancelRevivalProcess();
    } else if (hasRevivalBeenSuccessful()) {
      revive();
    }  

    if (down || partner != null) {
      return;
    }

    if (isInUltimate()) {
      doUltimate();
    } else {
      if (isFiring()) {
        shoot();
      }
    }

    movePlayer();

    fixPosition();

    if (game.frameCount() - pickUpTime > PowerUp.DURATION) {
      powerUp = null;
    }
  }

  public void checkWeaponChange() {
    if (controller.justPressed(controller.leftB)) {
      if (weapon == GUN) {
        weapon = LASER;
      } else if (weapon == LASER) {
        weapon = GUN;
      }
    }
  }

  public void checkUltimate() {
    if (controller.X.pressed() && controller.Y.pressed() && energy >= MAX_ENERGY && ultimateTime == 0) {
      ultimateTime = game.frameCount();
      ultimateSound.trigger();
    }
  }

  public boolean isInUltimate() {
    return ultimateTime > 0 && game.frameCount() - ultimateTime < ULTIMATE_DURATION && energy > 0;
  }

  public void movePlayer() {
    x += controller.getLeftX() * getSpeed();
    y += controller.getLeftY() * getSpeed();

    if (keys[UP] || keys['W']) {
      y-= getSpeed();
    }

    if (keys[DOWN] || keys['S']) {
      y += getSpeed();
    }

    if (keys[LEFT] || keys['A']) {
      x -= getSpeed();
    }

    if (keys[RIGHT] || keys['D']) {
      x += getSpeed();
    }
  }

  private float getSpeed() {
    float speed = 2;
    if (hasSpeed()) {
      speed *= 2;
    }
    if (controller.leftClick.pressed()) {
      speed += 1;
    }
    return speed;
  }

  public void fixPosition() {    
    if (y < radius ) {
      y = radius;
    }

    if (y > height - radius) {
      y = height - radius;
    }

    if (x < radius) {
      x = radius;
    }
    if (x > width - radius) {
      x = width - radius;
    }
  }

  public boolean isFiring() {
    return controller.getLeftT() < -0.5;
  }

  public void updateAim() {
    if (hasAimBot()) {
      Enemy target = getClosestEnemy();
      if (target != null) {
        float targetDistance = dist(x, y, target.x, target.y);
        aim = (float) Math.toDegrees((Math.atan2(target.y - y, target.x - x)));
        laserX = x + (float) (targetDistance * Math.sin(Math.toRadians(90 - aim)));
        laserY = y + (float) (targetDistance * Math.sin(Math.toRadians(aim)));
      }
    } else {
      aim = (float) (Math.atan2(controller.getRightY(), controller.getRightX()) * 180.0 / Math.PI);
    }
  }

  public boolean cantShoot() {
    return game.frameCount() - lastShot < BULLET_RATE / (hasFireRate() ? 2 : 1) || usingLaser();
  }

  public void doUltimate() {
    aim = game.frameCount() * 10;

    Bullet bullet = new Bullet(41, 128, 185);
    float bulletX = x + (float) (radius * Math.sin(Math.toRadians(90 - aim)));
    float bulletY = y + (float) (radius * Math.sin(Math.toRadians(aim)));
    bullet.setPosition(bulletX, bulletY);
    bullet.setVelocity(Bullet.BULLET_SPEED, aim);
    bullets.add(bullet);

    energy = MAX_ENERGY - (game.frameCount() - ultimateTime) * MAX_ENERGY / ULTIMATE_DURATION;

    if (energy <= 1) {
      energy = 0;
      ultimateTime = 0;
    }
  }

  public void shoot() {
    if (cantShoot()) {
      return;
    }
    Bullet bullet = new Bullet(41, 128, 185);
    float bulletX = x + (float) (radius * Math.sin(Math.toRadians(90 - aim)));
    float bulletY = y + (float) (radius * Math.sin(Math.toRadians(aim)));
    bullet.setPosition(bulletX, bulletY);
    bullet.setVelocity(Bullet.BULLET_SPEED, aim);
    bullets.add(bullet);
    lastShot = game.frameCount();
  }

  public void hit() {
    hp--;
    if (isDead()) {
      down = true;
      powerUp = null;
      hp = 0;
      ultimateTime = 0;
    }
  }

  public void respawn() {
    hp = maxHp;
    down = false;
  }

  public void display() {
    drawDownEffect();
    drawPlayer();
    drawId();
    drawLaser();
    drawCursor();
    drawBullets();
    drawHpBar();
    drawEnergyBar();
    if (partner == null && getPartner() == null) {
      drawPowerUp();
    } else {
      drawRevivalSystem();
    }
    drawCrosshairs();
  }

  private void drawLaser() {
    if (usingGun() || down || !isFiring()) {
      return;
    }
    float x1 = x + (float) (radius * Math.sin(Math.toRadians(90 - aim)));
    float y1 = y + (float) (radius * Math.sin(Math.toRadians(aim)));
    stroke(255, 0, 0, 100);
    line(x1, y1, laserX, laserY);
  }

  private void drawDownEffect() {
    if (!down) {
      return;
    }
    noStroke();
    fill(255, 102, 102, 200 - (game.frameCount() % 50) * 4);
    ellipse(x, y, radius * 2 + (game.frameCount() % 50) * 4, radius * 2 + (game.frameCount() % 50) * 4);
  }

  private void drawPlayer() {
    noStroke();
    if (powerUp != null) {
      fill(powerUp.red, powerUp.green, powerUp.blue, 150 - (game.frameCount() % 50) * 4);
      ellipse(x, y, radius * 2 + (game.frameCount() % 50) * 2, radius * 2 + (game.frameCount() % 50) * 2);
    }

    stroke(0, 0, 0, 255);
    strokeWeight(2);
    if (down) {
      fill(255, 102, 102);
    } else {
      fill(41, 128, 185, 255);
    }
    ellipse(x, y, radius * 2, radius  * 2);
    if (powerUp != null) {
      fill(powerUp.red, powerUp.green, powerUp.blue, 200 + (float) Math.sin(game.frameCount() / (float) 3) * 25);
      ellipse(x, y, radius * 2, radius  * 2);
    }
    if (isInUltimate()) {
      fill(241 - (game.frameCount() % 25) * 5, 196 - (game.frameCount() % 25) * 5, 15 - (game.frameCount() % 25) * 5);
      ellipse(x, y, radius * 2, radius  * 2);
      noStroke();
      fill(241 - (game.frameCount() % 25) * 5, 196 - (game.frameCount() % 25) * 5, 15 - (game.frameCount() % 25) * 5, 100 - (game.frameCount() % 50) * 2);    
      ellipse(x, y, radius * 2 + (game.frameCount() % 50) * 25, radius * 2 + (game.frameCount() % 50) * 25);
    }
  }

  private void drawId() {
    fill(0, 0, 0, 255);
    textAlign(CENTER);
    textSize(24);
    text(id, x, y + 10);
  }

  private void drawCursor() {
    noCursor();
    fill(0);
    ellipse(mouseX, mouseY, 1, 1);
  }

  public void drawBullets() {
    for (Bullet bullet : bullets) {
      bullet.display(this);
    }
  }

  public void drawHpBar() {
    int hpBarX = id * 325 - 175;

    textSize(18);

    if (energy < MAX_ENERGY) {
      fill(0);
      text("Player " + id, hpBarX, height - 60);
    } else {
      fill(241 - (game.frameCount() % 25) * 5, 196 - (game.frameCount() % 25) * 5, 15 - (game.frameCount() % 25) * 5);
      text("Press X + Y to use Ultimate", hpBarX, height - 60);
    }

    fill(0);
    rectMode(CORNER);
    stroke(0);
    rect(hpBarX - 75, height - 50, 150, 15, 3);
    rect(hpBarX - 75, height - 25, 150, 15, 3);

    if (down) {
      fill(255 - (game.frameCount() % 25) * 5, 102 - (game.frameCount() % 25) * 5, 102 - (game.frameCount() % 25) * 5);
      rect(hpBarX - 75, height - 50, 150, 15, 3);
    } else {
      setHPBarColor();
      rect(hpBarX - 75, height - 50, 150 * hp / maxHp, 15, 3);
    }
  }

  public void drawEnergyBar() {
    int energyBarX = id * 325 - 175;
    if (energy > MAX_ENERGY) {
      fill(241 - (game.frameCount() % 25) * 5, 196 - (game.frameCount() % 25) * 5, 15 - (game.frameCount() % 25) * 5);
      rect(energyBarX - 75, height - 25, 150, 15, 3);
    } else {
      fill(141 + energy, 96 + energy, -85 + energy);
      rect(energyBarX - 75, height - 25, energy, 15, 3);
    }
  }

  public void drawPowerUp() {
    if (powerUp == null) {
      return;
    }

    int textX = id * 325 - 175;

    textSize(18);
    fill(0);
    text(powerUp.name, textX, height - 110);

    int powerUpBar = id * 325 - 175;
    rectMode(CORNER);
    fill(0);
    rect(powerUpBar - 75, height - 100, 150, 15, 3);
    float shift = (float) Math.sin(game.frameCount() / (float) 5) * (float) 50; 
    fill(powerUp.red + shift, powerUp.green + shift, powerUp.blue + shift);
    rect(powerUpBar - 75, height - 100, (game.frameCount() - pickUpTime) * 150 / PowerUp.DURATION, 15, 3);
  }

  public void drawRevivalSystem() {
    if (partner == null) {
      if (getPartner() != null && !down) {
        int textX = id * 325 - 175;
        textSize(18);
        fill(0);
        text("Hold 'X' to revive.", textX, height - 90);
      }
      return;
    }

    int revivalBarX = id * 325 - 175;
    rectMode(CORNER);
    fill(0);
    rect(revivalBarX - 75, height - 100, 150, 15, 3);
    fill(255);
    rect(revivalBarX - 75, height - 100, min(getReviveDuration() * 150 / REVIVE_TIME, 150), 15, 3);
  }

  private void drawCrosshairs() {
    drawCrosshair(40, 5);
    drawCrosshair(45, 3);
    drawCrosshair(48, 2);
  }

  private void drawCrosshair(int distance, int radius) {
    float crossX = x + (float) (distance * Math.sin(Math.toRadians(90 - aim)));
    float crossY = y + (float) (distance * Math.sin(Math.toRadians(aim)));
    fill(0);
    ellipse(crossX, crossY, radius, radius);
  }

  private Enemy getClosestEnemy() {
    Enemy target = null;
    float targetDistance = Integer.MAX_VALUE;

    for (Enemy enemy : game.wave.enemies) {
      float dist = dist(x, y, enemy.x, enemy.y);
      if (dist < targetDistance) {
        targetDistance = dist;
        target = enemy;
      }
    }

    return target;
  }

  private Enemy getClosestHitEnemy() {

    Enemy target = null;
    float targetDistance = Integer.MAX_VALUE;

    float x0 = x + (float) (radius * Math.sin(Math.toRadians(90 - aim)));
    float y0 = y + (float) (radius * Math.sin(Math.toRadians(aim)));
    float x1 = x + (float) (width * Math.sin(Math.toRadians(90 - aim)));
    float y1 = y + (float) (width * Math.sin(Math.toRadians(aim)));

    for (Enemy enemy : game.wave.enemies) {
      if (game.collided(x0, y0, x1, y1, enemy.x, enemy.y, enemy.radius)) {
        float dist = dist(x, y, enemy.x, enemy.y);
        if (dist < targetDistance) {
          targetDistance = dist;
          target = enemy;
        }
      }
    }
    return target;
  }
}

