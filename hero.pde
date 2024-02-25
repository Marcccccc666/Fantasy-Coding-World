class Hero {
  private float x, y;
  public boolean isAttacking = false;
  public boolean isDefending = false;
  private String hand = "right";

  private PImage[] stayFrames = new PImage[4];
  private PImage[] runFrames = new PImage[6];
  private PImage attackFrame1, attackFrame2, attackFrameRight, defenseFrame1, defenseFrame2, shield, dieFrame1, winFrame;
  
  int stayIndex = 0;
  long lastStayMillis = 0;
  
  int runIndex = 0;
  long lastRunMillis = 0;
  boolean runningToTarget = false;
  boolean runningFinished = false;
  
  long attackStartMillis = -1;
  PImage fireballImage;
  float fireballX = -100;
  boolean isFireballVisible = false;
  
  long defenseStartMillis = -1;
  
  long actionStartMillis = -1;
  
  Hero(float x, float y) {
    this.x = x;
    this.y = y;
    loadFrames();
  }

  private void loadFrames() {
    for (int i = 0; i < stayFrames.length; i++) {
      stayFrames[i] = loadImage("charactors/hero/transparent_sprite_" + (i + 1) + ".png");
    }
    for (int i = 0; i < runFrames.length; i++) {
      runFrames[i] = loadImage("charactors/hero/transparent_sprite_" + (i + 7) + ".png");
    }
    attackFrame1 = loadImage("charactors/hero/transparent_sprite_25.png");
    attackFrame2 = loadImage("charactors/hero/transparent_sprite_26.png");
    attackFrameRight = loadImage("charactors/hero/transparent_sprite_27.png");
    defenseFrame1 = loadImage("charactors/hero/transparent_sprite_14.png");
    defenseFrame2 = loadImage("charactors/hero/transparent_sprite_13.png");
    shield = loadImage("charactors/element/shield_resized_fourth.png");
    dieFrame1 = loadImage("charactors/hero/transparent_sprite_5.png");
    winFrame = loadImage("charactors/hero/transparent_sprite_0.png");
  }

  void stay() {
    long currentMillis = millis();
    if (currentMillis - lastStayMillis > 250) {
      stayIndex = (stayIndex + 1) % stayFrames.length;
      lastStayMillis = currentMillis;
    }
    image(stayFrames[stayIndex], x, y);
  }

  void run(float targetX, float targetY) {
    long currentMillis = millis();
    if (!runningToTarget) {
      if (currentMillis - lastRunMillis > 125) {
        runIndex = (runIndex + 1) % runFrames.length;
        lastRunMillis = currentMillis;
        if (runIndex == 0) {
          runningToTarget = true;
        }
      }
      image(runFrames[runIndex], x, y);
    } else {
      x = targetX;
      y = targetY;
      if (currentMillis - lastRunMillis > 125) {
        runIndex = (runIndex + 1) % runFrames.length;
        lastRunMillis = currentMillis;
        if (runIndex == 0) {
          runningToTarget = false;
          runningFinished = true;
        }
      }
      image(runFrames[runIndex], x, y);
    }
  }
  
  void switchHand() {
    if (hand.equals("left")) {
      hand = "right";
    } else {
      hand = "left";
    }
  }
  void attack() {
    if (attackStartMillis == -1) {
      attackStartMillis = millis();
      isFireballVisible = true;
      fireballX = x + 50;
      fireballImage = hand.equals("left") ? 
        loadImage("charactors/element/fireball/red_fireball_left.png") :
        loadImage("charactors/element/fireball/orange_fireball_right.png");
    }
    long currentMillis = millis();
    long elapsed = currentMillis - attackStartMillis;
    if (elapsed <= 500) {
      image(attackFrame1, x, y);
    } else if (elapsed <= 1500) {
      image(hand.equals("left") ? attackFrame2 : attackFrameRight, x, y);
      if (isFireballVisible) {
        image(fireballImage, fireballX, y);
        fireballX += 10;
      }
    } else if (elapsed <= 2000) {
      image(attackFrame1, x, y);
    } else {
      attackStartMillis = -1;
      isFireballVisible = false;
      switchHand();
    }
  }

  void defense() {
    if (defenseStartMillis == -1) {
      defenseStartMillis = millis();
    }
    long currentMillis = millis();
    long elapsed = currentMillis - defenseStartMillis;
    if (elapsed <= 1000) {
      image(defenseFrame1, x, y);
    } else if (elapsed <= 2000) {
      image(defenseFrame2, x, y);
      tint(255, 127);
      image(shield, x - 50, y - 50, shield.width, shield.height);
      noTint();
    } else {
      defenseStartMillis = -1;
    }
  }

  void die() {
    image(dieFrame1, x, y);
  }

  void win() {
    image(winFrame, x, y);
  }
  
}
