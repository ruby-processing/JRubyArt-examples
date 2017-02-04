# frozen_string_literal: true
# Chain link end as a ball
class VerletBall
  include Processing::Proxy
  attr_reader :pos, :pos_old, :push, :radius, :x_bound, :y_bound

  def initialize(pos, push, radius)
    @pos = pos
    @push = push
    @radius = radius
    @pos_old = Vec2D.new(pos.x, pos.y)
    # start motion
    @pos += push
    @x_bound = Boundary.new(radius, width - radius)
    @y_bound = Boundary.new(radius, height - radius)
  end

  def run
    verlet
    render
    bounds_collision
  end

  def adjust(vec)
    @pos += vec
  end

  private

  def verlet
    pos_temp = pos.copy
    @pos += (pos - pos_old)
    @pos_old = pos_temp
  end

  def render
    ellipse(pos.x, pos.y, radius, radius)
  end

  def bounds_collision
    if x_bound.exclude? pos.x
      pos_old.x = constrain pos.x, x_bound.lower, x_bound.upper
      pos.x = (pos.x <= radius)? pos_old.x + push.x : pos_old.x - push.x
    end
    return unless y_bound.exclude? pos.y
    pos_old.y = constrain pos.y, y_bound.lower, y_bound.upper
    pos.y = (pos.y <= radius)? pos_old.y + push.y : pos_old.y - push.y
  end
end

# We can easily create and test bounds in ruby
Boundary = Struct.new(:lower, :upper) do
  def exclude? val
    true unless (lower..upper).cover? val
  end
end
