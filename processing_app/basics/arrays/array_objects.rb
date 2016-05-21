# Demonstrates the syntax for creating an array of custom objects.

UNIT = 40
attr_reader :mods

def setup
  sketch_title 'Array of Objects'
  wide_count = width / UNIT
  height_count = height / UNIT
  @mods = []
  wide_count.times do |i|
    height_count.times do |j|
      mods << CustomObject.new(j * UNIT, i * UNIT, UNIT / 2, UNIT / 2, rand(0.05..0.8))
    end
  end
  no_stroke
end

def draw
  background 0
  mods.each(&:run)
end

def settings
  size 640, 360, FX2D
end

module Runnable
  def run
    update
    draw
  end
end

# the custom object
class CustomObject
  include Processing::Proxy, Runnable
  attr_reader :x, :y, :mx, :my, :size
  def initialize(mx, my, x, y, speed)
    @mx, @my      = my, mx # This is backwards to match original example.
    @x, @y        = x.to_i, y.to_i
    @xdir, @ydir  = 1, 1
    @speed        = speed
    @size         = UNIT
  end

  def update
    @x += @speed * @xdir
    unless (0..size).cover? x
      @xdir *= -1
      @x += @xdir
      @y += @ydir
    end
    return unless @y >= @size || x <= 0
    @ydir *= -1
    @y += @ydir
  end

  def draw
    fill(255)
    ellipse(mx + x, my + y, 6, 6)
  end
end
