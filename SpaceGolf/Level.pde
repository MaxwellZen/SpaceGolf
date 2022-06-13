public class Level{
    Point hole;
    // levelnum: -1 - instructions
    //           0 - game menu
    //           1-5 - actual levels
    int tries, levelnum, stage;
    // stage: 0 - setup the current level
    //        1 - general planning stage
    //        2 - planning stage + planet is selected
    //        3 - release stage
    //        4 - victory stage
    Planet selected;
    PImage holeimg, flagimg, screen;
    PGraphics holepg;
    ArrayList<Star> stars;
    long stop;

    public Level() {
        levelnum = -1;
        stage = 0;
        tries = 1;
        holeimg = loadImage("Pictures/hole.png");
        holeimg.resize(50, 50);
        flagimg = loadImage("Pictures/flag.png");
        flagimg.resize(20, 30);
        holepg = createGraphics(50, 70);
        holepg.beginDraw();
        holepg.image(holeimg, 0, 20);
        holepg.image(flagimg, 20, 0);
        holepg.endDraw();

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
            lbuttons.add(new LevelButton(80 + 160*(i-1), 350, i, (i <= maxlevel)));
        }

    }

    void play() {
        if (levelnum==-1) instruc();
        else if (levelnum==0) menu();
        else if (stage==0) setuplevel();
        else if (stage==1) planning();
        else if (stage==2) planetselect();
        else if (stage==3) release();
        else if (stage==4) victory();
    }

    void instruc() {
        // image(bg, 0, 0);
        image(pg, 0, 0);
        textSize(60);
        textAlign(CENTER);
        fill(225, 225, 225);
        text("SPACE GOLF", 400, 170);

        textSize(16);
        textAlign(CENTER);
        text("The rocket ship is stranded in space and wants to return to Earth safely!", 400, 200);

        textSize(14);
        text("1) Each planet has a set mass and radius. They increase in both size and", 400, 250);
        text("mass.", 400, 270);
        text("2) The stone planets cannnot be moved.", 400, 310);
        text("3) The rocket ship has a set starting position and initial velocity.", 400, 350);
        text("4) Players are able to modify size and placement of all planets excluding the", 400, 390);
        text("stone planets and Earth.", 400, 410);
        text("5) If the rocket escapes too far from the screen or is stuck bouncing around", 400, 460);
        text("planets, it will eventually die and be reset.", 400, 480);

        // LevelButton b_menu = new LevelButton(50, 50, 0, true);
        // b_menu.display();
        // b_menu.update();


        fill(50);
        stroke(255);
        int bx = 30, by = 30;
        int bw = 165, bh = 40;
        if (inBox(20, 155, 20, 60)) fill(100);
        rect(20, 20, 135, 40);

        textSize(16);
        fill(255);
        textAlign(LEFT);
        text("CONTINUE", 40, 57);
    }

    void menu() {
        // image(bg, 0, 0);
        image(pg, 0, 0);
        textSize(60);
        textAlign(CENTER);
        fill(225, 225, 225);
        text("SPACE GOLF", 400, 170);
        textSize(17);
        text("-----------LEVEL MENU-----------", 400, 300);
        image(shipimg, 130, 80);
        image(shipimg, 617, 80);

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

        if (hole.dist(player.pos) <= 45) {
            stage = 4;
            save("temp.tif");
            screen = loadImage("temp.tif");

            maxlevel = max(maxlevel, levelnum+1);
            writemax();
            if (levelnum < 5) lbuttons.get(levelnum).reached = true;

            stars = new ArrayList<Star>();
            int numstars = 10;
            for (int i = 0; i < numstars; i++) {
                stars.add(new Star(player.pos.x, player.pos.y, TWO_PI*i/numstars));
            }

            stop = cur + 3000;
        }

        if (! insideScreen() && player.pos.dist(new Point(250, 250)) > 750) {
            stage = 0;
            tries += 1;
        }
        if (cur > stop) {
            stage = 0;
            tries += 1;
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
        // image(pg, 0, 0);

        showfield();

        for (Planet p : planets) p.draw();

        player.draw();
        if (! insideScreen()) showlocation();

        showghost();

        image(holepg, hole.x - 25, hole.y - 45);
        // image(holeimg, hole.x - 25, hole.y - 25);
        // image(flagimg, hole.x-5, hole.y-45);

        showtries();

        fill(0);
        rect(500, 0, 300, 500);

        textSize(12);
        textAlign(LEFT);
        fill(225, 225, 225);
        text("Click on a planet to access the sidebar", 515, 350);
        text("Drag it around to change its position", 530, 370);

        fill(50);
        stroke(255);
        if (inBox(620, 785, 433, 473)) fill(100);
        rect(620, 433, 165, 40);

        textSize(16);
        fill(255);
        textAlign(LEFT);
        text("BACK TO MENU", 640, 470);
    }

    void showtries() {
        textSize(16);
        fill(255);
        textAlign(LEFT);
        text("tries: " + tries, 30, 50);
    }
}
