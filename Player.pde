public class Player extends Entity {

  private static final int REVIVAL_DURATION = 100;

  public int id;
  public ArrayList<Bullet> bullets;
  public int speed;

  public Player partner;
  public int reviveTime;
  public boolean down;

  public PowerUp powerUp;
  public int pickUpTime;

  public Player(int id, int x, int y, boolean down) {
    super(x, y, 10, 75);
    this.id = id;
    this.bullets = new ArrayList<Bullet>();
    this.speed = 3;
    this.reviveTime = 0;
    this.partner = null;
    this.down = down;
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
    return frameCount - reviveTime;
  }

  private boolean canStartRevivalProcess() {
    return keys['X'] && !down && reviveTime == 0 && getPartner() != null;
  }

  private void startRevivalProcess() {
    partner = getPartner();
    partner.partner = this;
    partner.reviveTime = reviveTime = frameCount;
  }

  private boolean hasRevivalProcessBeenCancelled() {
    return !keys['X'] && partner != null;
  }

  private void cancelRevivalProcess() {
    partner.reviveTime = reviveTime = 0;
    partner.partner = partner = null;
  }

  private boolean hasRevivalBeenSuccessful() {
    return getReviveDuration() >= REVIVAL_DURATION && partner != null;
  }

  private void revive() {
    if (down) {
      hp = maxHp / 2;
    }
    partner = null;
    reviveTime = 0;
    down = false;
  }

  public void update() {

    for (Bullet bullet : bullets) {
      bullet.update();
    }

    if (canStartRevivalProcess()) {
      startRevivalProcess();
    } else if (hasRevivalProcessBeenCancelled()) {
      cancelRevivalProcess();
    } else if (hasRevivalBeenSuccessful()) {
      revive();
    } else if (down || partner != null) {
      return;
    }

    if (keys[UP] || keys['W']) {
      y-= speed;
      if (y < radius ) {
        y = radius;
      }
    }

    if (keys[DOWN] || keys['S']) {
      y += speed;
      if (y > height - radius) {
        y = height - radius;
      }
    }

    if (keys[LEFT] || keys['A']) {
      x -= speed;
      if (x < radius) {
        x = radius;
      }
    }

    if (keys[RIGHT] || keys['D']) {
      x += speed;
      if (x > width - radius) {
        x = width - radius;
      }
    }
  }

  public void shoot() {
    if (down || partner != null) {
      return;
    }

    float deltaX = x - mouseX;
    float deltaY = y - mouseY;
    final float direction = atan2(deltaY, deltaX);
    final Bullet bullet = new Bullet(52, 152, 219);
    bullet.setPosition(x, y);
    bullet.setVelocity(Bullet.BULLET_SPEED, direction);
    bullets.add(bullet);
  }

  public void hit() {
    hp--;
    if (hp <= 0) {
      down = true;
      hp = 0;
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
    drawCursor();
    drawBullets();
    drawHpBar();
    drawRevivalSystem();
  }

  private void drawDownEffect() {
    if (!down) {
      return;
    }
    noStroke();
    fill(255, 102, 102, 200 - (frameCount % 50) * 4);
    ellipse(x, y, radius * 2 + (frameCount % 50) * 4, radius * 2 + (frameCount % 50) * 4);
  }

  private void drawPlayer() {
    stroke(0, 0, 0, 255);
    strokeWeight(2);
    if (down) {
      fill(255, 102, 102);
    } else {
      fill(41, 128, 185, 255);
    }
    ellipse(x, y, radius * 2, radius  * 2);
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
      bullet.display();
    }
  }

  public void drawHpBar() {
    int hpBarX = id * 325 - 175;

    textSize(18);
    fill(0);
    text("Player " + id, hpBarX, height - 40);

    rectMode(CORNER);
    rect(hpBarX - 75, height - 30, 150, 15, 3);

    stroke(0);
    if (down) {
      fill(255 - (frameCount % 25) * 5, 102 - (frameCount % 25) * 5, 102 - (frameCount % 25) * 5);
      rect(hpBarX - 75, height - 30, 150, 15, 3);
    } else {
      setHPBarColor();
      rect(hpBarX - 75, height - 30, 150 * hp / maxHp, 15, 3);
    }
  }

  private void setHPBarColor() {
    float percent = hp * 100 / maxHp;
    if (percent < 30) {
      fill(255, 102, 102);
    } else if (percent < 60) {
      fill(241, 196, 15);
    } else {
      fill(77, 255, 136);
    }
  }

  public void drawRevivalSystem() {
    if (partner == null) {
      return;
    }

    int revivalBarX = id * 325 - 175;
    rectMode(CORNER);
    fill(0);
    rect(revivalBarX - 75, height - 80, 150, 15, 3);
    fill(255);
    rect(revivalBarX - 75, height - 80, getReviveDuration() * 150 / REVIVAL_DURATION, 15, 3);
  }
}


