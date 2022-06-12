public class Planet {
	Point pos;
	int num;
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
		setcolor(n);
	}

	void setcolor(int n) {
		num = n;
		r = radius[n-1];

		String name = "Pictures/planet" + String.valueOf(num) + ".png";
		img = loadImage(name);
		img.resize(r * 2, r * 2);
	}

	void draw() {
        image(img, pos.x - r, pos.y - r);
	}

	// calculate gravitational field at another point
	Point field(Point loc) {
		// center case
		if (pos.distsq(loc)==0) {
			return new Point(0,0);
		}
		// use GM/R^2 formula
		float mag = G * mass[num-1] / pos.distsq(loc);
		Point ans = pos.minus(loc).normalize().scale(mag);
		return ans;
	}

	// apply force on ship based on gravitational field
	void applyForce(Ship s) {
		Point f = field(s.pos);
		s.vel = s.vel.plus(f.scale(dt));
	}

	boolean inside(int x, int y) {
		return sq(x - pos.x) + sq(y - pos.y) <= sq(r);
	}

	void move(float x, float y) {
		pos = new Point(x, y);
	}

}
