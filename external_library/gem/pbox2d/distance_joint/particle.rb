# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# A circular particle
class Particle
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :stroke_weight, :box2d, :height, :line,
                 :push_matrix, :pop_matrix, :ellipse, :rotate, :translate)
  # We need to keep track of a Body and a radius
  attr_reader :body, :r

  def initialize(x, y)
    @r = 8
    @app = $app
    # Define a body
    bd = BodyDef.new
    # Set its position
    bd.position = box2d.processing_to_world(x, y)
    bd.type = BodyType::DYNAMIC
    @body = box2d.world.createBody(bd)

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
    body.createFixture(fd)
    body.setLinearVelocity(Vec2.new(rand(-5..5), rand(2..5)))
  end

  # This function removes the particle from the box2d world
  def kill_body
    box2d.destroy_body(body)
  end

  # Is the particle ready for deletion?
  def done
    # Let's find the screen position of the particle
    pos = box2d.body_coord(body)
    # Is it off the bottom of the screen?
    if pos.y > height + r * 2
      kill_body
      return true
    end
    false
  end

  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.get_angle
    push_matrix
    translate(pos.x, pos.y)
    rotate(a)
    fill(127)
    stroke(0)
    stroke_weight(2)
    ellipse(0, 0, r * 2, r * 2)
    # Let's add a line so we can see the rotation
    line(0, 0, r, 0)
    pop_matrix
  end
end
