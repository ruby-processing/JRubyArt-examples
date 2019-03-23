# Duck typing Boundary
class CircularBoundary
  attr_reader :circle

  def initialize(circle)
    @circle = circle
  end

  def contains_point(vec)
    circle.containsPoint(vec)
  end

  def centroid
    circle # Circle can DuckType as Vec2D
  end
end

# Duck typing Boundary
class RectBoundary
  attr_reader :rectangle

  def initialize(rectangle)
    @rectangle = rectangle
  end

  def contains_point(vec)
    rectangle.containsPoint(vec)
  end

  def centroid
    rectangle.getCentroid
  end
end
