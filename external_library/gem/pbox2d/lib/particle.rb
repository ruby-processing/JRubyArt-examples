# Note the particle class change method is use to change color to red
# when two particles collide (no change just hitting boundary)
class Particle
  extend Forwardable
  def_delegators(:@app, :box2d, :begin_shape, :end_shape, :line, :pop_matrix,
                 :ellipse, :translate, :rotate, :stroke, :push_matrix,
                 :fill, :no_fill, :stroke_weight)
  attr_accessor :body
  attr_reader :radius, :col

  def initialize(app, x, y, r)
    @app, @x, @y, @radius = app, x, y, r
    # This function puts the particle in the Box2d world
    make_body(x, y, radius)
    @col = -5_263_441 # grey
    body.setUserData(self)
  end

  # This function removes the particle from the box2d world
  def kill_body
    box2d.destroy_body(body)
  end

  # Change color when hit
  def change
    @col = -65_536 # red
  end

  # Is the particle ready for deletion?
  def done
    # Let's find the screen position of the particle
    pos = box2d.body_coord(body)
    # Is it off the bottom of the screen?
    return false unless pos.y > (box2d.height + radius * 2)
    kill_body
    true
  end

  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.get_angle
    push_matrix
    translate(pos.x, pos.y)
    rotate(a)
    fill(col)
    stroke(0)
    stroke_weight(1)
    ellipse(0, 0, radius * 2, radius * 2)
    # Let's add a line so we can see the rotation
    line(0, 0, radius, 0)
    pop_matrix
  end

  # Here's our function that adds the particle to the Box2D world
  def make_body(x, y, r)
    # Define a body
    bd = BodyDef.new
    # Set its position
    bd.position = box2d.processing_to_world(x, y)
    bd.type = BodyType::DYNAMIC
    @body = box2d.create_body(bd)
    # Make the body's shape a circle
    cs = CircleShape.new
    cs.m_radius = box2d.scale_to_world(r)
    fd = FixtureDef.new
    fd.shape = cs
    # Parameters that affect physics
    fd.density = 1
    fd.friction = 0.01
    fd.restitution = 0.3
    # Attach fixture to body
    body.create_fixture(fd)
    body.set_angular_velocity(rand(-10.0..10))
  end
end
