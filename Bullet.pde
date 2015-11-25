class Bullet {
  
  public boolean isFiring;
  
  private float accuracy;
  private float speed;
  private float xPosition;
  private float yPosition;
  
  private float direction;  // Determined (i.e., set) only when fired.

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
  
  /** The enemy will shoot towards a point on the line perpendicular to the line 
    * between the enemy and the player. The point towards which the bullet will 
    * fire is determined by it's accuracy. A higher accuracy ensures a greater 
    * chance of the point being within the player. 
    */
  public void fireAtPlayer(final Player player) {
    if (isFiring == false) {
     isFiring = true;
     
     float deltaX = -1;
     float deltaY = -1;
     final float range = dist(xPosition, yPosition, player.x, player.y);     
     if ((accuracy == LOW_ACCURACY) && (range > LOW_ACCURACY_CERTAIN_HIT_RANGE)) {
       final float targetX = player.x + LOW_ACCURACY_MARGIN_OF_ERROR;
       final float targetY = player.y + LOW_ACCURACY_MARGIN_OF_ERROR;
       deltaX = xPosition - targetX;
       deltaY = yPosition - targetY;
     } else if ((accuracy == MEDIUM_ACCURACY) && (range > MEDIUM_ACCURACY_CERTAIN_HIT_RANGE)) {
       final float targetX = player.x + MEDIUM_ACCURACY_MARGIN_OF_ERROR;
       final float targetY = player.y + MEDIUM_ACCURACY_MARGIN_OF_ERROR;
       deltaX = xPosition - targetX;
       deltaY = yPosition - targetY;
     } else if ((accuracy == HIGH_ACCURACY) && (range > HIGH_ACCURACY_CERTAIN_HIT_RANGE)){
       final float targetX = player.x + HIGH_ACCURACY_MARGIN_OF_ERROR;
       final float targetY = player.y + HIGH_ACCURACY_MARGIN_OF_ERROR;
       deltaX = xPosition - targetX;
       deltaY = yPosition - targetY;     
     } else {
       deltaX = xPosition - player.x;
       deltaY = yPosition - player.y;
     }

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
