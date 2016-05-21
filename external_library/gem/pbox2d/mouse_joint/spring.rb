# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
# refactored to avoid suspicious null checking see dummy_spring.rb

# Class to describe the spring joint (displayed as a line)
class Spring
  extend Forwardable
  def_delegators(:@app, :line, :box2d, :stroke, :stroke_weight)
  # This is the box2d object we need to create
  attr_reader :mouse_joint

  def initialize
    @app = $app
  end

  # If it exists we set its target to the mouse location
  def update(x, y)
    # Always convert to world coordinates!
    mouse_world = box2d.processing_to_world(x, y)
    mouse_joint.set_target(mouse_world)
  end

  def display
    # We can get the two anchor points
    v1 = Vec2.new
    mouse_joint.getAnchorA(v1)
    v2 = Vec2.new
    mouse_joint.getAnchorB(v2)
    # Convert them to screen coordinates
    vd1 = box2d.world_to_processing(v1)
    vd2 = box2d.world_to_processing(v2)
    # And just draw a line
    stroke(0)
    stroke_weight(1)
    line(vd1.x, vd1.y, vd2.x, vd2.y)
  end

  # This is the key function where
  # we attach the spring to an x,y location
  # and the Box object's location
  def bind(x, y, box)
    # Define the joint
    md = MouseJointDef.new
    # Body A is just a fake ground body for simplicity
    # (there isn't anything at the mouse)
    md.bodyA = box2d.ground_body
    # Body 2 is the box's boxy
    md.bodyB = box.body
    # Get the mouse location in world coordinates
    mp = box2d.processing_to_world(x, y)
    # And that's the target
    md.target.set(mp)
    # Some stuff about how strong and bouncy the spring should be
    md.maxForce = 1000.0 * box.body.m_mass
    md.frequencyHz = 5.0
    md.dampingRatio = 0.9
    # Make the joint!
    @mouse_joint = box2d.world.create_joint(md)
  end

  def destroy
    # We can get rid of the joint when the mouse is released
    box2d.world.destroy_joint(mouse_joint)
  end
end
