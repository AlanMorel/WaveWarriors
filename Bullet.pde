public class Bullet {

  // Determined (i.e., set) only when fired
  private float direction;  
  private float speed;
  private float x;
  private float y;

  private float red;
  private float green;
  private float blue;

  public static final float BULLET_RADIUS = 8;
  public static final float BULLET_SPEED = 5;


  public Bullet(final float red, final float green, final float blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  public void display() {
    ellipseMode(CENTER);
    fill(red, green, blue);
    noStroke();
    ellipse(x, y, BULLET_RADIUS, BULLET_RADIUS);
  }

  public void update() {
    x -= speed*cos(direction);
    y -= speed*sin(direction);
  }
  
  public void setVelocity(final float speed, final float direction) {
    this.speed = speed; 
    this.direction = direction;
  }
  
  public void setPosition(final float x, final float y) {
    this.x = x;
    this.y = y; 
  }
}

