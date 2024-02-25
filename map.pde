class MapPage {
  PImage bgImage;
  ArrayList<StopClass> stops = new ArrayList<StopClass>();
  PImage[] introImages = new PImage[6];
  int currentImageIndex = -1;
  long imageDisplayStartTime = millis();
  boolean waitingForClick = false;
  

  MapPage() {
    bgImage = loadImage("background/map_page.jpg");
    bgImage.resize(1024, 656);
    loadIntroImages();
    initStops();
  }

  void loadIntroImages() {
    for (int i = 0; i < introImages.length; i++) {
      introImages[i] = loadImage("background/part_1/part_1_" + (i + 1) + ".jpg");
      introImages[i].resize(1024, 656);
    }
  }

  void initStops() {
    stops.add(new StopClass(804, 469, 32, 32, false, false));
    stops.add(new StopClass(749, 328, 32, 32, true, false));
    stops.add(new StopClass(577, 568, 32, 32, true, false));
    stops.add(new StopClass(377, 358, 32, 32, true, false));
    stops.add(new StopClass(185, 314, 32, 32, true, false));
    stops.add(new StopClass(352, 166, 42, 42, true, false));
  }

  void display() {
    if (currentImageIndex == -1 && millis() - imageDisplayStartTime > 2000) {
      currentImageIndex = 0;
      imageDisplayStartTime = millis();
      waitingForClick = true;
    }

    if (currentImageIndex >= 0 && currentImageIndex < introImages.length) {
      background(bgImage);
      image(introImages[currentImageIndex], 0, 0, 1024, 656);
    } else if (currentImageIndex >= introImages.length) {
      introIsFinished = true;
      surface.setTitle("Map");
      background(bgImage);
      for (StopClass stop : stops) {
        stop.display();
      }
      currentPage = "map";
      stops.get(1).isLocked = false;
    }
  }

  void mouseClicked() {
    if (waitingForClick && currentImageIndex >= 0 && currentImageIndex < introImages.length) {
      currentImageIndex++;
      waitingForClick = (currentImageIndex < introImages.length);
      if (currentImageIndex < introImages.length) {
        waitingForClick = true;
      }
    }
  }
}
