BALL_COLORS = [[255, 0, 0], [255, 255, 0], [64, 64, 255]].freeze

# Bouncing ball
class Ball
  attr_reader :sketch, :position, :delta, :bounds

  def initialize(sketch, id)
    @sketch = sketch
    @position = Vec2D.new rand(100..300), rand(100..300)
    @delta = Vec2D.new rand(-6..6), rand(-6..6)
    @size = rand(60..100)
    radius = @size / 2.0
    @color = BALL_COLORS[id % BALL_COLORS.size]
    @bounds = Boundary.new(40 + radius, 360 - radius)
  end

  def draw
    @position += delta
    if bounds.exclude? position.x
      position.x = position.x > bounds.upper ? bounds.upper : bounds.lower
      delta.x *= -1
    end
    if bounds.exclude? position.y
      position.y = position.y > bounds.upper ? bounds.upper : bounds.lower
      delta.y *= -1
    end
    sketch.fill(*@color)
    sketch.handy.ellipse(position.x, position.y, @size, @size)
  end
end

# Useful helper class
Boundary = Struct.new(:lower, :upper) do
  def exclude?(val)
    !(lower..upper).cover? val
  end
end
