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

    public Button(float xcor, float ycor, int width, int height, String text) {
        x = xcor;
        y = ycor;
        w = width;
        h = height;

        hover = false;
        isSelected = false;

        textSize(16);
        text(text, x, y);
    }

    boolean mouseIn() {
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }

    void update() {
        if (mouseIn()) hover = true;
        else hover = false;
    }

    void display() {
        if (img != null) image(img, x, y);
        else {
            fill(20);
            rect(x, y, w, h);
        }

        if (hover) fill(255, 255, 255, 60);
        else noFill();

        if (isSelected) stroke(255);
        else noStroke();

        rect(x, y, w, h);

    }
}
