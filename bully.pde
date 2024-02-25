class Bully {
  private float x, y;
  private PImage[] showFrames = new PImage[4];
  private PImage[] stayFrames = new PImage[4];
  private PImage fightFrame1, fightFrameMoveUp, fightFrameMoveDown;

  int showIndex = 0;
  long lastShowMillis = 0;
  
  int stayIndex = 0;
  long lastStayMillis = 0;
  
  long fightStartMillis = -1;
  boolean isFighting = false;
  float fightYOffset = 0;
  
  Bully(float x, float y) {
    this.x = x;
    this.y = y;
    loadFrames();
  }

  private void loadFrames() {
    showFrames[0] = loadImage("charactors/bully/processed_sprite_5_1.png");
    showFrames[1] = loadImage("charactors/bully/processed_sprite_5_2.png");
    showFrames[2] = loadImage("charactors/bully/processed_sprite_5_1.png");
    showFrames[3] = loadImage("charactors/bully/processed_sprite_5_3.png");
    
    for (int i = 0; i < stayFrames.length; i++) {
      stayFrames[i] = loadImage("charactors/bully/processed_sprite_1_" + (i + 1) + ".png");
    }
    
    fightFrame1 = loadImage("charactors/bully/processed_sprite_5_1.png");
    fightFrameMoveUp = loadImage("charactors/bully/processed_sprite_3_2.png");
    fightFrameMoveDown = loadImage("charactors/bully/processed_sprite_3_4.png");
  }

  void show() {
    long currentMillis = millis();
    if (currentMillis - lastShowMillis > 250) {
      showIndex = (showIndex + 1) % showFrames.length;
      lastShowMillis = currentMillis;
    }
    image(showFrames[showIndex], x, y);
  }

  void stay() {
    long currentMillis = millis();
    if (currentMillis - lastStayMillis > 250) {
      stayIndex = (stayIndex + 1) % stayFrames.length;
      lastStayMillis = currentMillis;
    }
    image(stayFrames[stayIndex], x, y);
  }

  void fight() {
    long currentMillis = millis();
    if (fightStartMillis == -1) {
      fightStartMillis = currentMillis;
      isFighting = true;
    }
    float tmp_x = this.x;
    float tmp_y = this.y;
    
    long elapsed = currentMillis - fightStartMillis;
    if (elapsed <= 1000) {
      image(fightFrame1, x, y);
    } else if (elapsed <= 2000) {
      fightYOffset = map(elapsed, 1000, 2000, 0, -100);
      image(fightFrameMoveUp, x, y + fightYOffset);
    } else if (elapsed <= 3000) {
      float xOffset = map(elapsed, 2000, 3000, 0, -400);
      float yOffset = map(elapsed, 2000, 3000, -100, 0);
      image(fightFrameMoveDown, x + xOffset, y + fightYOffset + yOffset);
    } else {
      isFighting = false;
    }
    this.x = tmp_x;
    this.y = tmp_y;
  }
}
