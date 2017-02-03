# frozen_string_literal: true
# Chain link end as a ball
class VerletStick
  include Processing::Proxy
  attr_reader :ball_1, :ball_2, :stiffness, :len

  def initialize(ball_1, ball_2, stiffness)
    @ball_1 = ball_1
    @ball_2 = ball_2
    @stiffness = stiffness
    @len = ball_1.pos.dist(ball_2.pos)
  end

  def run
    render
    constrain_len
  end

  private

  def render
    begin_shape
    vertex(ball_1.pos.x, ball_1.pos.y)
    vertex(ball_2.pos.x, ball_2.pos.y)
    end_shape
  end

  def constrain_len
    delta = ball_2.pos - ball_1.pos
    delta_length = delta.mag
    difference = ((delta_length - len) / delta_length)
    ball_1.adjust delta * (0.5 * stiffness * difference)
    ball_2.adjust delta * (-0.5 * stiffness * difference)
  end
end
