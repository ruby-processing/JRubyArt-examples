require 'forwardable'

module Runnable
  def run
    reject! { |item| item.done }
    each { |item| item.display }
  end
end

class ParticleSystem
  include Enumerable, Runnable
  extend Forwardable
  def_delegators(:@particles, :each, :reject!, :<<, :empty?)
  def_delegator(:@particles, :empty?, :dead?)

  attr_reader :x, :y
  
  def initialize(bd, num, x, y)
    @particles = []          # Initialize the Array
    @x, @y = x, y            # Store the origin point  
    num.times do
      self << Particle.new(bd, x, y)
    end
  end
  
  def add_particles(bd, n)
    n.times do
      self << Particle.new(bd, x, y)
    end
  end
end

# A Particle
require 'pbox2d'

class Particle
  include Processing::Proxy
  TRAIL_SIZE = 6
  # We need to keep track of a Body
  
  attr_reader :trail, :body, :box2d
  
  # Constructor
  def initialize(b2d, x, y)
    @box2d = b2d
    @trail = Array.new(TRAIL_SIZE, [x, y])
    # Add the box to the box2d world
    # Here's a little trick, let's make a tiny tiny radius
    # This way we have collisions, but they don't overwhelm the system
    make_body(x, y, 0.2)
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
    return false unless (pos.y > box2d.height + 20)
    kill_body
    true
  end
  
  # Drawing the box
  def display
    # We look at each body and get its screen position
    pos = box2d.body_coord(body)
    # Keep track of a history of screen positions in an array
    (TRAIL_SIZE - 1).times do |i|
      trail[i] = trail[i + 1]
    end
    trail[TRAIL_SIZE - 1] = [pos.x, pos.y]
    # Draw particle as a trail
    begin_shape
    no_fill
    stroke_weight(2)
    stroke(0, 150)
    trail.each do |v|
      vertex(v[0], v[1])
    end
    end_shape
  end
  
  # This function adds the rectangle to the box2d world
  def make_body(x, y, r)
    # Define and create the body
    bd = BodyDef.new
    bd.type = BodyType::DYNAMIC
    bd.position.set(box2d.processing_to_world(x, y))
    @body = box2d.create_body(bd)
    # Give it some initial random velocity
    body.set_linear_velocity(Vec2.new(rand(-1.0..1), rand(-1.0..1)))
    # Make the body's shape a circle
    cs = CircleShape.new
    cs.m_radius = box2d.scale_to_world(r)
    fd = FixtureDef.new
    fd.shape = cs
    fd.density = 1
    fd.friction = 0  # Slippery when wet!
    fd.restitution = 0.5
    # We could use this if we want to turn collisions off
    # cd.filter.groupIndex = -10
    # Attach fixture to body
    body.create_fixture(fd)
  end
end
