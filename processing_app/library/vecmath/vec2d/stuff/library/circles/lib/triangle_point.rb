# frozen_string_literal: true
# particle and triangle point
class TPoint
  include Processing::Proxy
  attr_reader :pos, :vel, :accel, :xbound, :ybound

  def initialize(position)
    @pos = position
    @vel = Vec2D.new
    @accel = Vec2D.random
    @xbound = Boundary.new(0, width)
    @ybound = Boundary.new(0, height)
  end

  def direction
    @accel = Vec2D.random * rand if rand > 0.96
  end

  def update
    @vel += accel
    # @vel.set_mag(1.5) { vel.mag > 1.5 }
    @pos += vel
    check_bounds
    direction
  end

  private

  def check_bounds
    if xbound.exclude? pos.x
      @vel.x = 0
      @accel.x *= rand(-0.9..-0.09)
    end
    if ybound.exclude? pos.y
      @vel.y = 0
      @accel.y *= rand(-0.9..-0.09)
    end
  end
end

# we are looking for excluded values
Boundary = Struct.new(:lower, :upper) do
  def exclude?(val)
    true unless (lower...upper).cover? val
  end
end
