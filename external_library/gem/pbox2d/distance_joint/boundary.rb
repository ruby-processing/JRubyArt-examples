# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

CENTER ||= Java::ProcessingCore::PConstants::CENTER

# A fixed boundary class
class Boundary
  extend Forwardable
  def_delegators(:@app, :box2d, :rect_mode, :rect, :fill, :stroke)
  # A boundary is a simple rectangle with x, y, width, and height
  attr_reader :x, :y, :w, :h

  def initialize(x, y, w, h)
    @x, @y, @w, @h = x, y, w, h
    @app = $app
    # Define the polygon
    sd = PolygonShape.new
    # Figure out the box2d coordinates
    box2dw = box2d.scale_to_world(w / 2)
    box2dh = box2d.scale_to_world(h / 2)
    # We're just a box
    sd.setAsBox(box2dw, box2dh)
    # Create the body
    bd = BodyDef.new
    bd.type = BodyType::STATIC
    bd.position.set(box2d.processing_to_world(x, y))
    b = box2d.createBody(bd)
    # Attached the shape to the body using a Fixture
    b.create_fixture(sd, 1)
  end

  # Draw the boundary, if it were at an angle we'd have to do something fancier
  def display
    fill(0)
    stroke(0)
    rect_mode(CENTER)
    rect(x, y, w, h)
  end
end
