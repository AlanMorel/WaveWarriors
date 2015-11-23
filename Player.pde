public class Player extends Entity {

  private int id;

  public Player(int id, int x, int y) {
    super(x, y, 100, 75);
    this.id = id;
  }

  public void update() {
    int speed = 3;

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
    drawPlayer();
    drawNameTag();
  }

  private void drawPlayer() {
    fill(0, 0, 0, 100);
    stroke(0, 0, 0, 255);
    strokeWeight(2);

    ellipse(x, y, radius * 2, radius  * 2);
  }

  private void drawNameTag() {
    fill(0, 0, 0, 255);
    textAlign(CENTER);
    textSize(16);
    
    text("Player " + id, x, y + 55);
  }
}

