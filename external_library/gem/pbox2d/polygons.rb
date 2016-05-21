# Basic example of falling rectangles
require 'pbox2d'
require_relative 'lib/custom_shape'
require_relative 'lib/boundary'
require_relative 'lib/shape_system'

attr_reader :box2d, :boundaries, :system

Vect = Struct.new(:x, :y)

def setup
  sketch_title 'Polygons'
  smooth
  @box2d = WorldBuilder.build(app: self, gravity: [0, -20])
  @system = ShapeSystem.new self
  @boundaries = [
    Boundary.new(box2d, Vect.new(width / 4, height - 5), Vect.new(width / 2 - 50, 10)),
    Boundary.new(box2d, Vect.new(3 * width / 4, height - 50), Vect.new(width / 2 - 50, 10)),
    Boundary.new(box2d, Vect.new(width - 5, height / 2), Vect.new(10, height)),
    Boundary.new(box2d, Vect.new(5, height / 2), Vect.new(10, height))
  ]
end

def draw
  background(255)
  # Display all the boundaries
  boundaries.each(&:display)
  # Display all the polygons
  system.run
end

def mouse_pressed
  system << CustomShape.new(box2d, mouse_x, mouse_y)
end

def settings
  size(640, 360)
end
