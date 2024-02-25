class Draggable {
  float x, y;
  float originalX, originalY;
  int w, h;
  boolean dragging = false;
  float offsetX, offsetY;
  Command command;
  int positionIndex = -1;
  int mycolor;
  String label;
  int labelColor;
  
  Draggable(float x_, float y_, int w_, int h_, float originalX_, float originalY_, String label_, int labelColor_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    originalX = originalX_;
    originalY = originalY_;
    label = label_;
    labelColor = labelColor_;
    mycolor = color(0xFF, 0x5F, 0x03, 188);
  }
  
  
  void display() {
    fill(mycolor);
    rect(x, y, w, h, 20);
    fill(labelColor);
    stroke(255); 
    strokeWeight(2);
    textFont(pixelFont, 23);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }
  
  void setCommand(Command cmd) {
    command = cmd;
  }
  
  void pressed(int mx, int my) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      dragging = true;
      offsetX = x - mx;
      offsetY = y - my;
    }
  }
  
  void dragged(int mx, int my) {
    if (dragging) {
      x = mx + offsetX;
      y = my + offsetY;
    }
  }
  
  void released() {
    dragging = false;
    boolean snapped = false;
    for (int i = 0; i < anchors.size(); i++) {
      PVector anchor = anchors.get(i);
      if (abs(x - anchor.x) < 100 && abs(y - anchor.y) < 100) {
        x = anchor.x;
        y = anchor.y;
        positionIndex = i;
        snapped = true;
        break;
      }
    }
    if (!snapped) {
      x = originalX;
      y = originalY;
      positionIndex = -1;
    }
  }

}
