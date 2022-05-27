public class Planet {
	Point pos;
	int c;

	// constructors
	Planet() {
		pos = new Point(0, 0);
		c = (int)(Math.random()*3);
	}

	Planet(float x, float y) {
		pos = new Point(x, y);
		c = (int)(Math.random()*3);
	}

	Planet(float x, float y, int C) {
		pos = new Point(x, y);
		c = C;
	}

	// draw planet as a circle
	void draw() {
		fill(colors[c]);
		stroke(0);
		circle(pos.x, pos.y, 2*radius[c]);
	}

	// calculate gravitational field at another point
	Point field(Point loc) {
		// center case
		if (pos.distsq(loc)==0) {
			return new Point(0,0);
		}
		// use GM/R^2 formula
		float mag = G * mass[c] / pos.distsq(loc);
		Point ans = pos.minus(loc).normalize().scale(mag);
		return ans;
	}

	// apply force on ship based on gravitational field
	void applyForce(Ship s) {
		Point f = field(s.pos);
		s.vel = s.vel.plus(f.scale(dt));
	}

	boolean inside(int x, int y) {
		if ((x - pos.x) * (x - pos.x) + (y - pos.y) * (y - pos.y) <= radius[c] * radius[c]) return true;
		else return false;
	}

	void move(int x, int y) {
		pos = new point(x, y);
	}

}
