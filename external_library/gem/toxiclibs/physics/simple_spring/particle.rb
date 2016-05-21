require 'forwardable'

# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
# Notice how we are using inheritance here!
# We could have just stored a reference to a VerletParticle2D object
# inside the Particle class, but inheritance is an alternative
class Particle < Physics::VerletParticle2D
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :stroke_weight, :ellipse)
  def initialize(loc)
    super(loc)
    @app = $app
  end

  # All we're doing really is adding a display function to a VerletParticle
  def display
    fill(127)
    stroke(0)
    stroke_weight(2)
    ellipse(x, y, 32, 32)
  end
end
