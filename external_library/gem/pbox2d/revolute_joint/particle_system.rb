module Runnable
  def run
    reject!(&:done?)
    each(&:display)
  end
end

class ParticleSystem
  include Enumerable, Runnable
  extend Forwardable
  def_delegators(:@particles, :each, :reject!, :<<)

  attr_reader :particles

  def initialize
    @particles = []          # Initialize the Array
  end

  def add_particles(width)
    return unless rand < 0.1
    sz = rand(4.0..8)
    particles << Particle.new(rand(width / 2 - 100..width / 2 + 100), -20, sz)
  end
end
