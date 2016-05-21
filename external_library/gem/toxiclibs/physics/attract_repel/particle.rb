# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# class Spore extends the class "VerletParticle2D"
class Particle < Physics::VerletParticle2D
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :stroke_weight, :ellipse, :physics)
  attr_reader :r

  def initialize(loc)
    super(loc)
    @app = $app
    @r = 8
    physics.add_particle(self)
    physics.add_behavior(Physics::AttractionBehavior2D.new(self, r * 4, -1))
  end

  def display
    fill 127
    stroke 0
    stroke_weight 2
    ellipse x, y, r * 2, r * 2
  end
end
