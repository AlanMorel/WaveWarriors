public class PowerUp {

  private float x;
  private float y;

  private int type;
  public String name;
  public PImage icon;

  public static final float SPEED = 0;
  public static final float DAMAGE = 1;
  public static final float FIRE_RATE = 2;

  public static final float POWER_UP_RADIUS = 75;

  private float red;
  private float green;
  private float blue;

  public PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    setColor();
    setPowerUpName();
    setIcon();
  }

  public void setColor() {
    if (type == SPEED) {
      red = 41;
      green = 128;
      blue = 185;
    } else if (type == DAMAGE) {
      red = 192;
      green = 57;
      blue = 43;
    } else if (type == FIRE_RATE) {
      red = 39;
      green = 174;
      blue = 96;
    }
  }

  public void setPowerUpName() {
    if (type == SPEED) {
      name = "Speed";
    } else if (type == DAMAGE) {
      name = "Damage";
    } else if (type == FIRE_RATE) {
      name = "Fire rate";
    }
  }

  public void setIcon() {    
    if (type == SPEED) {
      icon = loadImage("speed.png");
    } else if (type == DAMAGE) {
      icon = loadImage("damage.png");
    } else if (type == FIRE_RATE) {
      icon = loadImage("firerate.png");
    }
  }

  public void draw() {
    ellipseMode(CENTER);
    fill(red, green, blue);
    noStroke();
    ellipse(x, y, POWER_UP_RADIUS, POWER_UP_RADIUS);
    fill(red, green, blue, 100 - (frameCount % 50) * 2);
    ellipse(x, y, POWER_UP_RADIUS + (frameCount % 50) * 2, POWER_UP_RADIUS + (frameCount % 50) * 2);
    image(icon, x - 16, y - 16);
  }

  public boolean isSpeed() {
    return type == SPEED;
  }

  public boolean isDamage() {
    return type == DAMAGE;
  }

  public boolean isFireRate() {
    return type == FIRE_RATE;
  }
}

