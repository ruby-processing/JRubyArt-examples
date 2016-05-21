# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# A soft pendulum (series of connected springs)
class Chain
  include Processing::Proxy
  # Chain properties
  attr_reader :total_length, :num_points, :strength, :radius, :particles, :tail
  attr_reader :physics, :dragged, :offset

  # Chain constructor
  def initialize(p, l, n, r, s)
    @particles = []
    @physics, @total_length, @num_points, @radius, @strength = p, l, n, r, s
    len = total_length / num_points
    @offset = Vect.new(0, 0)
    # Here is the real work, go through and add particles to the chain itself
    num_points.times do |i|
      # Make a new particle with an initial starting location
      particle = Particle.new($app.width / 2, i * len)
      # Redundancy, we put the particles both in physics and in our own Array
      physics.addParticle(particle)
      particles << particle
      # Connect the particles with a Spring (except for the head)
      next if (i == 0)
      previous = particles[i - 1]
      # Add the spring to the physics world
      physics.addSpring(Physics::VerletSpring2D.new(particle, previous, len, strength))
    end
    # Keep the top fixed
    particles[0].lock
    # Store reference to the tail
    @tail = particles[num_points - 1]
    tail.radius = radius
  end

  # Check if a point is within the ball at the end of the chain
  # If so, set dragged = true
  def contains(x, y)
    return if (x - tail.x) * (x - tail.x)  + (y - tail.y) * (y - tail.y) < radius * radius
    offset.x = tail.x - x
    offset.y = tail.y - y
    tail.lock
    @dragged = true
  end

  # Release the ball
  def release
    tail.unlock
    @dragged = false
  end

  # Update tail location if being dragged
  def update_tail(x, y)
    tail.set(x + offset.x, y + offset.y) if dragged
  end

  # Draw the chain
  def display
    # Draw line connecting all points
    begin_shape
    stroke(0)
    stroke_weight(2)
    no_fill
    particles.each { |p| vertex(p.x, p.y) }
    end_shape
    tail.display
  end
end

Vect = Struct.new(:x, :y)
