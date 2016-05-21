
# Learning Processing
# Daniel Shiffman
# http://www.learningprocessing.com

# Example 22-2: Polymorphism

# Circle class inherits Processing:Proxy module methods from Shape
# Inherits all instance variables from parent + adding one using the 
# post_initialize hook method. Use of change_color makes initialization of @c
# irrelevant, but without example is spoiled.
require_relative 'shape'

class Circle < Shape
  COLORS = %w(#ff0000 #ffff00 #3333ff #33cc33)
  attr_reader :c, :x, :y, :r

  def post_initialize(args)
    # get color :c or default
    @c = args.fetch(:c, color(rand(255), 100))
  end

  # Call the parent jiggle, but do some more stuff too
  def jiggle
    super
    # The Circle jiggles both size and location.
    @r += rand(-1..1.0)
    @r = constrain(r, 0, 100)
  end

  def display
    ellipse_mode(CENTER)
    fill(c)
    stroke(0)
    ellipse(x, y, r, r)
  end
  
  def run
    jiggle
    display
  end
end
