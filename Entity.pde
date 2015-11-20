public abstract class Entity {

  protected int x, y;
  protected int hp;
  protected int radius;

  public Entity(int x, int y, int hp, int diameter) {
    this.x = x;
    this.y = y;
    this.hp = hp;
    this.radius = diameter / 2;
  }

  public boolean isDead() {
    return hp > 0;
  }
}

