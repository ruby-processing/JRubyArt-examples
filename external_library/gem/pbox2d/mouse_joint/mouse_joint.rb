# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Basic example of controlling an object with the mouse (by attaching a spring)

require 'pbox2d'
require_relative 'box'
require_relative 'boundary'
require_relative 'spring'
require_relative 'dummy_spring'
require 'forwardable'

# A reference to our box2d world
attr_reader :box2d, :boundaries, :box, :spring

def setup
  size(640, 360)
  # Initialize box2d physics and create the world
  @box2d = Box2D.new self
  box2d.create_world
  # Make the box
  @box = Box.new(width / 2, height / 2)
  # Make a dummy spring
  @spring = DummySpring.new
  # Add a bunch of fixed boundaries
  @boundaries = []
  boundaries << Boundary.new(width / 2, height - 5, width, 10, 0)
  boundaries << Boundary.new(width / 2, 5, width, 10, 0)
  boundaries << Boundary.new(width - 5, height / 2, 10, height, 0)
  boundaries << Boundary.new(5, height / 2, 10, height, 0)
end

# When the mouse is released we're done with the spring
def mouse_released
  spring.destroy
  @spring = DummySpring.new
end

# When the mouse is pressed we. . .
def mouse_pressed
  # Check to see if the mouse was clicked on the box and if so create
  # a real spring and bind the mouse location to the box with a spring
  @spring = spring.bind(mouse_x, mouse_y, box) if box.contains(mouse_x, mouse_y)
end

def draw
  background(255)
  # Always alert the spring to the new mouse location
  spring.update(mouse_x, mouse_y)
  # Draw the boundaries
  boundaries.each(&:display)
  # Draw the box
  box.display
  # Draw the spring (it only appears when active)
  spring.display
end
