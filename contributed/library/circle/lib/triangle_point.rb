# frozen_string_literal: true
# particle and triangle point
class TPoint
  include Processing::Proxy
  attr_reader :pos, :vel, :accel, :xbound, :ybound
  # attr_reader :width, :height # uncomment for testing

  def initialize(position)
    @pos = position
    @vel = Vec2D.new
    @accel = Vec2D.random
    @xbound = Boundary.new(0, width)
    @ybound = Boundary.new(0, height)
  end

  def direction(acc)
    # direction of the acceleration is defined by the new angle
    @accel = acc
    # magnitude of the acceleration is proportional to the angle between
    # acceleration and velocity
    dif = acc.angle_between(vel)
    dif = map1d(dif, 0..PI, 0.1..0.001)
    @accel = acc * dif
  end

  def update
    @vel += accel
    @vel.set_mag(1.5) { vel.mag > 1.5 }
    @pos += vel
    check_bounds
  end

  private

  def check_bounds
    @vel.x *= -1 if xbound.exclude? pos.x
    @vel.y *= -1 if ybound.exclude? pos.y
  end
end

# we are looking for excluded values
Boundary = Struct.new(:lower, :upper) do
  def exclude?(val)
    true unless (lower...upper).cover? val
  end
end
