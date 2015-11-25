public class Bullet2 {

  public float x;
  public float y;
  private float angle;

  private float red;
  private float green;
  private float blue;

  public static final float BULLET_RADIUS = 9;
  public static final float BULLET_SPEED = 5;

  public Bullet2(float x, float y, float angle, int red, int green, int blue) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  public void draw() {
    ellipseMode(CENTER);
    fill(red, green, blue);
    noStroke();
    ellipse(x, y, BULLET_RADIUS, BULLET_RADIUS);
  }

  public void update() {
    double dy = BULLET_SPEED * Math.sin(Math.toRadians(angle));
    double dx = BULLET_SPEED * Math.sin(Math.toRadians(90 - angle));

    x += dx;
    y += dy;
  }
}

