public class Bullet {

  // Determined (i.e., set) only when fired
  private float direction;  
  private float x;
  private float y;

  private boolean hasBeenFired;
  private float speed;
  private float red;
  private float green;
  private float blue;

  public static final float BULLET_RADIUS = 8;

  public Bullet(final float red, final float green, final float blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  public void draw() {
    updatePosition();
    ellipseMode(CENTER);
    fill(red, green, blue);
    noStroke();
    ellipse(x, y, BULLET_RADIUS, BULLET_RADIUS);
  }

  public void updatePosition() {
    x -= speed*cos(direction);
    y -= speed*sin(direction);
  }
  
  public void setDirection(final float direction) {
    this.direction = direction;
  }
  
  public void setSpeed(final float speed) {
    this.speed = speed; 
  }
  
  public void setX(final float x) {
    this.x = x;
  }
  
  public void setY(final float y) {
    this.y = y; 
  }
}

