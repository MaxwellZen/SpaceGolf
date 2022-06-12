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
        tries = 1;
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
        for (int i = 1; i <= 5; i++) {
            println(i <= maxlevel);
            lbuttons.add(new LevelButton(80 + 160*(i-1), 350, i, (i <= maxlevel)));
        }
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
        textSize(60);
        textAlign(CENTER);
        fill(225, 225, 225);
        text("SPACE GOLF", 400, 150);

        for (LevelButton lb : lbuttons) {
            lb.update();
            lb.display();
        }

        textSize(13);
        fill(255);
        textAlign(CENTER);
        for (int i = 1; i <= 5; i++) {
            text("LV " + String.valueOf(i), 80 + 161*(i-1), 410);
            if (i==maxlevel) fill(100);
        }
    }

    void setuplevel() {

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
                selected.setcolor(i+1);
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
                stars.add(new Star(player.pos.x, player.pos.y, TWO_PI*i/numstars));
            }
            stop = cur + 3000;
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
        if (! insideScreen() && player.pos.dist(new Point(0, 0)) > 750) {
            stage = 0;
            tries += 1;
        }

        showghost();

        image(holeimg, hole.x - 25, hole.y - 25);

        showtries();

        fill(30);
        rect(500, 0, 300, 500);
    }

    void showtries() {
        textSize(16);
        fill(255);
        textAlign(LEFT);
        text("tries: " + tries, 30, 50);
    }
}
