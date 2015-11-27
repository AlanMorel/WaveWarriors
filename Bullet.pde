public class Bullet {

  public boolean isFiring;

  private float accuracy;
  private float speed;

  public float x;
  public float y;

  private float direction;  // Determined (i.e., set) only when fired.

  private float red;
  private float green;
  private float blue;

  public static final float BULLET_RADIUS = 8;

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

  public Bullet(final float x, final float y, final float speed, float accuracy, int red, int green, int blue) {
    this.isFiring = false;
    this.accuracy =  accuracy; 
    this.speed = speed;
    this.x = x;
    this.y = y;
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  public void draw() {
    updatePosition();
    ellipseMode(CENTER);
    fill(204, 153, 0);
    noStroke();
    ellipse(x, y, BULLET_RADIUS, BULLET_RADIUS);
  }

  public void fireAtPlayer(final Player player) {
    if (isFiring == false) {

      isFiring = true;
      float range = dist(x, y, player.x, player.y);    

      float targetX = player.x;
      float targetY = player.y;

      if ((accuracy == LOW_ACCURACY) && (range > LOW_ACCURACY_CERTAIN_HIT_RANGE)) {
        targetX = player.x + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
        targetY = player.y + random(-LOW_ACCURACY_MARGIN_OF_ERROR, LOW_ACCURACY_MARGIN_OF_ERROR);
      } else if ((accuracy == MEDIUM_ACCURACY) && (range > MEDIUM_ACCURACY_CERTAIN_HIT_RANGE)) {
        targetX = player.x + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
        targetY = player.y + random(-MEDIUM_ACCURACY_MARGIN_OF_ERROR, MEDIUM_ACCURACY_MARGIN_OF_ERROR);
      } else if ((accuracy == HIGH_ACCURACY) && (range > HIGH_ACCURACY_CERTAIN_HIT_RANGE)) {
        targetX = player.x + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
        targetY = player.y + random(-HIGH_ACCURACY_MARGIN_OF_ERROR, HIGH_ACCURACY_MARGIN_OF_ERROR);
      }

      float deltaX = x - targetX;
      float deltaY = y - targetY; 

      direction  = atan2(deltaY, deltaX);
    }
  }

  public void updatePosition() {
    x -= speed*cos(direction);
    y -= speed*sin(direction);
  }
}

