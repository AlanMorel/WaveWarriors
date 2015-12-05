public abstract class Entity {

  protected float x, y;
  protected int maxHp;
  protected int hp;
  protected int radius;

  public Entity(float x, float y, int hp, int diameter) {
    this.x = x;
    this.y = y;
    this.hp = hp;
    this.maxHp = hp;
    this.radius = diameter / 2;
  }

  public boolean isDead() {
    return hp <= 0;
  }

  public void setHPBarColor() {
    float percent = hp * 100 / maxHp;
    if (percent < 30) {
      fill(255, 102, 102);
    } else if (percent < 60) {
      fill(241, 196, 15);
    } else {
      fill(77, 255, 136);
    }
  }
}

