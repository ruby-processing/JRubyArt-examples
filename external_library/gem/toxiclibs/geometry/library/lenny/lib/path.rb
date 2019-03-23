java_import 'toxi.geom.Line2D'

# Stores and manipulates the path
class Path
  attr_reader :path, :last, :bounds, :cut, :theta, :delta, :speed, :searches

  def initialize(bounds, speed, delta, history)
    @bounds = bounds
    @speed = speed
    @delta = delta
    @theta = 0
    @path = (0..history).map { bounds.centroid.copy }
    @searches = 0
    @last = TVec2D.new(path.first)
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
    @last = path.first
    path.pop
    @theta += delta
    path.unshift last.add(TVec2D.new(speed, theta).cartesian)
    @searches = 0
  end

  def search
    @theta += delta
    path[0] = last.add(TVec2D.new(speed, theta).cartesian)
    @searches += 1
  end

  def render(gfx)
    gfx.begin_shape
    path.map { |vec| gfx.curve_vertex(vec.x, vec.y) }
    gfx.end_shape
  end

  def intersecting?
    return true unless bounds.contains_point(path.first)

    if searches < 100
      a = Line2D.new(path[0], path[1])
      (3...path.length).each do |i|
        b = Line2D.new(path[i], path[i - 1])
        @cut = a.intersect_line(b)
        return true if cut.getType == Line2D::LineIntersection::Type::INTERSECTING
      end
    end
    false
  end
end
