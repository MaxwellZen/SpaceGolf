public class LevelButton {
    boolean hover;
    boolean reached;
    float x, y;
    float r;
    float theta;
    PImage img;

    public LevelButton(float xcor, float ycor, boolean reach) {
        x = xcor;
        y = ycor;
        reached = reach;

        hover = false;

        r = 30;

		img = loadImage("Pictures/ship.png");
    }

    boolean mouseIn() {
        return sq(mouseX - x) + sq(mouseY - y) < sq(r);
    }

    void update() {
        if (mouseIn()) {
            if (hover) theta += TWO_PI * dt / 3;
            else theta = 0;
            hover = true;
        } else hover = false;
    }

    void display() {
        noStroke();
        // set button color
        if (reached && hover) fill(51, 204, 51);
        else if (reached) fill(0, 128, 0);
        else fill(77, 0, 0);
        circle(x, y, 2*r);

        if (reached && hover) {
            pushMatrix();
            translate(x + 50 * sin(theta), y - 50 * cos(theta));
            rotate(PI/2 + theta);
            image(img, -12, -20, 24, 40);
            popMatrix();
        }
    }
}
