# Demonstrates possible syntax for creating a custom array of objects.

UNIT = 40
attr_reader :custom_array

def setup
  sketch_title 'Custom Array'
  wide_count = width / UNIT
  height_count = height / UNIT
  @custom_array = CustomArray.new
  height_count.times do |i|
    wide_count.times do |j|
      custom_array.add_object(j * UNIT, i * UNIT, UNIT / 2, UNIT / 2, rand(0.05..0.8))
    end
  end
  no_stroke
end

def draw
  custom_array.update
  custom_array.draw
end

def settings
  size 640, 360, FX2D
end

# The Particle object

Particle = Struct.new(:x, :y, :mx, :my, :size, :speed, :xdir, :ydir)

require 'forwardable'

# The custom Array created using Forwardable
# Processing::Proxy gives access to PApplet methods
class CustomArray 
  extend Forwardable
  def_delegators(:@objs, :each, :<<)
  include Enumerable, Processing::Proxy
  
  def initialize
    @objs = []
  end
  
  def add_object(mx, my, x, y, speed)
    self << Particle.new(x.to_i, y.to_i, mx, my, UNIT, speed, 1, 1)
  end
  
  def update
    each do |obj|
      update_x obj
      next unless obj.y >= UNIT || obj.x <= 0
      obj.ydir *= -1
      obj.y += obj.ydir
    end
  end
  
  def update_x(obj)
    obj.x += obj.speed * obj.xdir
    return if (0..UNIT).cover? obj.x
    obj.xdir *= -1
    obj.x += obj.xdir
    obj.y += obj.ydir
  end
  
  def draw
    background(0)
    fill(255)
    each do |obj|
      ellipse(obj.mx + obj.x, obj.my + obj.y, 6, 6)
    end
  end
end

