# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
# bare sketch run with k9 run simple_cluster.rb
# Force directed graph,
# heavily based on: http://code.google.com/p/fidgen/

require 'toxiclibs'
require_relative 'cluster'
require_relative 'node'
require 'forwardable'

attr_reader :physics, :cluster, :f, :show_physics, :show_particles

def settings
  size(640, 360)
end

def setup
  sketch_title 'Simple Cluster'
  @f = createFont('Georgia', 12, true)
  @show_physics = true
  @show_particles = true
  @show_physics = true
  @show_particles = true
  # Initialize the physics
  @physics = Physics::VerletPhysics2D.new
  @physics.set_world_bounds(Toxi::Rect.new(10, 10, width - 20, height - 20))
  # Spawn a new random graph
  @cluster = Cluster.new(8, 100, TVec2D.new(width / 2, height / 2))
end

def draw
  # Update the physics world
  physics.update
  background(255)
  # Display all points
  cluster.display if show_particles
  # If we want to see the physics
  cluster.show_connections if show_physics
  # Instructions
  fill(0)
  text_font(f)
  text("'p' to display or hide particles\n'c' to display or hide connections\n'n' for new graph", 10, 20)
end

# Key press commands
def key_pressed
  case key
  when 'c'
    @show_physics = !show_physics
    @show_particles = true if show_physics
  when 'p'
    @show_particles = !show_particles
    @show_particles = true unless show_physics
  when 'n'
    physics.clear
    @cluster = Cluster.new(rand(3..20), rand(10..width / 2), TVec2D.new(width / 2, height / 2))
  end
end
