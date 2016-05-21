# A class to describe a Polygon (with a PShape)

class Polygon
  include Processing::Proxy
  # The PShape object
  attr_reader :s, :x, :y, :speed, :height

  def initialize(shape:, max_x:, max_y:)
    @x = rand(0..max_x)
    @y = rand(-500..-100)
    @s = shape
    @speed = rand(2..6)
    @height = max_y
  end
  
  # Simple motion
  def move
    @y +=speed
    @y = -100 if (y > height + 100)
  end
  
  # Draw the object
  def display
    push_matrix
    translate(x, y)
    shape(s)
    pop_matrix
  end
  
  def run
    display
    move
  end
end
