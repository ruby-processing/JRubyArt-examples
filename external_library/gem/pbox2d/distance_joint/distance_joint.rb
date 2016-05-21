# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Example demonstrating distance joints
# A bridge is formed by connected a series of particles with joints

require 'pbox2d'
require 'forwardable'
require_relative 'boundary'
require_relative 'pair'
require_relative 'particle'
require_relative 'particle_system'

attr_reader :box2d, :boundaries, :system

def setup
  size(640, 360)
sketch_title 'Distance Joint'
  # Initialize box2d physics and create the world
  @box2d = WorldBuilder.build(app: self)
  @system = ParticleSystem.new
  @boundaries = []
  # Add a bunch of fixed boundaries
  boundaries << Boundary.new(width / 4, height - 5, width / 2 - 50, 10)
  boundaries << Boundary.new(3 * width / 4, height - 50, width / 2 - 50, 10)
end

def draw
  background(255)
  system.run
  # Display all the boundaries
  boundaries.each(&:display)
  fill(0)
  text('Click mouse to add connected particles.', 10, 20)
end

def mouse_pressed
  system.add_pair(mouse_x, mouse_y)
end
