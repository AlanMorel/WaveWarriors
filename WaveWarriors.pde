import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

public ControlIO control;
public Controller controller1, controller2, controller3, controller4;

public boolean mac = false;

public int state;

public static final int MAIN_MENU_STATE = 0;
public static final int GAME_STATE = 1;

private MainMenu mainMenu;
private Game game;


void setup() {
  size(1280, 720);
  frameRate(60);

  state = MAIN_MENU_STATE;
  mainMenu = new MainMenu();
  
  control = ControlIO.getInstance(this);
  controller1 = new Controller(1);
}

void draw() {
  if (state == MAIN_MENU_STATE) {
    mainMenu.update();
    mainMenu.draw();
  } else if (state == GAME_STATE) {
    game.update();
    game.draw();
  }
}

boolean[] keys = new boolean[255];

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}

void mouseClicked() {
  if (state == GAME_STATE) {
    game.mouseClicked();
  }
}

