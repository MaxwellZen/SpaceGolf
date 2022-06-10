public class Level{
    Point hole;
    int tries, levelnum, stage;
    // stage: 0 if setup the current level
    //        1 if in general planning stage
    //        2 if in planning stage + planet is selected
    //        3 if in release stage
    Planet selected;
    Button bselected;

    public Level() {
        levelnum = 1;
        stage = 0;
    }

    void setup() {

        // sidebar
        buttons = new ArrayList<Button>();
        buttons.add(new Button(550, 100, 1));
        buttons.add(new Button(620, 100, 2));
        buttons.add(new Button(690, 100, 3));
        buttons.add(new Button(550, 170, 4));
        buttons.add(new Button(620, 170, 5));
        buttons.add(new Button(690, 170, 6));

    }

    void play() {
        println(stage);
        if (stage==0) {
            setuplevel();
        } else if (stage==1) {
            planning();
        } else if (stage==2) {
            planetselect();
        } else if (stage==3) {
            release();
        }
    }

    void setuplevel() {

        tries = 0;

        // parse dat shit
        try {
            String path = "LevelData/level" + String.valueOf(levelnum) + ".txt";
            byte[] bytes = loadBytes(path);
            String str = new String(bytes);
            Scanner s = new Scanner(str);

            println(s.next());
            hole = new Point(s.nextInt(), s.nextInt());

            s.next();
            player = new Ship(s.nextInt(), s.nextInt(), s.nextInt(), s.nextInt(), s.nextInt());

            s.next();
            int numplanets = s.nextInt();
            planets = new ArrayList<Planet>();
            for (int i = 0; i < numplanets; i++)
                planets.add(new Planet(s.nextInt(), s.nextInt(), s.nextInt()));

            s.close();
        } catch (Exception e) {
            println(e);
            println("bruh u suck");
        }

        stage = 1;

    }

    void planning() {
        background(20);

        // show the gravitational field
        for (int i = 10; i < 500; i += 40) {
            for (int j = 10; j < 500; j += 40) {
                showfield(i, j);
            }
        }

        // address each planet
        for (Planet p : planets) p.draw();

        // address each button
        // buttons
        fill(20);
        rect(500, 0, 300, 500);

        for (Button b : buttons) {
            b.update();
            b.display();
            if (mousePressed && b.mouseIn()) {
                bselected = b;
                stage = 2;
            }
        }

        // update the player
        player.draw();

        // show the preview
        showghost();

        // hole
        fill(200);
        circle(hole.x, hole.y, 50);

        // tries
        textSize(20);
        fill(0, 408, 612, 204);
        text("try # " + tries, 40, 40);
    }

    void planetselect() {
        background(20);

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

        // address each button
        if (bselected != null) bselected.clickedOn = true;
        if (mousePressed) {
            for (Button b : buttons) {
                if (b.mouseIn() && b != bselected) {
                    bselected = null;
                    bselected = b;
                }
                else if (b.mouseIn() && b == bselected) {
                    bselected = null;
                    stage = 1;
                }
            }
            if (0 <= mouseX && mouseX <= 500 && 0 <= mouseY && mouseY <= 500) {
                planets.add(new Planet(mouseX, mouseY));
                bselected = null;
                stage = 1;
            }
        }

        // update the player
        if (start) player.updatePos();
        player.draw();

        // show the preview
        showghost();

        // hole
        fill(200);
        circle(hole.x, hole.y, 50);

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


    void release() {
        background(20);

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
        if (hole.dist(player.pos) <= 50) {
            stage = 0;
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
