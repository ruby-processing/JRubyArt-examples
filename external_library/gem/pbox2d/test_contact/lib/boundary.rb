require 'forwardable'

CENTER ||= Java::ProcessingCore::PConstants::CENTER
# The boundary class is used to create a floor in this
# sketch. Note it does not have a change method
class Boundary
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :rect, :rect_mode, :box2d)
  attr_reader :x, :y, :w, :h, :b
  def initialize(app, x, y, w, h)
    @app, @x, @y, @w, @h = app, x, y, w, h
    sd = PolygonShape.new
    box2d_w = box2d.scale_to_world(w / 2)
    box2d_h = box2d.scale_to_world(h / 2)
    sd.set_as_box(box2d_w, box2d_h)
    # Create the body
    bd = BodyDef.new
    bd.type = BodyType::STATIC
    bd.position.set(box2d.processing_to_world(x, y))
    @b = box2d.create_body(bd)
    # Attached the shape to the body using a Fixture
    b.create_fixture(sd, 1)
    b.set_user_data(self)
  end

  # Draw the boundary, if it were at an angle we'd have to do something fancier
  def display
    fill(0)
    stroke(0)
    rect_mode(CENTER)
    rect(x, y, w, h)
  end
end
