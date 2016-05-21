# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Notice how we are using inheritance here!
# We could have just stored a reference to a VerletPhysics2D object
# inside the Particle class, but inheritance is a nice alternative

class Particle < Physics::VerletParticle2D
  include Processing::Proxy
  attr_accessor :radius  # Adding a radius for each particle

  def initialize(x, y)
    super(x, y)
    @radius = 4
  end

  # All we're doing really is adding a display function to a VerletParticle2D
  def display
    fill(127)
    stroke(0)
    stroke_weight(2)
    ellipse(x, y, radius * 2, radius * 2)
  end
end
