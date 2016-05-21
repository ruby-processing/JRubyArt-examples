# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
require 'forwardable'
require_relative 'box'

# Class to describe a fixed spinning object
class Windmill
  extend Forwardable
  def_delegators(:@app, :ellipse, :no_stroke, :box2d, :fill)
  # Our object is two boxes and one joint
  # Consider making the fixed box much smaller and not drawing it
  attr_reader :joint, :box1, :box2
  
  def initialize(x, y)
    @app = $app
    # Initialize locations of two boxes
    @box1 = Box.new(x, y - 20, 120, 10, false)
    @box2 = Box.new(x, y, 10, 40, true)
    # Define joint as between two bodies
    rjd = RevoluteJointDef.new
    # NB: using java_send to access the unreachable 'initialize' method
    rjd.java_send :initialize, [Body, Body, Vec2], box1.body, box2.body, box1.body.getWorldCenter
    # Turning on a motor (optional)
    rjd.motorSpeed = Math::PI * 2       # how fast?
    rjd.maxMotorTorque = 1000.0 # how powerful?
    rjd.enableMotor = false      # is it on?
    # There are many other properties you can set for a Revolute joint
    # For example, you can limit its angle between a minimum and a maximum
    # See box2d manual for more    
    # Create the joint
    @joint = box2d.world.createJoint(rjd)
  end
  
  # Turn the motor on or off
  def toggle_motor
    joint.enableMotor(!joint.isMotorEnabled)
  end
  
  def motor_on?
    joint.isMotorEnabled
  end  
  
  def display
    box2.display
    box1.display
    # Draw anchor just for debug
    anchor = box2d.vector_to_processing(box1.body.getWorldCenter)
    fill(0)
    no_stroke
    ellipse(anchor.x, anchor.y, 8, 8)
  end
end
