# Learning Processing
# Daniel Shiffman
# http://www.learningprocessing.com

# Example 22-2: Polymorphism
require_relative 'shape'
# Square class can inherit Processing::Proxy methods from Shape
# Variables are inherited from the parent.
# We could also add variables unique to the Square class if we so desire
# NB: run could be the only visible method
class Square < Shape
  # Inherits constructor from parent
  # Inherits jiggle from parent

  # The square overrides its parent for display.
  def display
    rect_mode(CENTER)
    fill(175)
    stroke(0)
    rect(x, y, r, r)
  end
  
  def run
    jiggle
    display
  end
end
