require 'pbox2d'
require 'forwardable'
require_relative 'lib/custom_listener'
require_relative 'lib/particle'
require_relative 'lib/boundary'

attr_reader :box2d, :particles, :wall

def setup
  size 400, 400
  @box2d = WorldBuilder.build(app: self)
  box2d.add_listener(CustomListener.new)
  @particles = []
  @wall = Boundary.new(self, width / 2, height - 5, width, 10)
end

def draw
  col = color('#ffffff')
  background(col)
  particles << Particle.new(self, rand(width), 20, rand(4..8)) if rand < 0.1
  particles.each(&:display)
  particles.reject!(&:done)
  wall.display
end
