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
        ship = loadImage("ship.png");
        dt = 0;
        prev = System.currentTimeMillis();

        // sidebar
        buttons = new ArrayList<Button>();
        buttons.add(new Button(550, 100, 1));
        buttons.add(new Button(620, 100, 2));
        buttons.add(new Button(690, 100, 3));
        buttons.add(new Button(550, 170, 4));
        buttons.add(new Button(620, 170, 5));
        buttons.add(new Button(690, 170, 6));

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
        // show the gravitational field
        for (int i = 10; i < 500; i += 40) {
            for (int j = 10; j < 500; j += 40) {
                showfield(i, j);
            }
        }
        for (Button b : buttons) {
            b.update();
            b.display();
        }

        // hole
        fill(200);
        circle(hole.x, hole.y, 50);

        // tries
        textSize(20);
        fill(0, 408, 612, 204);
        text("try # " + tries, 40, 40);
    }
}
