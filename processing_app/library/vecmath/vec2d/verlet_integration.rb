#
# Verlet Integration - ragdoll chain
# after a sketch by Ira Greenberg
#
load_library :verlet_chain
PARTICLES = 5
LINKS = PARTICLES - 1

attr_reader :sticks, :balls

def settings
  size(400, 400)
end

def setup
  sketch_title 'Verlet Chain'
  ellipse_mode(RADIUS)
  rshape = 40
  tension = 0.05
  @sticks = []
  @balls = []
  (0..PARTICLES).each do |i|
    push = Vec2D.new(rand(3..6.5), rand(3..6.5))
    pos = Vec2D.new(width / 2 + (rshape * i), height / 2)
    balls << VerletBall.new(pos, push, 5.0)
    next if i.zero?
    sticks << VerletStick.new(balls[i - 1], balls[i], tension)
  end
end

def draw
  background(255)
  sticks.each(&:run)
  balls.each(&:run)
end
