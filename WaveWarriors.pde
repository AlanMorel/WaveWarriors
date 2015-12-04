import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import ddf.minim.*;
 
Minim minim;
AudioSample bulletSound, powerUpSound;
AudioPlayer backgroundMusic;
 
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
  
  minim = new Minim(this);
  bulletSound = minim.loadSample("bullet.mp3", 512);
  powerUpSound = minim.loadSample("powerup.mp3", 512);
  
  backgroundMusic = minim.loadFile("music.wav", 2048);
  backgroundMusic.loop();
  
  control = ControlIO.getInstance(this);
  controller1 = new Controller(1);
  
  state = MAIN_MENU_STATE;
  mainMenu = new MainMenu();
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

