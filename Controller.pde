public class Controller {

  int player;

  ControlDevice device;

  ControlButton A;

  ControlSlider leftX;
  ControlSlider leftY;

  ControlSlider rightX;
  ControlSlider rightY;

  ControlSlider leftT;
  ControlSlider rightT;

  public Controller(int player) {
    this.player = player;

    this.device = control.getDevice(mac ? "Xbox One Wired Controller" : "Controller (XBOX One For Windows)");

    this.A = device.getButton(mac ? "0" : "Button 0");

    this.leftX = device.getSlider(mac ? "x" : "X Axis");
    this.leftX.setTolerance(0.15);

    this.leftY = device.getSlider(mac ? "y" : "Y Axis");
    this.leftY.setTolerance(0.15);

    this.rightX = device.getSlider(mac ? "rx" : "X Rotation");
    this.rightY = device.getSlider(mac ? "ry" : "Y Rotation");

    this.leftT = device.getSlider(mac ? "z" : "Z Axis:");
    this.rightT = device.getSlider(mac ? "rz" : "Z Axis");
  }

  public float getLeftX() {
    return leftX.getValue();
  }

  public float getLeftY() {
    return leftY.getValue();
  }

  public float getRightX() {
    return rightX.getValue();
  }

  public float getRightY() {
    return rightY.getValue();
  }

  public float getLeftT() {
    return leftT.getValue();
  }

  public float getRightT() {
    return rightT.getValue();
  }
}

