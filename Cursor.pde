public class Cursor {

  private static final int SPEED = 5;
  
  private int id;
  
  private float x;
  private float y;

  private Controller controller;

  public Cursor(Controller controller, int id) {
    this.controller = controller;
    this.id = id;
    this.x = (id - 1) * 340 + 135;
    this.y = 540;
  }

  public void draw() {
    ellipseMode(CENTER);
    fill(0, 200, 0, 100);
    stroke(0, 200, 0, 255);
    ellipse(x, y, 50 + (float) Math.sin(frameCount / (float) 10) *  5, 50 + (float) Math.sin(frameCount / (float) 10) * 5);
    fill(0);
    textSize(24);
    text(id, x - 8, y + 8);
  }

  public void update() {
    x += controller.getLeftX() * SPEED;
    y += controller.getLeftY() * SPEED;
  }
}

