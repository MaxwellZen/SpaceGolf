public class Button{
    boolean hover, isSelected;
    float x, y;
    PImage img;
    int num;
    int w = 55;
    int h = 55;

    public Button(float xcor, float ycor, int number) {
        x = xcor;
        y = ycor;
        num = number;

        hover = false;
        isSelected = false;

        String name = "Pictures/planet" + String.valueOf(num) + ".png";

        img = loadImage(name);
        img.resize((int) w, (int) h);
    }

    boolean mouseIn() {
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }

    void update() {
        if (mouseIn()) hover = true;
        else hover = false;
    }

    void display() {

        image(img, x, y);

        if (hover) fill(255, 255, 255, 60);
        else noFill();

        if (isSelected) stroke(255);
        else noStroke();

        rect(x, y, w, h);

    }
}
