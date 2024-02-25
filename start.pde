PFont pixelFont;
PImage bgImage;
boolean startButtonClicked = false;
int buttonX, buttonY, buttonWidth, buttonHeight;

interface Command {
  void execute();
  String getType();
}

class AttackCommand implements Command {
  String type = "attack";
  
  @Override
  void execute() {
    hero.attack();
  }

  @Override
  String getType() {
    return type;
  }
}

class DefenseCommand implements Command {
  String type = "defense";
  
  @Override
  void execute() {
    hero.defense();
  }

  @Override
  String getType() {
    return type;
  }
}

String messageText = "";

//boolean onPage = false;

public boolean introIsFinished = false;
boolean level_1 = false;
boolean level_2 = false;
boolean level_3 = false;
boolean level_4 = false;
int currentLevel = 0;

public boolean level_1StoryOver = false;
public boolean level_1Selected = false;
public long roundStartTime;
public boolean level_1GameOver = false;
public boolean level_1GameWin = false;
public boolean level_1WinWaiting = false;
public boolean level_1FailWaiting = false;
public ArrayList<PVector> anchors;

String currentPage = "start";
PImage finalImage;

Hero hero;
Bully bully;

MapPage mapPage;
Level_1 first;
Level_2 second;
Level_3 third;
Level_4 forth;

void setup() {
  pixelFont = createFont("charactors/element/Press_Start_2P/PressStart2P-Regular.ttf", 16);
  
  size(1024, 656);
  bgImage = loadImage("background/final_start_page.jpg");
  bgImage.resize(width, height);
  surface.setTitle("Fantasy Coding World");

  buttonWidth = 320;
  buttonHeight = 64;
  buttonX = 337;
  buttonY = 458;
  
  
  background(bgImage);
}

void draw() {
  if (startButtonClicked) {
    showMapScreen();
    if (introIsFinished) {
      if (hero == null) {
        hero = new Hero(804-16, 469-30);
       }
      hero.stay();
    }
  }
  else if (hero != null) {
    //if (onPage) {
    //  showMapScreen();
    //}
    if (!hero.runningFinished && level_1) {
      showMapScreen();
      hero.run(749-16, 328-30);
    } else if (hero.runningFinished && level_1) {
      if (!level_1Selected) {
        currentPage = "level_1";
        showFirstScreen();
      } else if (!level_1GameOver) {
        first.startRound();
        first.updateCombat();
      } else {
        if (level_1GameWin) {
          first.win();
        }
        else {
          first.fail();
        }
      }
    } 
    else if (level_2) {
      currentPage = "level_2";
      showSecondScreen();
    } else if (level_3) {
      currentPage = "level_3";
      showSecondScreen();
    } else if (level_4) {
      currentPage = "level_4";
      showSecondScreen();
    }
  }
  
  if (!messageText.equals("")) {
    fill(255);
    textFont(pixelFont, 16);
    text(messageText, 10, height - 10);
  }
}

void mouseDragged() {
  if (currentPage == "level_1" && level_1StoryOver == true) {
    first.mouseDragged();
  }
}

void mouseReleased() {
  if (currentPage == "level_1" && level_1StoryOver == true) {
    first.mouseReleased();
  }
}

void mouseClicked() {
  if (currentPage == "map") {
    mapPage.mouseClicked();
  }
  else if (currentPage == "level_1") {
    first.mouseClicked();
  }
}

void mousePressed() {
  if (currentPage == "start") {
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      currentPage = "map";
      startButtonClicked = true;
    }
  }
  else if (currentPage == "map") {
    for (int i = 0; i < mapPage.stops.size(); i++) {
      StopClass stop = mapPage.stops.get(i);
      if (mouseX > stop.x && mouseX < stop.x + stop.w && mouseY > stop.y && mouseY < stop.y + stop.h) {
        if (stop.isLocked) {
          showMessage("This level is still locked...");
        } else{
          currentLevel = i;
          showMessage("");
          switch(i) {
            case 1:
              startButtonClicked = false;
              level_1 = true;
              break;
            case 2:
              startButtonClicked = false;
              level_2 = true;
              hero.run(577-16, 568-30);
              break;
            case 3:
              startButtonClicked = false;
              level_3 = true;
              hero.run(377-16, 358-30);
              break;
            case 4:
              startButtonClicked = false;
              level_4 = true;
              hero.run(185-16, 314-30);
              break;
            default:
              println("Invalid level number");
              break;
          }
        }
      }
    }
  } else if (currentPage == "level_1") {
    if (!level_1WinWaiting && !level_1FailWaiting) {
      first.first_mousePressed();
    } else if (level_1WinWaiting) {
      if (mouseX > 456 && mouseX < 567 && mouseY > 393 && mouseY < 504) {
        mapPage.stops.get(1).isLocked = false;
        currentPage = "map";
      }
    } else if (level_1FailWaiting) {
      level_1StoryOver = false;
      level_1Selected = false;
      level_1GameOver = false;
      level_1GameWin = false;
      level_1WinWaiting = false;
      level_1FailWaiting = false;
      if (mouseX > 423 && mouseX < 423+178 && mouseY > 440 && mouseY < 440+57) {
        currentPage = "map";
      } else if (mouseX > 423 && mouseX < 423+178 && mouseY > 362 && mouseY < 362+57) {
        currentPage = "level_1";
        first.executionQueue = new ArrayList<Command>();
        first.allBlocksPlaced = false;
        first.gameStarted = false;
        first.heroFail = false;
        first.monsterFail = false;
        first.currentRound = 0;
        first.roundInProgress = false;
        first.combatResultDisplayed = false;
        first.shouldResetRoundStartTime = true;
        bully = null;
      }
    }
  }
}

void showMapScreen() {
  if (mapPage == null) {
    mapPage = new MapPage();
  }
  mapPage.display();
}

void showFirstScreen() {
  if (first == null) {
    first = new Level_1();
  }
  first.display();
}
void showSecondScreen() {
  if (second == null) {
    second = new Level_2();
  }
  second.display();
}
void showThirdScreen() {
  if (third == null) {
    third = new Level_3();
  }
  third.display();
}
void showForthScreen() {
  if (forth == null) {
    forth = new Level_4();
  }
  forth.display();
}

void showMessage(String message) {
  messageText = message;
}
