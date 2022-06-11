import java.util.Scanner;

float G = 6.67e-11;
long prev, cur;
float dt;
float[] mass = {1e16, 2e16, 3e16, 4e16, 5e16, 6e16};
int[] radius = {30, 40, 50, 60, 70, 80};
ArrayList<Button> buttons;
ArrayList<LevelButton> lbuttons;

String currlevel;
Level level;

ArrayList<Planet> planets;
Ship player;

void setup() {
    size(800, 500);
    pixelDensity(2);

    level = new Level();

    dt = 0;
    prev = System.currentTimeMillis();

    PFont font = createFont("Minecraftia", 30);
    textFont(font);
    fill(255, 255, 255);
}

void draw() {

    // update time variables
    cur = System.currentTimeMillis();
    dt = (cur - prev) / 1000.0;
    prev = cur;

    level.play();
}

void mousePressed() {
    if (level.stage==1 || level.stage==2) {
        boolean found = false;
        for (Planet p : planets) {
            if (p.inside(mouseX, mouseY) && (level.stage==1 || level.stage==2)) {
                level.stage = 2;
                level.selected = p;
                buttonSelect(p.num);
                found = true;
            }
        }
        if (level.stage==2 && mouseX<500 && !found) {
            level.selected = null;
            level.stage=1;
        }
    }
}

void mouseDragged() {
    if (level.stage==2) {
        for (Planet p : planets) {
            if (p.inside(mouseX, mouseY)) {
                boolean intersect = false;
                for (Planet q : planets) {
                    if ((q.pos.x != p.pos.x || q.pos.y != p.pos.y) && dist(mouseX, mouseY, q.pos.x, q.pos.y) < p.r + q.r + 10) intersect = true;
                }
                if (!intersect) p.move(mouseX, mouseY);
            }
        }
    }
}

void keyPressed() {
    if (key == ' ') {
        level.stage = 3;
    }
    else if (key == 'q') level.stage = 1;
}


//         )     (    (       (      (            )             (       )     ) (
//      ( /(     )\ ) )\ )    )\ )   )\ )      ( /(   (    *   ))\ ) ( /(  ( /( )\ )
//      )\())(  (()/((()/((  (()/(  (()/(   (  )\())  )\ ` )  /(()/( )\()) )\()|()/(
//     ((_)\ )\  /(_))/(_))\  /(_))  /(_))  )\((_)\ (((_) ( )(_))(_)|(_)\ ((_)\ /(_))
//      _((_|(_)(_)) (_))((_)(_))   (_))_| ((_)_((_))\___(_(_()|_))   ((_) _((_|_))
//     | || | __| |  | _ \ __| _ \  | |_| | | | \| ((/ __|_   _|_ _| / _ \| \| / __|
//     | __ | _|| |__|  _/ _||   /  | __| |_| | .` || (__  | |  | | | (_) | .` \__ \
//     |_||_|___|____|_| |___|_|_\  |_|  \___/|_|\_| \___| |_| |___| \___/|_|\_|___/

//
void buttonSelect(int i) {
    for (int j = 0; j < 6; j++) {
        buttons.get(j).isSelected = false;
    }
    buttons.get(i).isSelected = true;
}

// draw arrow from point 1 to point 2
void drawarrow(float x1, float y1, float x2, float y2) {
    line(x1, y1, x2, y2);
    Point p1 = new Point(x1, y1), p2 = new Point(x2, y2);
    Point d = p1.minus(p2);
    Point p = new Point(-d.y, d.x);

    Point v1 = p2.plus(d.scale(1.2/3).plus(p.scale(1.2/6)));
    Point v2 = p2.plus(d.scale(1.2/3).minus(p.scale(1.2/6)));
    line(x2, y2, v1.x, v1.y);
    line(x2, y2, v2.x, v2.y);
}
void drawarrow(Point p1, Point p2) {drawarrow(p1.x, p1.y, p2.x, p2.y);}

// show path preview
void showghost() {
    Ship ghost = new Ship(player);
    // dotted line displaying next 3 seconds
    dt = 0.05;
    for (int i = 0; i < 60; i++) {
        for (Planet p : planets) p.applyForce(ghost);
        ghost.updatePos();
        if (i%6==5) ghost.drawghost();
    }
    dt = (cur - prev) / 1000.0;
}

// draw an arrow displaying the net field at a given point
void showfield() {
    for (int x = 10; x < 500; x += 40) {
        for (int y = 10; y < 500; y += 40) {
            Point loc = new Point(x, y);
            Point f = new Point(0,0);
            for (Planet p : planets) f = f.plus(p.field(loc));
            stroke(100);
            Point p1 = loc.plus(f.normalize().scale(5));
            Point p2 = loc.minus(f.normalize().scale(5));
            drawarrow(p2, p1);
        }
    }
}

// find out if player is out of bounds
boolean insideScreen() {
    if (player.pos.x >= 0 && player.pos.x <= 500 && player.pos.y >= 0 && player.pos.y <= 500) return true;
    return false;
}

// draw arrow pointing to out-of-bounds player
void showlocation() {
    float curX = min(490, max(10, player.pos.x));
    float curY = min(490, max(10, player.pos.y));

    Point head = new Point(curX, curY);
    Point direction = player.pos.minus(head).normalize();
    Point tail = head.minus(direction.scale(20));

    stroke(255);
    drawarrow(tail, head);
}
