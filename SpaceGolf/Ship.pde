public class Ship {
	Point pos, vel;
	float mass;

	// constructors
	Ship() {
		pos = new Point(0,0);
		vel = new Point(0,0);
		mass = 1;
	}

	Ship(float px, float py, float vx, float vy, float m) {
		pos = new Point(px,py);
		vel = new Point(vx,vy);
		mass = m;
	}

	Ship(Ship other) {
		pos = new Point(other.pos.x, other.pos.y);
		vel = new Point(other.vel.x, other.vel.y);
		mass = other.mass;
	}

	// draw by transforming image in place and drawing image
	void draw() {
		pushMatrix();
		translate(pos.x, pos.y);
		rotate(PI/2 + atan2(vel.y, vel.x));
		image(shipimg, -18, -30, 36, 60);
		// stroke(255);
		// line(-18, 0, 0, 36);
		// line(0, 36, 18, 0);
		// line(18, 0, 0, -36);
		// line(0, -36, -18, 0);
		popMatrix();
	}

	// draw ghost as a short line
	void drawghost() {
		stroke(255);
		Point p1 = pos.plus(vel.normalize().scale(5));
		Point p2 = pos.minus(vel.normalize().scale(5));
		line(p1.x, p1.y, p2.x, p2.y);
	}

	// update position from velocity
	void updatePos() {
		pos = pos.plus(vel.scale(dt));

		for (Planet p : planets) {
			if (pos.dist(p.pos) < p.r + 20) {
				pos = pos.minus(vel.scale(dt));
				collide(p);
			}
		}
	}

	void collide(Planet p) {
		Point temp = new Point(pos.x - p.pos.x, pos.y - p.pos.y);
		vel = vel.reflect(temp);
	}

}
