public class Planet {
	Point pos;
	int c;

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

	void draw() {
		fill(colors[c]);
		stroke(0);
		circle(pos.x, pos.y, 2*radius[c]);
	}

	Point field(Point loc) {
		float mag = G * mass[c] / pos.distsq(loc);
		Point ans = pos.minus(loc).normalize().scale(mag);
		return ans;
	}

	void applyForce(Ship s) {
		Point f = field(s.pos);
		s.vel = s.vel.plus(f.scale(dt));
	}

}
