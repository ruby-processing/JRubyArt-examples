require 'forwardable'

# wrap the run method
module Runnable
  def run
    reject!(&:dead?)
    each(&:display)
  end
end

# Using forwardable to include enumerable methods we use
# Include runnable for a nice run abstraction
class RainDrops
  include Enumerable, Runnable
  extend Forwardable

  def_delegators(:@drops, :<<, :each, :reject!, :size)

  attr_reader :drops, :width, :height

  def initialize(width, height)
    @drops = []
    @width = width
    @height = height
  end

  def fill_up(weight)
    drops << Drop.new(rand(width), rand(height / 2) - height / 2, weight)
  end
end

# Encapsulates drop behaviour, and include Proxy to access PApplet methods
class Drop
  include Processing::Proxy
  attr_reader :weight, :x, :y

  def initialize(x, y, weight = nil)
    @weight = weight || 10
    @x, @y = x, y
  end

  def render
    fill(100, 100, 200)
    no_stroke
    bezier(
      x,
      y,
      x - (weight / 2),
      y + weight,
      x + (weight / 2),
      y + weight,
      x,
      y
    )
  end

  def dead?
    @y > height
  end

  def display
    @y = y + weight
    @x = x - rand(-5..5)
    render
  end
end
