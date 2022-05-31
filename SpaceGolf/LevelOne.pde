public class LevelOne{
    Point hole = new Point(250, 400);
    int tries;

    public LevelOne() {
        tries = 0;
    }

    void setup() {
        start = false;

        // game
        planets = new ArrayList<Planet>();
        planets.add(new Planet(250, 250, 2));
        player = new Ship(250, 100, 165, 0, 5);

        // hole
        fill(153);
        circle(hole.x, hole.y, 50);

        // tries
        textSize(20);
        fill(0, 408, 612, 204);
        text("try # " + tries, 40, 40);
    }


    void draw() {
        background(20);
        // update time variables
        long cur = System.currentTimeMillis();
        dt = (cur - prev) / 1000.0;
        prev = cur;

        // show the gravitational field
        for (int i = 10; i < 500; i += 40) {
            for (int j = 10; j < 500; j += 40) {
                showfield(i, j);
            }
        }

        // address each planet
        for (Planet p : planets) {
            if (start) p.applyForce(player);
            p.draw();
        }

        // update the player
        if (start) player.updatePos();
        player.draw();

        // show the preview
        showghost();

        // hole
        fill(200);
        circle(hole.x, hole.y, 50);

        // game end conditions
        if (one.hole.dist(player.pos) <= 50) {
            start = false;
            delay(1500);
            one.setup();
        }

        // inside screen stuff
        if (! insideScreen()) showlocation();

        // tries
        textSize(20);
        fill(0, 408, 612, 204);
        text("try # " + tries, 40, 40);

        // buttons
        fill(20);
        rect(500, 0, 300, 500);

        for (Button b : buttons) {
            b.update();
            b.display();
        }

    }
}
