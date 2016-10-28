# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
class Blanket
  extend Forwardable
  def_delegators(:@app, :width)
  attr_reader :particles, :springs, :physics

  def initialize(physics)
    @app = $app
    @particles = []
    @springs = []
    w = 20
    h = 20
    len = 10
    strength = 0.125
    h.times do |y|
      w.times do |x|
        p = Particle.new(TVec2D.new(width / 2 + x * len - w * len / 2, y * len))
        physics.add_particle(p)
        particles << p
        if x > 0
          previous = particles[particles.size - 2]
          c = Connection.new(p, previous, len, strength)
          physics.add_spring(c)
          springs << c
        end
        if y > 0
          above = particles[particles.size - w - 1]
          c = Connection.new(p, above, len, strength)
          physics.add_spring(c)
          springs << c
        end
      end
    end
    topleft = particles[0]
    topleft.lock
    topright = particles[w - 1]
    topright.lock
  end

  def display
    springs.each(&:display)
  end
end
