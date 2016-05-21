# encoding: UTF-8

# module encapsulating run
module Runner
  def run
    move
    render
    bounds_collision
  end
end

# Euler Ball Class, we include Processing::Proxy module to access PApplet methods
class EulerBall
  include Processing::Proxy, Runner
  attr_reader :pos, :spd, :radius, :bounds_x, :bounds_y

  def initialize(position:, speed:, radius:)
    @pos = position
    @spd = speed
    @radius = radius
    @bounds_x = Bounds.new(lower: radius, upper: width - radius)
    @bounds_y = Bounds.new(lower: radius, upper: height - radius)
  end

  def move
    @pos += spd
  end

  def render
    ellipse(pos.x, pos.y, radius * 2, radius * 2)
  end

  def bounds_collision
    pos.x = bounds_x.position pos.x
    spd.x *= -1 unless bounds_x.inside
    pos.y = bounds_y.position pos.y
    spd.y *= -1 unless bounds_y.inside
  end
end

# Convenient boundary class, we only include MathTool module for constrain
class Bounds
  include Processing::MathTool
  attr_reader :low, :high, :inside
  def initialize(lower:, upper:)
    @low = lower
    @high = upper
    @inside = true
  end

  # Returns the current position or the limit, sets the `inside` flag
  def position(val)
    @inside = (low..high).cover? val
    constrain(val, low, high)
  end
end
