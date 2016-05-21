# Click on the box and drag it across the screen.

attr_reader :block, :block_locked, :over_block
BLOCK_WIDTH = 75

def setup
  sketch_title 'Mouse Functions'
  @block = Block.new(
    center: Vect.new(width / 2, height / 2),
    size: Vect.new(BLOCK_WIDTH, BLOCK_WIDTH))
  @locked = false
  @over_block = false
  rect_mode RADIUS
end

def draw
  background 0
  fill 153
  if block.over?(mouse_x, mouse_y)
    @over_block = true
    stroke 255
    fill 255 if block_locked?
  else
    @over_block = false
    stroke 153
  end
  # Draw the box
  rect block.center.x, block.center.y, block.size.x, block.size.y
end

def block_locked?
  block_locked
end

def over_block?
  over_block
end

def mouse_pressed
  if over_block?
    @block_locked = true
    fill 255
  else
    @block_locked = false
  end
end

def mouse_dragged
  return unless block_locked?
  block.new_position(Vect.new(mouse_x, mouse_y))
end

def mouse_released
  @block_locked = false
end

def settings
  size 640, 360
  smooth 4
end

# Use class to contain block behaviour
class Block
  attr_reader :center, :size

  def initialize(center:, size:)
    @center = center
    @size = size
  end

  def new_position(center)
    @center = center
  end

  def over?(x, y)
    (center.x - 0.5 * size.x..center.x + 0.5 * size.x).cover?(x) &&
      (center.y - 0.5 * size.y..center.y + 0.5 * size.y).cover?(y)
  end
end

Vect = Struct.new(:x, :y)
