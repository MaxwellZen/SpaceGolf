

void drawarrow(float x1, float y1, float x2, float y2) {
    line(x1, y1, x2, y2);
    Point p1 = new Point(x1, y1), p2 = new Point(x2, y2);
    Point d = p1.minus(p2).normalize();
    Point p = new Point(-d.y, d.x);
    
    Point v1 = p2.plus(d.scale(20).plus(p.scale(15)));
    Point v2 = p2.plus(d.scale(20).minus(p.scale(15)));
    triangle(v1.x, v1.y, v2.x, v2.y, x2, y2);
}

void setup() {
    size(500, 500);
    drawarrow(100, 100, 400, 400);
}

void draw() {
}
