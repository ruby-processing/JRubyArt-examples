class Vec2D
  def left
    self.x, self.y = -y, x
    self
  end
end

class Circumcircle
  attr_reader :a, :b, :c

  def initialize(a, b, c)
    @a, @b, @c = a, b, c
  end

  def center
    ab = b - a
    ab2 = ab.dot(ab)
    ac = c - a
    ac.left
    ac2 = ac.dot(ac)
    d = 2 * ab.dot(ac)
    ab.left
    ab *= -1
    ab *= ac2
    ac *= ab2
    ab += ac
    ab /= d
    a + ab
  end

  def radius
    center.dist(c)
  end

  def collinear?
    ((a - b) ^ (b - c)).zero?
  end
end
