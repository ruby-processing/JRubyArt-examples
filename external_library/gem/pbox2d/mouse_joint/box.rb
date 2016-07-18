# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
require 'forwardable'
# A rectangular box
class Box
  extend Forwardable
  def_delegators(:@app, :fill, :stroke, :stroke_weight, :rect, :rect_mode,
                 :box2d, :rotate, :translate, :push_matrix, :pop_matrix)
  # We need to keep track of a Body and a width and height
  attr_accessor :body, :w, :h
  # Constructor
  def initialize(x, y)
    @app = $app
    @w, @h = 24, 24
    # Add the box to the box2d world
    make_body(Vec2.new(x, y), w, h)
  end

  # This function removes the particle from the box2d world
  def kill_body
    box2d.destroy_body(body)
  end

  def contains(x, y)
    world_point = box2d.processing_to_world(x, y)
    f = body.get_fixture_list
    f.test_point(world_point)
  end

  # Drawing the box
  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Get its angle of rotation
    a = body.getAngle
    rect_mode(Java::ProcessingCore::PConstants::CENTER)
    push_matrix
    translate(pos.x, pos.y)
    rotate(a)
    fill(127)
    stroke(0)
    stroke_weight(2)
    rect(0, 0, w, h)
    pop_matrix
  end

  # This function adds the rectangle to the box2d world
  def make_body(center, w, h)
    # Define and create the body
    bd = BodyDef.new
    bd.type = BodyType::DYNAMIC
    bd.position.set(box2d.processing_to_world(center))
    @body = box2d.createBody(bd)
    # Define a polygon (this is what we use for a rectangle)
    sd = PolygonShape.new
    box2dw = box2d.scale_to_world(w / 2)
    box2dh = box2d.scale_to_world(h / 2)
    sd.setAsBox(box2dw, box2dh)
    # Define a fixture
    fd = FixtureDef.new
    fd.shape = sd
    # Parameters that affect physics
    fd.density = 1
    fd.friction = 0.3
    fd.restitution = 0.5
    body.create_fixture(fd)
    # Give it some initial random velocity
    body.set_linear_velocity(Vec2.new(rand(-5.0..5), rand(2.0..5)))
    body.set_angular_velocity(rand(-5.0..5))
  end
end
