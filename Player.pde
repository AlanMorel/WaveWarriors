public class Player extends Entity {

  public int id;
  public ArrayList<Bullet2> bullets;
  public int speed;
  public boolean down;

  public Player(int id, int x, int y, boolean down) {
    super(x, y, 10, 75);
    this.id = id;
    this.bullets = new ArrayList<Bullet2>();
    this.speed = 3;
    this.down = down;
  }

  public void update() {

    for (Bullet2 bullet : bullets) {
      bullet.update();
    }

    if (down) {
      hit();
      return;
    }

    if (keys[UP] || keys['W']) {
      y-= speed;
    }

    if (keys[DOWN] || keys['S']) {
      y += speed;
    }

    if (keys[LEFT] || keys['A']) {
      x -= speed;
    }

    if (keys[RIGHT] || keys['D']) {
      x += speed;
    }

    correctBounds();
  }

  public void shoot() {
    if (down) {
      return;
    }

    double angle = Math.atan2(mouseY - y, mouseX - x) * 180.0 / Math.PI;

    Bullet2 bullet = new Bullet2(x, y, (float) angle, 52, 152, 219);
    bullets.add(bullet);
  }

  public void correctBounds() {
    if (x < radius) {
      x = radius;
    }

    if (x > width - radius) {
      x = width - radius;
    }

    if (y < radius ) {
      y = radius;
    }

    if (y > height - radius) {
      y = height - radius;
    }
  }

  public void draw() {
    if (down) {
      drawEffect();
    }
    drawPlayer();
    drawNameTag();
    drawCursor();
    drawHpBar();
    for (Bullet2 bullet : bullets) {
      bullet.display();
    }
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

  public void drawHpBar() {
    int hpBarX = id * 325 - 175;

    textSize(18);
    fill(0);
    text("Player " + id, hpBarX, height - 40);

    rectMode(CORNER);
    rect(hpBarX - 75, height - 30, 150, 15, 3);

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

  private void drawCursor() {
    noCursor();
    fill(0);
    ellipse(mouseX, mouseY, 1, 1);
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

  private void drawEffect() {
    noStroke();
    fill(255, 102, 102, 200 - (frameCount % 50) * 4);
    ellipse(x, y, radius * 2 + (frameCount % 50) * 4, radius * 2 + (frameCount % 50) * 4);
  }

  private void drawNameTag() {
    fill(0, 0, 0, 255);
    textAlign(CENTER);
    textSize(24);

    text(id, x, y + 10);
  }
}

