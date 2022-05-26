
float G = 6.67e-11;
long prev;
float dt;
int numcolors = 3;
float[] mass = {2e11, 3e11, 6e15};
float[] radius = {50, 70, 80};
color[] colors = {#ff0000, #00ff00, #0000ff};
PImage ship;

void drawarrow(float x1, float y1, float x2, float y2) {
    line(x1, y1, x2, y2);
    Point p1 = new Point(x1, y1), p2 = new Point(x2, y2);
    Point d = p1.minus(p2);
    Point p = new Point(-d.y, d.x);

    Point v1 = p2.plus(d.scale(1.0/3).plus(p.scale(1.0/6)));
    Point v2 = p2.plus(d.scale(1.0/3).minus(p.scale(1.0/6)));
    line(x2, y2, v1.x, v1.y);
    line(x2, y2, v2.x, v2.y);
}

ArrayList<Planet> planets;
Ship player;

void showghost() {
    Ship ghost = new Ship(player.pos.x, player.pos.y, player.vel.x, player.vel.y, player.mass);
    dt = 0.1;
    for (int i = 0; i < 50; i++) {
        for (Planet p : planets) p.applyForce(ghost);
        ghost.updatePos();
        if (i%5==0) ghost.drawghost();
    }
}

void showfield(float x, float y) {
    Point loc = new Point(x, y);
    Point f = new Point(0,0);
    for (Planet p : planets) f = f.plus(p.field(loc));
    stroke(100);
    Point p1 = loc.plus(f.normalize().scale(5));
    Point p2 = loc.minus(f.normalize().scale(5));
    drawarrow(p1.x, p1.y, p2.x, p2.y);
}

void setup() {
    size(500, 500);
    planets = new ArrayList<Planet>();
    planets.add(new Planet(250, 250, 2));
    player = new Ship(250, 150, 70, 0, 5);
    ship = loadImage("ship.png");
    dt = 0;
    prev = System.currentTimeMillis();
}

void draw() {
    background(20);
    dt = (System.currentTimeMillis() - prev) / 1000.0;
    prev = System.currentTimeMillis();
    for (Planet p : planets) {
        p.applyForce(player);
        p.draw();
    }
    player.updatePos();
    player.draw();
    showghost();
    for (int i = 20; i < 500; i += 40) {
        for (int j = 20; j < 500; j += 40) {
            showfield(i, j);
        }
    }
}
