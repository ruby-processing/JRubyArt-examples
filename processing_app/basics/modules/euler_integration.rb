#
# Euler Integration (v01)
# pos  +=  spd
# sketch after Ira Greenwood 
# Features first class keyword arguments, and use of modules
#
require_relative 'euler_ball'

attr_reader :ball

def setup
  sketch_title 'Euler Integration'
  @ball = EulerBall.new(
    position: Vec2D.new(width / 2, height / 2),
    # create a random direction vector, scaled by 3
    speed: Vec2D.random * 3,
    radius: 10
  )
end

def draw
  background(255)
  # fill(255, 2)
  # rect(-1, -1, width + 1, height + 1)
  fill(0)
  ball.run
end

def settings
  size(400, 400)
  smooth 4
end
