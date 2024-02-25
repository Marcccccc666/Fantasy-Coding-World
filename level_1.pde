import java.util.Collections;
import java.util.Comparator;
class Level_1 {
  PImage[] level_1_Images = new PImage[15];
  int currentImageIndex = -1;
  long imageDisplayStartTime = millis();
  boolean waitingForClick = false;
  PImage finalBackground;
  PImage fightBackground;
  PImage fightWinBackground;
  PImage fightFailBackground;

  ArrayList<Draggable> blocks;
  ArrayList<Command> executionQueue = new ArrayList<Command>();
  boolean allBlocksPlaced = false;
  boolean gameStarted = false;
  PVector startButtonPosition;

  boolean heroFail = false;
  boolean monsterFail = false;
  int currentRound = 0;
  boolean roundInProgress = false;
  boolean combatResultDisplayed = false;

  boolean shouldResetRoundStartTime = true;

  Level_1() {
    surface.setTitle("village");
    loadLevelImages();
    finalBackground = loadImage("background/drag_page.jpg");
    fightBackground = loadImage("background/level_1.jpg");
    fightWinBackground = loadImage("background/level_1_win.jpg");
    fightFailBackground = loadImage("background/level_1_fail.jpg");

    finalBackground.resize(1024, 656);
    fightBackground.resize(1024, 656);
    fightWinBackground.resize(1024, 656);
    fightFailBackground.resize(1024, 656);

    blocks = new ArrayList<Draggable>();
    anchors = new ArrayList<PVector>();

    float blockSpacing = (height - 20 - 4*100) / 5;

    float blockY = 34 + (blockSpacing * (0 + 1)) + (70 * 0);
    blocks.add(new Draggable(688, blockY, 200, 100, 688, blockY, "FIREBALL", color(233, 0, 0)));
    blockY = 34 + (blockSpacing * (1 + 1)) + (70 * 1);
    blocks.add(new Draggable(688, blockY, 200, 100, 688, blockY, "SHIELD", color(215, 235, 233)));

    for (int i = 0; i < 2; i++) {
      float anchorY = 34 + (blockSpacing * (i + 1)) + (70 * i);
      anchors.add(new PVector(136, anchorY));
    }
    blocks.get(0).setCommand(new AttackCommand());
    blocks.get(1).setCommand(new DefenseCommand());
    startButtonPosition = new PVector(401, 574);
  }

  void loadLevelImages() {
    for (int i = 0; i < level_1_Images.length; i++) {
      level_1_Images[i] = loadImage("background/part_2/part_2_" + (i + 1) + ".jpg");
      level_1_Images[i].resize(1024, 656);
    }
  }

  void display() {
    if (currentImageIndex == -1 && millis() - imageDisplayStartTime > 2000) {
      currentImageIndex = 0;
      waitingForClick = true;
    }

    if (currentImageIndex >= 0 && currentImageIndex < level_1_Images.length) {
      background(255);
      image(level_1_Images[currentImageIndex], 0, 0, 1024, 656);
    } else if (currentImageIndex >= level_1_Images.length) {
      level_1StoryOver = true;
      finalBackground.resize(1024, 656);
      background(finalBackground);
      draw_battle_menu_1();
    }
  }

  void mouseClicked() {
    if (waitingForClick && currentImageIndex >= 0 && currentImageIndex < level_1_Images.length) {
      currentImageIndex++;
      waitingForClick = (currentImageIndex < level_1_Images.length);
    }
  }

  void mouseDragged() {
    for (Draggable block : blocks) {
      block.dragged(mouseX, mouseY);
    }
  }

  void mouseReleased() {
    for (Draggable block : blocks) {
      block.released();
      boolean snapped = false;
      for (PVector anchor : anchors) {
        if (abs(block.x - anchor.x) < 50 && abs(block.y - anchor.y) < 50) {
          block.x = anchor.x;
          block.y = anchor.y;
          snapped = true;
          break;
        }
      }
      if (!snapped) {
        block.x = block.originalX;
        block.y = block.originalY;
      }
    }
    checkBlocksPlacement();
  }

  void draw_battle_menu_1() {
    for (Draggable block : blocks) {
      block.display();
    }

    checkBlocksPlacement();
  }

  void checkBlocksPlacement() {
    allBlocksPlaced = true;
    for (PVector anchor : anchors) {
      boolean blockPlaced = false;
      for (Draggable block : blocks) {
        if (abs(block.x - anchor.x) < 50 && abs(block.y - anchor.y) < 50) {
          blockPlaced = true;
          break;
        }
      }
      if (!blockPlaced) {
        allBlocksPlaced = false;
        break;
      }
    }
  }

  void first_mousePressed() {
    for (Draggable block : blocks) {
      block.pressed(mouseX, mouseY);
    }
    if (allBlocksPlaced &&
      mouseX > startButtonPosition.x && mouseX < startButtonPosition.x + 223 &&
      mouseY > startButtonPosition.y && mouseY < startButtonPosition.y + 59) {
      gameStarted = true;
      addCommandsToExecutionQueue();
      level_1Selected = true;
    }
  }


  void addCommandsToExecutionQueue() {
    executionQueue.clear();

    Collections.sort(blocks, new Comparator<Draggable>() {
      @Override
        public int compare(Draggable a, Draggable b) {
        return a.positionIndex - b.positionIndex;
      }
    }
    );

    for (Draggable block : blocks) {
      if (block.positionIndex != -1 && block.command != null) {
        executionQueue.add(block.command);
      }
    }
  }

  void startRound() {
    background(fightBackground);
    hero.x = 257;
    hero.y = 528;
    if (bully == null) {
      bully = new Bully(719, 528);
    }
    if (currentRound == 0) {
      bully.fight();
    } else {
      bully.stay();
    }
    roundInProgress = true;
    combatResultDisplayed = false;
    if (shouldResetRoundStartTime) {
      roundStartTime = millis();
      shouldResetRoundStartTime = false;
    }
  }

  void updateCombat() {
    if (!roundInProgress) return;

    long elapsedTime = millis() - roundStartTime;
    if (executionQueue.isEmpty()) return;

    Command currentCommand = executionQueue.get(0);

    if (elapsedTime < 1000 && !combatResultDisplayed) {
      hero.stay();
    } else if (elapsedTime >= 1000 && !combatResultDisplayed) {
      currentCommand.execute();
      combatResultDisplayed = true;
      if (currentRound == 0 && !currentCommand.getType().equals("defense")) {
        heroFail = true;
      }
    }
    if (elapsedTime >= 3000) {
      shouldResetRoundStartTime = true;
      combatResultDisplayed = false;
      executionQueue.remove(0);
      roundInProgress = false;

      if (heroFail) {
        fail();
      }

      currentRound++;
      if (currentRound < 2) {
        startRound();
      } else {
        win();
      }
    }
  }

  void win() {
    hero.win();
    if (!level_1GameOver) {
      background(fightWinBackground);
    }
    level_1GameOver = true;
    level_1GameWin = true;
    level_1WinWaiting = true;
  }

  void fail() {
    hero.die();
    background(fightFailBackground);
    level_1GameOver = true;
    level_1GameWin = false;
    level_1FailWaiting = true;
  }
}
