# Learning Processing
# Daniel Shiffman
# http://www.learningprocessing.com

# Example 22-2: Polymorphism
require_relative 'shape'
# Circle class inherits Processing:Proxy module methods from Shape
# Inherits all instance variables from parent + adding one using the 
# post_initialize hook method. Use of change_color makes initilization of @c
# irrelevant, but without example is spoiled.
class Circle < Shape  
  COLORS = %w(#ff0000 #ffff00 #3333ff #33cc33)
  attr_reader :c, :x, :y, :r
  
  def initialize(x:, y:, r:)
    super
  end

  def post_initialize(args)
    @c = args[:c]          # Also deal with this new instance variable
  end

  # Call the parent jiggle, but do some more stuff too
  def jiggle
    super
    # The Circle jiggles both size and location.
    @r += rand(-1..1.0)
    @r = constrain(r, 0, 100)
  end

  # The change_color function is unique to the Circle class.
  # @HACK color(COLORS.sample) produces solid color we can add transparency
  # for these colors (all negative int)
  def change_color
    @c = color(COLORS.sample) + (100<<24) 
  end

  def display
    ellipse_mode(CENTER)
    fill(c)
    stroke(0)
    ellipse(x, y, r, r)
  end
  
  def run
    jiggle
    change_color
    display
  end
end
