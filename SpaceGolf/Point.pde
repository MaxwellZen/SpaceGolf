public class Point {

  float x, y;

  public Point() {
    this.x=0;
    this.y=0;
  }

  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public String toString() {
    return "(" + x + ", " + y + ")";
  }

  public float distsq(Point other) {
    return sq(x-other.x) + sq(y-other.y);
  }

  public float dist(Point other) {
    return sqrt(distsq(other));
  }

  public float dot(Point other) {
    return this.x*other.x + this.y*other.y;
  }

  public float cross(Point other) {
    return this.y*other.x - this.x*other.y;
  }

  // 1 if a is clockwise to b relative to this, 0 if a b and this are collinear, -1 otherwise
  public float orientation(Point a, Point b) {
    a=a.minus(this);
    b=b.minus(this);
    float c = a.cross(b);
    if (abs(c)<0.01) return 0;
    if (c>0) return 1;
    return -1;
  }

  public Point plus(Point other) {
    return new Point(this.x+other.x, this.y+other.y);
  }

  public Point minus(Point other) {
    return new Point(this.x-other.x, this.y-other.y);
  }

  public Point scale(float factor) {
    return new Point(this.x*factor, this.y*factor);
  }

  public Point normalize() {
    float invsqrt = 1 / sqrt(sq(x)+sq(y));
    return new Point(this.x*invsqrt, this.y*invsqrt);
  }

  // projection, opposite
  public Point[] components(Point other) {
    Point[] ans = new Point[2];
    Point normalized = other.normalize();
    ans[0]=normalized.scale(dot(normalized));
    ans[1]=minus(ans[0]);
    return ans;
  }

  public Point reflect(Point other) {
    Point normalized = other.normalize();
    return minus(normalized.scale(2 * dot(normalized)));
  }

  public Point bounce (Point other) {
    return reflect(new Point(-other.y, other.x));
  }

  public Point closest(Point p1, Point p2) {
    Point p0 = this.minus(p1), p2norm = p2.minus(p1).normalize();
    Point close = p2norm.scale(p0.dot(p2norm));
    close = close.plus(p1);
    if (close.x < min(p1.x, p2.x) || close.x > max(p1.x, p2.x) || close.y < min(p1.y, p2.y) || close.y > max(p1.y, p2.y)) {
      if (distsq(p1)<distsq(p2)) return p1;
      return p2;
    }
    return close;
  }

}
