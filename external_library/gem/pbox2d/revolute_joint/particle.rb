# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
require 'forwardable'

# A circular particle
class Particle
  extend Forwardable
  def_delegators(:@app, :box2d, :push_matrix, :pop_matrix, :fill, :rotate, 
                 :line, :stroke_weight, :translate, :rect_mode, :stroke, 
                 :ellipse, :height)
  # We need to keep track of a Body and a radius
  attr_reader :body, :r

  def initialize(x, y, r)
    @app = $app
    @r = r
    # This function puts the particle in the Box2d world
    makeBody(x, y, r)
    body.setUserData(self)
  end

  # This function removes the particle from the box2d world
  def kill_body
    box2d.destroyBody(body)
  end

  # Is the particle ready for deletion?
  def done?
    # Let's find the screen position of the particle
    pos = box2d.body_coord(body)
    # Is it off the bottom of the screen?
    if pos.y > height + r * 2
      kill_body
      return true
    end
    false
  end

  # 
  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.getAngle
    push_matrix
    translate(pos.x, pos.y)
    rotate(-a)
    fill(127)
    stroke(0)
    stroke_weight(2)
    ellipse(0, 0, r * 2, r * 2)
    # Let's add a line so we can see the rotation
    line(0, 0, r, 0)
    pop_matrix
  end

  # Here's our function that adds the particle to the Box2D world
  def makeBody(x, y, r)
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

    fd.density = 2.0
    fd.friction = 0.01
    fd.restitution = 0.3 # Restitution is bounciness

    body.createFixture(fd)

    # Give it a random initial velocity (and angular velocity)
    # body.setLinearVelocity(Vec2.new(rand(-10.0..10), rand(5.0..10)))
    body.setAngularVelocity(rand(-10.0..10))
  end
end

