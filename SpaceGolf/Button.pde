ArrayList<Button> buttons;

public class Button{
  boolean hover, clickedOn;
  float x, y;
  PImage img;
  int number;
  int w = 55;
  int h = 55;

  public Button(float xcor, float ycor, int num) {
    x = xcor;
    y = ycor;
    number = num;

    hover = false;
    clickedOn = false;
  }

  void update() {
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) hover = true;
    else hover = false;
  }

  void display() {
    if (img != null) {
      img.resize((int) w, (int) h);
      image(img, x, y);
    }

    fill(142, 80, 80);
    rect(x, y, w, h);

    if (hover) {
      fill(255, 255, 255, 60);
      rect(x, y, w, h);
    }

    if (clickedOn) {
      fill(255, 255, 255, 60);
      rect(x, y, w, h);
    }
  }

  boolean hover() {
    return hover;
  }

  void hover(boolean hold) {
    hover = hold;
  }

  void clickedOn(boolean hold) {
    clickedOn = hold;
  }

  boolean clickedOn() {
    return clickedOn;
  }

}
