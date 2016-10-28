# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
class Connection < Physics::VerletSpring2D
  extend Forwardable
  def_delegators(:@app, :stroke, :line)
  def initialize(p1, p2, len, strength)
    super(p1, p2, len, strength)
    @app = $app
  end

  def display
    stroke(0)
    line(a.x, a.y, b.x, b.y)
  end
end
