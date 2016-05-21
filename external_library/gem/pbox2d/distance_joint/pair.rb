# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Series of Particles connected with distance joints
class Pair
  extend Forwardable
  def_delegators(:@app, :box2d, :stroke, :line, :stroke_weight)
  attr_reader :p1, :p2, :len, :joint
  # Chain constructor
  def initialize(x, y)
    @app = $app
    @len = 32
    @p1 = Particle.new(x, y)
    @p2 = Particle.new(x + rand(-1..1.0), y + rand(-1..1.0))
    djd = DistanceJointDef.new
    # Connection between previous particle and this one
    djd.bodyA = p1.body
    djd.bodyB = p2.body
    # Equilibrium length
    djd.length = box2d.scale_to_world(len)
    # These properties affect how springy the joint is
    djd.frequencyHz = 3     # Try a value less than 5 (0 for no elasticity)
    djd.dampingRatio = 0.1  # Ranges between 0 and 1 (1 for no springiness)
    # Make the joint.
    @joint = box2d.world.create_joint(djd)
  end

  def kill_bodies
    box2d.world.destroy_joint(joint)
    @joint = nil
    box2d.destroy_body(p1.body)
    box2d.destroy_body(p2.body)
  end

  # Is the pair ready for deletion?
  def done?
    # Let's find the screen position of the particle
    pos1 = box2d.body_coord(p1.body)
    pos2 = box2d.body_coord(p2.body)
    # Is it off the screen?
    if (0..@app.width).include?(pos1.x) || (0..@app.width).include?(pos2.x)
      if (0..@app.height).include?(pos1.y) || (0..@app.height).include?(pos2.y)
        return false
      end
    end
    kill_bodies
    true
  end

  def display
    pos1 = box2d.body_coord(p1.body)
    pos2 = box2d.body_coord(p2.body)
    stroke(0)
    stroke_weight(2)
    line(pos1.x, pos1.y, pos2.x, pos2.y)
    p1.display
    p2.display
  end
end
