public class PowerUp {

  public static final float SPEED = 0;
  public static final float DAMAGE = 1;
  public static final float FIRE_RATE = 2;
  public static final float BULLET_SPEED = 3;
  public static final float INVINCIBILITY = 4;
  public static final float HEAL = 5;
  public static final float NUKE = 6;
    
  public static final float POWER_UP_RADIUS = 75;
  private static final int DURATION = 500;

  private float x;
  private float y;

  public int type;
  public String name;
  public PImage icon;

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
      red = 230;
      green = 126;
      blue = 34;
    } else if (type == BULLET_SPEED) {
      red = 142;
      green = 68;
      blue = 173;
    } else if (type == INVINCIBILITY) {
      red = 241;
      green = 196;
      blue = 15;
    } else if (type == HEAL) {
      red = 46;
      green = 204;
      blue = 113;
    } else if (type == NUKE) {
      red = 0;
      green = 0;
      blue = 0;
    }
  }

  public void setPowerUpName() {
    if (type == SPEED) {
      name = "2x Speed";
    } else if (type == DAMAGE) {
      name = "2x Damage";
    } else if (type == FIRE_RATE) {
      name = "2x Fire rate";
    } else if (type == BULLET_SPEED) {
      name = "2x Bullet Speed";
    } else if (type == INVINCIBILITY) {
      name = "Invincibility";
    }
  }

  public void setIcon() {    
    if (type == SPEED) {
      icon = loadImage("speed.png");
    } else if (type == DAMAGE) {
      icon = loadImage("damage.png");
    } else if (type == FIRE_RATE) {
      icon = loadImage("firerate.png");
    } else if (type == BULLET_SPEED) {
      icon = loadImage("bulletSpeed.png");
    } else if (type == INVINCIBILITY) {
      icon = loadImage("invincibility.png");
    } else if (type == HEAL) {
      icon = loadImage("heal.png");
    } else if (type == NUKE) {
      icon = loadImage("nuke.png");
    }
  }

  public void draw() {
    ellipseMode(CENTER);
    noStroke();
    fill(red, green, blue, 50);
    pushMatrix();
    translate(x, y);
    rotate(frameCount/ (float) 10);
    ellipse(0, 0, POWER_UP_RADIUS + (float) Math.sin((float) frameCount / 5) * 50, POWER_UP_RADIUS + (float) Math.sin((float) frameCount / 10) *  50);
    ellipse(0, 0, POWER_UP_RADIUS + (float) Math.sin((float) frameCount / 10) * 50, POWER_UP_RADIUS + (float) Math.sin((float) frameCount / 5) *  50);
    rotate(0);
    popMatrix();
    fill(red, green, blue);
    ellipse(x, y, POWER_UP_RADIUS, POWER_UP_RADIUS);
    image(icon, x - 16, y - 16);
  }
}

