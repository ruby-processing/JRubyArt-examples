# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Example demonstrating revolute joint
require 'pbox2d'
require_relative 'windmill'
require_relative 'particle'
require_relative 'particle_system'

attr_reader :box2d, :windmill, :system

def setup
  size(640,360)
  @box2d = WorldBuilder.build(app: self)
  @windmill = Windmill.new(width / 2, 175)
  @system = ParticleSystem.new
end

# Click the mouse to turn on or off the motor
def mouse_pressed
  windmill.toggle_motor
end

def draw
  background(255)
  system.add_particles(width)
  system.run
  # Draw the windmill
  windmill.display
  status = windmill.motor_on? ? "ON" : "OFF"
  fill(0)
  text(format("Click mouse to toggle motor.\nMotor: %s", status), 10, height - 30)
end
