# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
class Attractor < Physics::VerletParticle2D
  extend Forwardable
  def_delegators(:@app, :fill, :ellipse, :physics, :width)
  attr_accessor :r

  def initialize(loc)
    super(loc)
    @app = $app
    @r = 24
    physics.add_particle(self)
    physics.add_behavior(Physics::AttractionBehavior2D.new(self, width, 0.1))
  end

  def display
    fill(0)
    ellipse(x, y, r * 2, r * 2)
  end
end
