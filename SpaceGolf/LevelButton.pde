public class LevelButton {
    boolean hover;
    boolean reached;
    float x, y;
    float r;
    float theta;
    PImage img;
    int num;

    public LevelButton(float xcor, float ycor, int n, boolean reach) {
        x = xcor;
        y = ycor;
        num = n;
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

        PImage p = loadImage("Pictures/planet" + String.valueOf(num) + ".png");
		p.resize((int)r * 2, (int)r * 2);
        image(p, (int)x - r, (int)y - r);

        // set button color
        if (reached && hover) fill(255, 255, 255, 70);
        else if (reached) fill(0, 0, 0, 10);
        else fill(0, 0, 0, 95);
        circle(x, y, 2*r);

        if (reached && hover) {
            pushMatrix();
            translate(x + 50 * sin(theta), y - 50 * cos(theta));
            rotate(PI/2 + theta);
            image(img, -12, -20, 24, 40);
            popMatrix();

            if (mousePressed == true) level.levelnum = num;
        }
    }
}
