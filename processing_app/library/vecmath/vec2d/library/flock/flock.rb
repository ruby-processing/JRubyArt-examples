# The Flock (a list of Boid objects)
require 'forwardable'

# The flock class is enumerable
class Flock
  extend Forwardable
  def_delegators(:@boids, :each, :reject, :<<)
  include Enumerable

  def initialize(size, position)
    @boids = (0..size).map{ Boid.new(position) }
  end

  def run
    self.each do |bird|
      bird.run(self)  # Passing the entire list of boids to each boid individually
    end
  end
end

# The Boid class

class Boid
  include Processing::Proxy
  attr_reader :location, :velocity, :acceleration, :rad, :maxforce, :maxspeed
  def initialize(loc)
    @acceleration = Vec2D.new
    @velocity = Vec2D.random
    @location = loc
    @rad = 2.0
    @maxspeed = 2
    @maxforce = 0.03
  end

  def run(boids)
    flock(boids)
    update
    borders
    render
  end

  def apply_force(force)
    # We could add mass here if we want A = F / M
    @acceleration += force
  end

  def flock(boids)
    calculate_forces(boids).each {  |force| apply_force(force) }
  end

  # We calculate the forces each time based on three rules
  def calculate_forces(boids)
    forces = []
    forces << separate(boids) * 1.5   # Separation weighted 1.5
    forces << align(boids)            # Alignment weighted 1.0
    forces << cohesion(boids)         # Cohesion weighted 1.0
  end


  # Method to update location
  def update
    # Update velocity
    @velocity += acceleration
    # Limit speed
    velocity.set_mag(maxspeed) { velocity.mag > maxspeed }
    @location += velocity
    # Reset accelertion to 0 each cycle
    @acceleration *= 0
  end

  # A method that calculates and applies a steering force towards a target
  # STEER = DESIRED MINUS VELOCITY
  def seek(target)
    desired = target - location  # A vector pointing from the location to the target
    # Normalize desired and scale to maximum speed
    desired.normalize!
    desired *= maxspeed
    # Steering = Desired minus Velocity
    steer = desired - velocity
    # Limit to maximum steering force
    steer.set_mag(maxforce) { steer.mag > maxforce }
    return steer
  end

  def render
    # Draw a triangle rotated in the direction of velocity
    theta = velocity.heading + Math::PI/2
    fill(200, 100)
    stroke(255)
    push_matrix
    translate(location.x,location.y)
    rotate(theta)
    begin_shape(TRIANGLES)
    vertex(0, -rad * 2)
    vertex(-rad, rad * 2)
    vertex(rad, rad * 2)
    end_shape
    pop_matrix
  end

  # Wraparound
  def borders
    location.x = width + rad if location.x < -rad
    location.y = height + rad if location.y < -rad
    location.x = -rad if location.x > width + rad
    location.y = -rad if location.y > height + rad
  end

  # Separation
  # Method checks for nearby boids and steers away
  def separate(boids)
    desiredseparation = 25.0
    steer = Vec2D.new
    count = 0
    # For every other bird in the system, check if it's too close
    boids.reject{ |bd| bd.equal? self }.each do |other|
      d = location.dist(other.location)
      # If the distance is greater than 0 and less than an arbitrary amount
      if (0.0001..desiredseparation).include? d
        # Calculate vector pointing away from neighbor
        diff = location - other.location
        diff.normalize!
        diff /= d             # Weight by distance
        steer += diff
        count += 1            # Keep track of how many
      end
    end
    # Average -- divide by how many
    if count > 0
      steer /= count.to_f
    end

    # As long as the vector is greater than 0
    if steer.mag > 0
      # Implement Reynolds: Steering = Desired - Velocity
      steer.normalize!
      steer *= maxspeed
      steer -= velocity
      steer.set_mag(maxforce) { steer.mag > maxforce }
    end
    return steer
  end

  # Alignment
  # For every other nearby boid in the system, calculate the average velocity
  def align(boids)
    neighbordist = 50
    sum = Vec2D.new
    steer = Vec2D.new
    count = 0
    boids.reject{ |bd| bd.equal? self }.each do |other|
      d = location.dist(other.location)
      if (0..neighbordist).include? d
        sum += other.velocity
        count += 1
      end
    end
    if (count > 0)
      sum /= count.to_f
      sum.normalize!
      sum *= maxspeed
      steer = sum - velocity
      steer.set_mag(maxforce) { steer.mag > maxforce }
    end
    return steer
  end

  # Cohesion
  # For the average location (i.e. center) of all other nearby boids, calculate
  # steering vector towards that location
  def cohesion(boids)
    neighbordist = 50
    sum = Vec2D.new   # Start with empty vector to accumulate all locations
    count = 0
    boids.reject { |bd| bd.equal? self }.each do |other|
      d = location.dist(other.location)
      if (0.0001..neighbordist).include? d
        sum += other.location # Add location
        count += 1
      end
    end
    sum /= count unless count == 0        # avoid div by zero
    (count > 0) ? seek(sum) : Vec2D.new
  end
end
