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

	// draw by transforming image in place and drawing image
	void draw() {
		pushMatrix();
		translate(pos.x, pos.y);
		rotate(PI/2 + atan2(vel.y, vel.x));
		image(ship, -18, -30, 36, 60);
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
	}

}
