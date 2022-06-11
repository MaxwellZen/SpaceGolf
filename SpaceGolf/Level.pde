public class Level{
    Point hole;
    // levelnum: 0 - game menu
    //           1-5 - actual levels
    int tries, levelnum, stage;
    // stage: 0 - setup the current level
    //        1 - general planning stage
    //        2 - planning stage + planet is selected
    //        3 - release stage
    //        4 - victory stage
    Planet selected;
    PImage holeimg, screen;
    ArrayList<Star> stars;
    long stop;

    public Level() {
        levelnum = 0;
        stage = 0;
        holeimg = loadImage("Pictures/hole.png");
        holeimg.resize(50, 50);

        // sidebar
        buttons = new ArrayList<Button>();
        buttons.add(new Button(550, 100, 1));
        buttons.add(new Button(620, 100, 2));
        buttons.add(new Button(690, 100, 3));
        buttons.add(new Button(550, 170, 4));
        buttons.add(new Button(620, 170, 5));
        buttons.add(new Button(690, 170, 6));

        // menu
        lbuttons = new ArrayList<LevelButton>();
        lbuttons.add(new LevelButton(80, 350, true));
        lbuttons.add(new LevelButton(240, 350, true));
        lbuttons.add(new LevelButton(400, 350, true));
        lbuttons.add(new LevelButton(560, 350, false));
        lbuttons.add(new LevelButton(720, 350, false));

    }

    void play() {
        if (levelnum==0) menu();
        else if (stage==0) setuplevel();
        else if (stage==1) planning();
        else if (stage==2) planetselect();
        else if (stage==3) release();
        else if (stage==4) victory();
    }

    void menu() {
        background(20);
        textSize(50);
        fill(153, 0, 153);
        textAlign(CENTER);
        text("SPACE GOLF", 400, 100);

        for (LevelButton lb : lbuttons) {
            lb.update();
            lb.display();
        }
    }

    void setuplevel() {

        tries = 1;

        // parse dat shit
        try {
            String path = "LevelData/level" + String.valueOf(levelnum) + ".txt";
            byte[] bytes = loadBytes(path);
            String str = new String(bytes);
            Scanner s = new Scanner(str);

            s.next();
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
        display();
    }

    void planetselect() {
        display();

        // buttons
        for (int i = 0; i < 6; i++) {
            Button b = buttons.get(i);
            b.update();
            if (mousePressed && b.mouseIn()) {
                buttonSelect(i);
                selected.setcolor(i);
            }
        }
        for (Button b : buttons) b.display();
    }


    void release() {
        for (Planet p : planets) p.applyForce(player);
        player.updatePos();

        display();

        if (hole.dist(player.pos) <= 50) {
            stage = 4;
            save("temp.tif");
            screen = loadImage("temp.tif");
            stars = new ArrayList<Star>();
            int numstars = 10;
            for (int i = 0; i < numstars; i++) {
                stars.add(new Star(400, 200, TWO_PI*i/numstars));
            }
            stop = cur + 4000;
        }

    }

    void victory() {
        image(screen, 0, 0, 800, 500);
        for (Star star : stars) {
            star.updatePos();
            star.draw();
        }
        if (cur > stop) levelnum = 0;
    }

    //         )     (    (       (      (            )             (       )     ) (
    //      ( /(     )\ ) )\ )    )\ )   )\ )      ( /(   (    *   ))\ ) ( /(  ( /( )\ )
    //      )\())(  (()/((()/((  (()/(  (()/(   (  )\())  )\ ` )  /(()/( )\()) )\()|()/(
    //     ((_)\ )\  /(_))/(_))\  /(_))  /(_))  )\((_)\ (((_) ( )(_))(_)|(_)\ ((_)\ /(_))
    //      _((_|(_)(_)) (_))((_)(_))   (_))_| ((_)_((_))\___(_(_()|_))   ((_) _((_|_))
    //     | || | __| |  | _ \ __| _ \  | |_| | | | \| ((/ __|_   _|_ _| / _ \| \| / __|
    //     | __ | _|| |__|  _/ _||   /  | __| |_| | .` || (__  | |  | | | (_) | .` \__ \
    //     |_||_|___|____|_| |___|_|_\  |_|  \___/|_|\_| \___| |_| |___| \___/|_|\_|___/

    void display() {
        background(20);

        showfield();

        for (Planet p : planets) p.draw();

        player.draw();
        if (! insideScreen()) showlocation();

        showghost();

        image(holeimg, hole.x - 25, hole.y - 25);

        showtries();

        fill(30);
        rect(500, 0, 300, 500);
    }

    void showtries() {
        textSize(20);
        fill(0, 408, 612, 204);
        textAlign(LEFT);
        text("try # " + tries, 40, 40);
    }
}
