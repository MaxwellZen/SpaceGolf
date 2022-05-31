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

  boolean mouseIn() {
      return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }

  void update() {
    if (mouseIn()) hover = true;
    else hover = false;
  }

  void display() {
    if (img != null) {
      img.resize((int) w, (int) h);
      image(img, x, y);
    }

    fill(142, 80, 80);
    if (hover) fill(255, 255, 255, 60);
    if (clickedOn) fill(255, 255, 255, 60);

    rect(x, y, w, h);
  }

}
