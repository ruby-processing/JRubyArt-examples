# encoding: utf-8
# After a ruby-processing sketch by Peter Esveld
# demonstrates how to create and use a local library with JRubyArt
# Also features use of 'forwardable' to create a custom enumerable
load_library :particles

attr_accessor :attractor, :particle

def settings
  size 800, 600, P3D
end

def setup
  sketch_title 'Spirograph'
  ArcBall.init(self) # use mouse wheel to zoom, drag to rotate
  new_particle
end

def draw
  background 0
  draw_particle
end

def new_particle
  ac = Vec3D.new(0.0, 0.0, 0.0)
  ve = Vec3D.new(0.0, 1.0, 0.0)
  lo = Vec3D.new(50, 50, 0.0)
  # Create new thing with some initial settings
  @particle = Particle.new(acceleration: ac, velocity: ve, location: lo)
  # Create an attractive body
  @attractor = Attractor.new(
    location: Vec3D.new(0, 0, 0.0),
    mass: 3,
    gravity: 2
  )
end

def draw_particle
  attractor.go
  # Calculate a force exerted by 'attractor' on 'thing'
  f = attractor.calc_grav_force(particle)
  # Apply that force to the thing
  particle.apply_force(f)
  # Update and render the positions of both objects
  particle.run
end

def mouse_pressed
  puts particle.points
  puts '======================================================================='
end
