# Learning Processing
# Daniel Shiffman
# http://www.learningprocessing.com

# Example 22-2: Polymorphism
# class Shape does not require Processing::Proxy but can pass it on to
# the inheriting classes Square and Circle (NB: change to using run)
class Shape
  include Processing::Proxy
  attr_reader :x, :y, :r

  def initialize(x:, y:, r:, **opts)
    @x = x
    @y = y
    @r = r
    post_initialize(opts)
  end

  def jiggle
    @x += rand(-1..1.0)
    @y += rand(-1..1.0)
  end

  def post_initialize(_args)
    'not implemented'
  end

  # A generic shape does not really know how to be displayed.
  # This will be overridden in the child classes.
  def display
    'not implemented'
  end
  
  def run
    'not implemented'
  end
end
