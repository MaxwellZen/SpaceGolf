public class Star {
	Point pos, vel;
	float theta, rot;
	PImage img;

	// constructor
	Star(float px, float py, float ang) {
		pos = new Point(px,py);
		vel = new Point(cos(ang), sin(ang)).scale(240);
		theta = (float)Math.random()*TWO_PI;
		rot = ((float)Math.random() + 1) * 2;
		if (Math.random() < 0.5) rot = -rot;
		img = loadImage("Pictures/star.png");
	}

	void updatePos() {
		if (pos.y < 600) {
			pos = pos.plus(vel.scale(dt));
			theta += rot * dt;
			vel.y += 150 * dt;
		}
	}

	void draw() {
		if (pos.y < 600) {
			pushMatrix();
			translate(pos.x, pos.y);
			rotate(theta);
			image(img, -30, -30, 60, 60);
			popMatrix();
		}
	}

}
