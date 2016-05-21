require 'pbox2d'
require_relative 'lib/particle_system'
require_relative 'lib/boundary'
attr_reader :box2d, :boundaries, :systems

Vect = Struct.new(:x, :y)

def setup
  sketch_title 'Liquidy'
  @box2d = WorldBuilder.build(app: self, gravity: [0, -20])
  @systems = []
  @boundaries = [
    Boundary.new(box2d, Vect.new(50, 100), Vect.new(300, 5), -0.3),
    Boundary.new(box2d, Vect.new(250, 175), Vect.new(300, 5), 0.5)
  ]
end

def draw
  background(255)
  # Run all the particle systems
  if systems.size > 0
    systems.each do |system|
      system.run
      system.add_particles(box2d, rand(0..2))
    end
  end
  # Display all the boundaries
  boundaries.each(&:display)
end

def mouse_pressed
  # Add a new Particle System whenever the mouse is clicked
  systems << ParticleSystem.new(box2d, 0, mouse_x, mouse_y)
end

def settings
  size(400,300)
end
