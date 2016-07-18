# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# A fixed boundary class (now incorporates angle)
class Boundary
  extend Forwardable
  def_delegators(:@app, :fill, :no_fill, :stroke, :rect, :rect_mode, :box2d,
                 :stroke_weight, :translate, :push_matrix, :pop_matrix, :rotate)
  # A boundary is a simple rectangle with x,y,width,and height
  attr_reader :x, :y, :w, :h, :b

  def initialize(x, y, w, h, a)
    @x, @y, @w, @h, @a = x, y, w, h, a
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
    bd.angle = a
    bd.position.set(box2d.processing_to_world(x, y))
    @b = box2d.create_body(bd)
    # Attached the shape to the body using a Fixture
    b.create_fixture(sd, 1)
  end

  # Draw the boundary, if it were at an angle we'd have to do something fancier
  def display
    no_fill
    stroke(127)
    fill(127)
    stroke_weight(1)
    rect_mode(Java::ProcessingCore::PConstants::CENTER)
    a = b.get_angle
    push_matrix
    translate(x, y)
    rotate(-a)
    rect(0, 0, w, h)
    pop_matrix
  end
end
