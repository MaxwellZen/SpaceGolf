public class Planet {
	Point pos;
	int num;
	// int c;
	int r;
	PImage img;

	// constructors
	// Planet() {
	// 	pos = new Point(0, 0);
	// 	c = (int)(Math.random()*3);
	// }
	//
	// Planet(float x, float y) {
	// 	pos = new Point(x, y);
	// 	c = (int)(Math.random()*3);
	// }

	Planet(float x, float y, int n) {
		pos = new Point(x, y);
		num = n;
		r = radius[n];
	}

	// draw planet as a circle
	// void draw() {
	// 	fill(colors[]);
	// 	stroke(0);
	// 	circle(pos.x, pos.y, 2*radius[c]);
	// }
	void draw() {
		String name = "";
        if (num == 0) name = "Pictures/zero.png";
        if (num == 1) name = "Pictures/one.png";
        if (num == 2) name = "Pictures/two.png";
        if (num == 3) name = "Pictures/three.png";
        if (num == 4) name = "Pictures/four.png";
        if (num == 5) name = "Pictures/five.png";
        if (num == 6) name = "Pictures/six.png";
        if (num == 7) name = "Pictures/seven.png";

		img = loadImage(name);
        img.resize(r * 2, r * 2);
        image(img, pos.x - r, pos.y - r);
	}

	// calculate gravitational field at another point
	Point field(Point loc) {
		// center case
		if (pos.distsq(loc)==0) {
			return new Point(0,0);
		}
		// use GM/R^2 formula
		float mag = G * mass[num] / pos.distsq(loc);
		Point ans = pos.minus(loc).normalize().scale(mag);
		return ans;
	}

	// apply force on ship based on gravitational field
	void applyForce(Ship s) {
		Point f = field(s.pos);
		s.vel = s.vel.plus(f.scale(dt));
	}

	boolean inside(int x, int y) {
		if (sq(x - pos.x) + sq(y - pos.y) <= sq(r)) return true;
		else return false;
	}

	void move(float x, float y) {
		pos = new Point(x, y);
	}

}
