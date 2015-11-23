class EnemyHealthBar {

  public static final float BAR_HEIGHT = 10.0;
  public static final float DISTANCE_ABOVE_ENEMY = 7.0;
  public static final float BAR_ROUNDED_CORNER_RADIUS = 20;
  public static final float BAR_WIDTH_FACTOR = 4.5;

  public void displayForEnemy(final Enemy e) {
    final float hpCapacity = e.getRemainingHP();
    final float barPositionX = e.x;
    final float barPositionY = e.y - e.radius - BAR_HEIGHT - DISTANCE_ABOVE_ENEMY;
     
    stroke(0);
    strokeWeight(1.5);
    fill(255, 102, 102);
    rectMode(CORNER);
    rect(barPositionX, barPositionY, hpCapacity*BAR_WIDTH_FACTOR, BAR_HEIGHT, BAR_ROUNDED_CORNER_RADIUS);
    
    final float hpRemaining = e.getRemainingHP();
    drawRemainingHPBar(hpRemaining, barPositionX, barPositionY);
  }
  
  private void drawRemainingHPBar(final float hpRemaining, final float barPositionX, final float barPositionY) {
    strokeWeight(0);
    fill(77, 255, 136);
    rect(barPositionX, barPositionY, hpRemaining*BAR_WIDTH_FACTOR, BAR_HEIGHT, BAR_ROUNDED_CORNER_RADIUS);
  }
  
}

