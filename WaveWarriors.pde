private int state;
private MainMenu mainMenu;

public static final int MAIN_MENU_STATE = 1;

void setup() {
  size(1280, 720);
  imageMode(CORNER);
  state = MAIN_MENU_STATE;
  mainMenu = new MainMenu();
}

void draw() {
  if (state == MAIN_MENU_STATE) {
    mainMenu.display(); 
  }
}
