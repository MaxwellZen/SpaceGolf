ArrayList<Button> buttons;

public class Button{
    boolean hover, clickedOn;
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
        clickedOn = false;
    }

    boolean mouseIn() {
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }

    void update() {
        if (mouseIn()) hover = true;
        else hover = false;
    }

    void select() {}

    void display() {
        if (img != null) {
            img.resize((int) w, (int) h);
            image(img, x, y);
        }

        // fill(142, 80, 80);
        // rect(x, y, w, h);
        String name = "";
        if (num == 0) name = "Pictures/zero.png";
        if (num == 1) name = "Pictures/one.png";
        if (num == 2) name = "Pictures/two.png";
        if (num == 3) name = "Pictures/three.png";
        if (num == 4) name = "Pictures/four.png";
        if (num == 5) name = "Pictures/five.png";
        if (num == 6) name = "Pictures/six.png";
        if (num == 7) name = "Pictures/seven.png";

        img = loadImage(name);
        img.resize((int) w, (int) h);
        image(img, x, y);

        if (hover) {
            fill(255, 255, 255, 60);
            rect(x, y, w, h);
        }

        if (clickedOn) {
            fill(255, 255, 255, 60);
            rect(x, y, w, h);
        }

    }
}
