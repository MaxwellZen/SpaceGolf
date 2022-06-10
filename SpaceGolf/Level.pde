public class Level{
    Point hole;
    int tries, levelnum, stage;
    // stage: 0 if setup the current level
    //        1 if in general planning stage
    //        2 if in planning stage + planet is selected
    //        3 if in release stage
    Planet selected;
    PImage holeimg;

    public Level() {
        levelnum = 1;
        stage = 0;
        holeimg = loadImage("Pictures/hole.png");
        holeimg.resize(50, 50);
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

        showfield();

        for (Planet p : planets) p.draw();

        player.draw();

        showghost();

        image(holeimg, hole.x - 25, hole.y - 25);

        showtries();

        fill(30);
        rect(500, 0, 300, 500);

    }

    void planetselect() {
        background(20);

        showfield();

        for (Planet p : planets) p.draw();

        // address each button
        for (int i = 0; i < 6; i++) {
            Button b = buttons.get(i);
            b.update();
            if (mousePressed && b.mouseIn()) {
                buttonSelect(i);
                selected.setcolor(i);
            }
        }

        // update the player
        player.draw();

        // show the preview
        showghost();

        // hole
        image(holeimg, hole.x - 25, hole.y - 25);

        // inside screen stuff
        if (! insideScreen()) showlocation();

        // tries
        showtries();

        fill(30);
        rect(500, 0, 300, 500);

        // buttons
        for (Button b : buttons) {
            b.update();
            b.display();
        }
    }


    void release() {
        background(20);

        // show the gravitational field
        showfield();

        // address each planet
        for (Planet p : planets) {
            p.applyForce(player);
            p.draw();
        }

        // update the player
        player.updatePos();
        player.draw();

        // show the preview
        showghost();

        // hole
        image(holeimg, hole.x - 25, hole.y - 25);

        // game end conditions
        if (hole.dist(player.pos) <= 50) {
            stage = 0;
        }

        // inside screen stuff
        if (! insideScreen()) showlocation();

        showtries();

        fill(30);
        rect(500, 0, 300, 500);

    }

    //         )     (    (       (      (            )             (       )     ) (
    //      ( /(     )\ ) )\ )    )\ )   )\ )      ( /(   (    *   ))\ ) ( /(  ( /( )\ )
    //      )\())(  (()/((()/((  (()/(  (()/(   (  )\())  )\ ` )  /(()/( )\()) )\()|()/(
    //     ((_)\ )\  /(_))/(_))\  /(_))  /(_))  )\((_)\ (((_) ( )(_))(_)|(_)\ ((_)\ /(_))
    //      _((_|(_)(_)) (_))((_)(_))   (_))_| ((_)_((_))\___(_(_()|_))   ((_) _((_|_))
    //     | || | __| |  | _ \ __| _ \  | |_| | | | \| ((/ __|_   _|_ _| / _ \| \| / __|
    //     | __ | _|| |__|  _/ _||   /  | __| |_| | .` || (__  | |  | | | (_) | .` \__ \
    //     |_||_|___|____|_| |___|_|_\  |_|  \___/|_|\_| \___| |_| |___| \___/|_|\_|___/

    void showtries() {
        // tries
        textSize(20);
        fill(0, 408, 612, 204);
        text("try # " + tries, 40, 40);
    }
}
