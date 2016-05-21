# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
# Force directed graph
# Heavily based on: http:#code.google.com/p/fidgen/
# Notice how we are using inheritance here!
# We could have just stored a reference to a VerletParticle object
# inside the Node class, but inheritance is a nice alternative
class Node < Physics::VerletParticle2D
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :stroke_weight, :ellipse)

  def initialize(pos)
    super(pos)
    @app = $app
  end

  # All we're doing really is adding a display function to a VerletParticle
  def display
    fill(50, 200, 200, 150)
    stroke(50, 200, 200)
    stroke_weight(2)
    ellipse(x, y, 16, 16)
  end
end
