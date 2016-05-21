# Objects
# original by hbarragan, somewhat re-factored version by Martin Prout
#
# Move the cursor across the image to change the speed and positions
# of the geometry. The class MyRect defines a group of lines.
attr_reader :rectangles

def settings
  size 640, 360
end

def setup
  sketch_title 'Objects'
  fill 255, 204
  no_stroke
  @rectangles = [
    MyRect.new(
      size: Vec2D.new(1, 0.532 * height),
      position: Vec2D.new(134.0, 0.1 * height),
      spacing: 10.0
    ),
    MyRect.new(
      size: Vec2D.new(2, 0.166 * height),
      position: Vec2D.new(44.0, 0.3 * height),
      spacing: 5.0,
      count: 50
    ),
    MyRect.new(
      size: Vec2D.new(2, 0.332 * height),
      position: Vec2D.new(58.0, 0.4 * height),
      spacing: 10.0,
      count: 35
    ),
    MyRect.new(
      size: Vec2D.new(1, 0.0498 * height),
      position: Vec2D.new(120.0, 0.9 * height),
      spacing: 15.0
    )
  ]
end

def draw
  background 0
  rectangles.each(&:display)
  rectangles[0].move(
    mouse: Vec2D.new(mouse_x - (width / 2), mouse_y + (height * 0.1)),
    damping: 30.0
  )
  rectangles[1].move(
    mouse: Vec2D.new(
      (mouse_x + width * 0.05) % width,
      mouse_y + (height * 0.025)
    ),
    damping: 20.0
  )
  rectangles[2].move(
    mouse: Vec2D.new(mouse_x / 4, mouse_y - (height * 0.025)),
    damping: 40.0
  )
  rectangles[3].move(
    mouse: Vec2D.new(mouse_x - (width / 2),	height - mouse_y),
    damping: 50.0
  )
end

# MyRect class
class MyRect
  attr_accessor :size, :pos, :spacing, :count, :height

  def initialize(size:, position:, spacing:, count: 60)
    @size = size
    @spacing = spacing
    @count = count
    @height = height
    @pos = position
  end

  def move(mouse:, damping:)
    dif = pos - mouse
    @pos -= dif / damping if dif.mag > 1
  end

  def display
    count.times do |i|
      rect pos.x + (i * (spacing + size.x)), pos.y, size.x, size.y
    end
  end
end
