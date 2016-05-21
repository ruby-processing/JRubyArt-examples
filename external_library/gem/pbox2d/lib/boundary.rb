class Boundary
  include Processing::Proxy
  attr_reader :box2d, :b, :pos, :size, :a
  
  def initialize(b2d, pos, sz, a = 0)
    @box2d, @pos, @size, @a = b2d, pos, sz, a
    # Define the polygon
    sd = PolygonShape.new
    # Figure out the box2d coordinates
    box2d_w = box2d.scale_to_world(size.x / 2)
    box2d_h = box2d.scale_to_world(size.y / 2)
    # We're just a box
    sd.set_as_box(box2d_w, box2d_h)
    # Create the body
    bd = BodyDef.new
    bd.type = BodyType::STATIC
    bd.angle = a
    bd.position.set(box2d.processing_to_world(pos.x, pos.y))
    @b = box2d.create_body(bd)
    # Attached the shape to the body using a Fixture
    b.create_fixture(sd, 1)
  end

  # Draw the boundary, it doesn't move so we don't have to ask the Body for location
  def display
    fill(0)
    stroke(0)
    stroke_weight(1)
    rect_mode(CENTER)
    a = b.get_angle
    push_matrix
    translate(pos.x, pos.y)
    rotate(-a)
    rect(0, 0, size.x,size.y)
    pop_matrix
  end
end
