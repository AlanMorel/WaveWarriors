public class Controller {

  public int player;

  public ControlDevice device;

  public ControlButton A, B, X, Y, leftB, rightB, back, start, leftClick, rightClick;

  public ControlSlider leftX;
  public ControlSlider leftY;

  public ControlSlider rightX;
  public ControlSlider rightY;

  public ControlSlider leftT;
  public ControlSlider rightT;

  public HashMap<ControlButton, Boolean> buttonStates;

  public Controller(int player) {
    this.player = player;

    this.device = control.getDevice(mac ? "X360Controller" : "Controller (XBOX One For Windows)");

    this.A = device.getButton(mac ? "0" : "Button 0");
    this.B = device.getButton(mac ? "1" : "Button 1");
    this.X = device.getButton(mac ? "2" : "Button 2");
    this.Y = device.getButton(mac ? "3" : "Button 3");
    this.leftB = device.getButton(mac ? "4" : "Button 4");
    this.rightB = device.getButton(mac ? "5" : "Button 5");
    this.back = device.getButton(mac ? "6" : "Button 6");
    this.start = device.getButton(mac ? "7" : "Button 7");
    this.leftClick = device.getButton(mac ? "8" : "Button 8");
    this.rightClick = device.getButton(mac ? "9" : "Button 9");

    this.leftX = device.getSlider(mac ? "x" : "X Axis");
    this.leftX.setTolerance(0.15);

    this.leftY = device.getSlider(mac ? "y" : "Y Axis");
    this.leftY.setTolerance(0.15);

    this.rightX = device.getSlider(mac ? "rx" : "X Rotation");
    this.rightY = device.getSlider(mac ? "ry" : "Y Rotation"); 

    this.leftT = device.getSlider(mac ? "z" : "Z Axis");
    this.rightT = device.getSlider(mac ? "rz" : "Z Rotation");

    buttonStates = new HashMap<ControlButton, Boolean>();
    buttonStates.put(A, false);
    buttonStates.put(B, false);
    buttonStates.put(X, false);
    buttonStates.put(Y, false);
    buttonStates.put(leftB, false);
    buttonStates.put(rightB, false);
    buttonStates.put(back, false);
    buttonStates.put(start, false);
    buttonStates.put(leftClick, false);
    buttonStates.put(rightClick, false);
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

  public void update() {
    for (Map.Entry entry : buttonStates.entrySet ()) {
      ControlButton button = (ControlButton) entry.getKey();
      entry.setValue(button.pressed());
    }
  }

  public boolean justPressed(ControlButton button) {
    boolean justPressed = (!(boolean) buttonStates.get(button)) && button.pressed();
    buttonStates.put(button, false);
    return justPressed;
  }
}
