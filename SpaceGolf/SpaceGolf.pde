float G = 6.67e-11;
long prev;
float dt;
int numcolors = 3;
float[] mass = {2e11, 3e11, 3e16};
float[] radius = {50, 70, 80};
color[] colors = {#ff0000, #00ff00, #0000ff};
PImage ship;
int mx, my;
boolean start;

String currlevel;
LevelOne one;

void setup() {
    size(800, 500);
    currlevel = "one";

    if (currlevel.equals("one")) {
        one = new LevelOne();
        one.setup();
    }
}

void draw() {
    if (currlevel.equals("one")) one.draw();
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

ArrayList<Planet> planets;
Ship player;

// show path preview
void showghost() {
    Ship ghost = new Ship(player.pos.x, player.pos.y, player.vel.x, player.vel.y, player.mass);
    // dotted line displaying next 3 seconds
    dt = 0.1;
    for (int i = 0; i < 30; i++) {
        for (Planet p : planets) p.applyForce(ghost);
        ghost.updatePos();
        if (i%3==2) ghost.drawghost();
    }
}

// draw an arrow displaying the net field at a given point
void showfield(float x, float y) {
    Point loc = new Point(x, y);
    Point f = new Point(0,0);
    for (Planet p : planets) f = f.plus(p.field(loc));
    stroke(100);
    Point p1 = loc.plus(f.normalize().scale(5));
    Point p2 = loc.minus(f.normalize().scale(5));
    drawarrow(p1.x, p1.y, p2.x, p2.y);
}

// find out if player is out of bounds
boolean insideScreen() {
    if (player.pos.x >= 0 && player.pos.x <= 500 && player.pos.y >= 0 && player.pos.y <= 500) return true;
    return false;
}

void mouseClicked() {
   mx = mouseX;
   my = mouseY;
}

void mouseDragged() {
    // println(mouseX - mx);
    for (Planet p : planets) {
        if (p.inside(mouseX, mouseY)) {
            p.move(mouseX, mouseY);
        }
    }
}

void keyPressed() {
    if (key == ' ') {
        if (start) start = false;
        else start = true;
    }
    else if (key == 'q') start = false;
}
