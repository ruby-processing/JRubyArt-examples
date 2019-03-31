# Stores and manipulates the path
class Path
  attr_reader :points, :last, :bounds, :cut, :theta, :delta, :speed, :searches

  def initialize(bounds, speed, delta, history)
    @bounds = bounds
    @speed = speed
    @delta = delta
    @theta = 0
    @points = (0..history).map { bounds.centroid.copy }
    @searches = 0
    @last = Vec2D.new(points.first)
  end

  def grow
    @delta = rand(-0.2..0.2) if rand < 0.1
    if !intersecting?
      move
    else
      search
    end
  end

  def move
    @last = points.first
    points.pop
    @theta += delta
    points.unshift last + Vec2D.new(speed * Math.cos(theta), speed * Math.sin(theta))
    @searches = 0
  end

  def search
    @theta += delta
    points[0] = last + Vec2D.new(speed * Math.cos(theta), speed * Math.sin(theta))
    @searches += 1
  end

  def intersecting?
    return true unless bounds.contains?(points.first)

    if searches < 100
      a = Line2D.new(points[0], points[1])
      (3...points.length).each do |i|
        b = Line2D.new(points[i], points[i - 1])
        return true if a.intersecting?(b)
      end
    end
    false
  end
end
