# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
require 'forwardable'

CENTER ||= Java::ProcessingCore::PConstants::CENTER

# A rectangular box
class Box
  extend Forwardable
  def_delegators(:@app, :push_matrix, :pop_matrix, :fill, :rotate, :box2d,
                 :stroke_weight, :translate, :rect_mode, :stroke, :rect)
  # We need to keep track of a Body and a width and height
  attr_reader :body, :w, :h

  # Constructor
  def initialize(x, y, w, h, lock)
    @w, @h = w, h
    @app = $app
    # Define and create the body
    bd = BodyDef.new
    bd.position.set(box2d.processing_to_world(Vec2.new(x, y)))
    bd.type = lock ? BodyType::STATIC : BodyType::DYNAMIC

    @body = box2d.createBody(bd)

    # Define the shape -- a  (this is what we use for a rectangle)
    sd = PolygonShape.new
    box2dW = box2d.scale_to_world(w / 2)
    box2dH = box2d.scale_to_world(h / 2)
    sd.setAsBox(box2dW, box2dH)

    # Define a fixture
    fd = FixtureDef.new
    fd.shape = sd
    # Parameters that affect physics
    fd.density = 1
    fd.friction = 0.3
    fd.restitution = 0.5

    body.createFixture(fd)

    # Give it some initial random velocity
    body.setLinearVelocity(Vec2.new(rand(-5..5),rand(2..5)))
    body.setAngularVelocity(rand(-5..5))
  end

  # This function removes the particle from the box2d world
  def killBody
    box2d.destroyBody(body)
  end

  # Drawing the box
  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.getAngle

    rect_mode(CENTER)
    push_matrix
    translate(pos.x,pos.y)
    rotate(-a)
    fill(127)
    stroke(0)
    stroke_weight(2)
    rect(0,0,w,h)
    pop_matrix
  end
end
