class Bullet {
  
  public boolean isFiring;
  
  private float accuracy;
  private float speed;
  private float xPosition;
  private float yPosition;
  
  private float direction;  // Determined (i.e., set) only when fired.

  public static final float BULLET_RADIUS = 8;
  
  // TODO: MODIFY BULLET ACCURACY
  public static final int LOW_ACCURACY = 1;
  public static final int MEDIUM_ACCURACY = 2;
  public static final int HIGH_ACCURACY = 3;

  Bullet(final float xPosition, final float yPosition, final float speed, float accuracy) {
    final boolean accuracyIsInvalid = (accuracy != LOW_ACCURACY) && (accuracy != MEDIUM_ACCURACY) && (accuracy != HIGH_ACCURACY);
    
    this.isFiring = false;
    
    this.accuracy = accuracyIsInvalid ? MEDIUM_ACCURACY : accuracy; 
    this.speed = speed;
    this.xPosition = xPosition;
    this.yPosition = yPosition;
  }
  
  public void display() {
    updatePosition();
    ellipseMode(CENTER);
    fill(204, 153, 0);
    noStroke();
    ellipse(xPosition, yPosition, BULLET_RADIUS, BULLET_RADIUS);
  }
  
  public void fireAtPlayer(final Player player) {
    if (isFiring == false) {
     isFiring = true;
     final float deltaX = xPosition - player.x;
     final float deltaY = yPosition - player.y;
     direction  = atan2(deltaY, deltaX);
    }
  }
  
  public void updatePosition() {
    xPosition -= speed*cos(direction);
    yPosition -= speed*sin(direction);
  }
  
  public float getXPosition() {
    return this.xPosition; 
  }
  
  public float getYPosition() {
    return this.yPosition; 
  }
  
}
