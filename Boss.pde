public class Boss extends Enemy {
  Boss(final int waveNum, final float x, final float y) {
    super(waveNum, x, y);
    this.speed = getEnemySpeedForWave(waveNum) / 2;
    this.shootingMarginOfError = getShootingMarginOfErrorForWave(waveNum);
    this.bulletSpeed = getBulletSpeedForWave(waveNum) * 2;
    this.hp = (int)(BASE_HEALTH + waveNum * HEALTH_FACTOR) * 2;
    this.maxHp = hp;
    this.radius = ENEMY_RADIUS * 1.5;
    this.rFillColor = 255;
    this.gFillColor = 77;
    this.bFillColor = 77;
    this.firedBullets = new ArrayList<Bullet>();
    updateFireDelay();
    setNewTargetPosition();
  }
  
  public void updateFireDelay() {
    fireDelay = (int)random(50, 200);
  }
}
