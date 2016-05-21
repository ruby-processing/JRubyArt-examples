class CustomShape
  include Processing::Proxy
  # We need to keep track of a Body and a width and height
  attr_reader :body, :box2d

  # Constructor
  def initialize(b2d, x, y)
    # Add the box to the box2d world
    @box2d = b2d
    make_body(Vec2.new(x, y))
  end

  # This function removes the particle from the box2d world
  def kill_body!
    box2d.destroy_body(body)
  end

  # Is the particle ready for deletion?
  def done
    # Let's find the screen position of the particle
    pos = box2d.body_coord(body)
    # Is it off the bottom of the screen?
    return false unless pos.y > box2d.height
    kill_body!
    true
  end

  # Drawing the box
  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.get_angle
    f = body.get_fixture_list
    ps = f.get_shape
    rect_mode(CENTER)
    push_matrix
    translate(pos.x, pos.y)
    rotate(-a)
    fill(175)
    stroke(0)
    begin_shape
    # For every vertex, convert to pixel vector
    ps.get_vertex_count.times do |i|
      v = box2d.vector_to_processing(ps.get_vertex(i))
      vertex(v.x, v.y)
    end
    end_shape(CLOSE)
    pop_matrix
  end

  # This function adds the rectangle to the box2d world
  def make_body(center)
    # Define a polygon (this is what we use for a rectangle)
    sd = PolygonShape.new
    vertices = []
    vertices << box2d.vector_to_world(Vec2.new(-15, 25))
    vertices << box2d.vector_to_world(Vec2.new(15, 0))
    vertices << box2d.vector_to_world(Vec2.new(20, -15))
    vertices << box2d.vector_to_world(Vec2.new(-10, -10))
    sd.set(vertices.to_java(Java::OrgJbox2dCommon::Vec2), vertices.length)
    # Define the body and make it from the shape
    bd = BodyDef.new
    bd.type = BodyType::DYNAMIC
    bd.position.set(box2d.processing_to_world(center))
    @body = box2d.create_body(bd)
    body.create_fixture(sd, 1.0)
    # Give it some initial random velocity
    body.set_linear_velocity(Vec2.new(rand(-5.0..5), rand(2.0..5)))
    body.set_angular_velocity(rand(-5.0..5))
  end
end


