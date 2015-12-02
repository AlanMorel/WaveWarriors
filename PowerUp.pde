public class PowerUp {

  private float x;
  private float y;

  private int type;
  
  public static final float SPEED = 0;
  public static final float POWER = 1;
  public static final float FIRE_RATE = 2;

  public static final float POWER_UP_RADIUS = 100;

  private float red;
  private float green;
  private float blue;

  public PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    setColor();
  }

  public void setColor(){
    if (type == SPEED){
      red = 0;
      green = 0;
      blue = 255;
    } else if (type == POWER){
      red = 255;
      green = 0;
      blue = 0;
    } else if (type == FIRE_RATE){
      red = 0;
      green = 255;
      blue = 0;
    }
  }
  
  public void draw() {
    ellipseMode(CENTER);
    fill(red, green, blue);
    noStroke();
    ellipse(x, y, POWER_UP_RADIUS, POWER_UP_RADIUS);
    fill(red, green, blue, 100 - (frameCount % 50) * 2);
    ellipse(x, y, POWER_UP_RADIUS + (frameCount % 50) * 2, POWER_UP_RADIUS + (frameCount % 50) * 2);
  }
  
  public boolean isSpeed(){
    return type == SPEED;
  }
  
  public boolean isPower(){
    return type == POWER;
  }
  
  public boolean isFireRate(){
    return type == FIRE_RATE;
  }
}

