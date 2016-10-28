# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Notice how we are using inheritance here!
# We could have just stored a reference to a VerletParticle object
# inside the Particle class, but inheritance is a nice alternative
class Particle < Physics::VerletParticle2D
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :ellipse)
  def initialize(loc)
    super(loc)
    @app = $app
  end

  # All we're doing really is adding a display function to a VerletParticle
  def display
    fill(175)
    stroke(0)
    ellipse(x, y, 16, 16)
  end
end
