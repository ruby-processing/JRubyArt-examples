# Use to detect whether instances of line intersect
class Line2D
  attr_reader :a, :b
  def initialize(a, b)
    @a = a
    @b = b
  end

  def intersecting?(line)
    denom = (line.b.y - line.a.y) * (b.x - a.x) - (line.b.x - line.a.x) * (b.y - a.y)
    na = (line.b.x - line.a.x) * (a.y - line.a.y) - (line.b.y - line.a.y) * (a.x - line.a.x)
    nb = (b.x - a.x) * (a.y - line.a.y) - (b.y - a.y) * (a.x - line.a.x)
    return false if denom.zero?

    ua = na / denom
    ub = nb / denom
    (ua >= 0.0 && ua <= 1.0 && ub >= 0.0 && ub <= 1.0)
  end
end
