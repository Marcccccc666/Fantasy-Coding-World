class StopClass {
    int x, y, w, h;
    boolean isLocked;
    boolean isFinal;

    StopClass(int x, int y, int w, int h, boolean isLocked, boolean isFinal) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.isLocked = isLocked;
      this.isFinal = isFinal;
    }

    void display() {
      noStroke();
      if (isFinal) {
        fill(color(255, 50, 50));
        finalImage = loadImage("charactors/element/black_death.png");
        image(finalImage, 351, 149, 46, 65);
      } else if (isLocked) {
        fill(color(70, 70, 70, 100));
      } else {
        noFill();
      }
      ellipse(x + w/2, y + h/2, w, h);
    }
  }
