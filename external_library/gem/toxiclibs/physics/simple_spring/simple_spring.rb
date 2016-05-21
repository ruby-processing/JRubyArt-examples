# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Simple Toxiclibs Spring requires 'toxiclibs gem'

require 'toxiclibs'
require_relative 'particle'

attr_reader :physics, :p1, :p2

def setup
  sketch_title 'Simple Spring'
  # Initialize the physics
  @physics = Physics::VerletPhysics2D.new
  physics.addBehavior(Physics::GravityBehavior2D.new(TVec2D.new(0, 0.5)))
  # Set the world's bounding box
  physics.setWorldBounds(Toxi::Rect.new(0, 0, width, height))
  # Make two particles
  @p1 = Particle.new(TVec2D.new(width / 2, 20))
  @p2 = Particle.new(TVec2D.new(width / 2 + 160, 20))
  # Lock one in place
  p1.lock
  # Make a spring connecting both Particles
  spring = Physics::VerletSpring2D.new(p1, p2, 160, 0.01)
  # Anything we make, we have to add into the physics world
  physics.addParticle(p1)
  physics.addParticle(p2)
  physics.addSpring(spring)
end

def draw
  # Update the physics world
  physics.update
  background(255)
  # Draw a line between the particles
  stroke(0)
  stroke_weight(2)
  line(p1.x, p1.y, p2.x, p2.y)
  # Display the particles
  p1.display
  p2.display
  # Move the second one according to the mouse
  return unless mouse_pressed?
  p2.lock
  p2.set_x mouse_x
  p2.set_y mouse_y
  p2.unlock
end

def settings
  size(640, 360)
end

