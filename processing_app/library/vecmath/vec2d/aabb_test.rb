# Click on the box and drag it across the screen.

attr_reader :block, :block_locked, :over_block, :bounds
BLOCK_WIDTH = 150

def setup
  sketch_title 'AaBb Example'
  on_top
  @block = Block.new(
    center: Vec2D.new(width / 2, height / 2),
    size: Vec2D.new(BLOCK_WIDTH, BLOCK_WIDTH))
  @locked = false
  @over_block = false
  @bounds = AaBb.new(
    center: Vec2D.new(width / 2, height / 2),
    extent: Vec2D.new(width - BLOCK_WIDTH, height - BLOCK_WIDTH)
  )
end

def draw
  background 0
  fill 153
  if block.over?(Vec2D.new(mouse_x, mouse_y))
    @over_block = true
    stroke 255
    fill 255 if block_locked?
  else
    @over_block = false
    stroke 153
  end
  # Draw the box as a shape
  begin_shape
  block.points_array.each { |vec| vec.to_vertex(renderer) }
  end_shape(CLOSE)
end

def renderer
  @renderer ||= AppRender.new(self)
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
  position = Vec2D.new(mouse_x, mouse_y)
  block.new_position(position) { bounds.contains? position }
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
  attr_reader :aabb
  

  def initialize(center:, size:)
    @aabb = AaBb.new(center: center, extent: size)
  end

  def new_position(center, &block)
    @aabb.position(center.dup, &block)
  end

  def over?(vec)
    aabb.contains? vec
  end

  # use for shape
  def points_array
    a = aabb.center - aabb.extent * 0.5
    c = aabb.center + aabb.extent * 0.5
    b = Vec2D.new(c.x, a.y)
    d = Vec2D.new(a.x, c.y)
    [a, b, c, d]
  end

  # use for rect
  def points
    [aabb.center, aabb.extent]
  end
end

