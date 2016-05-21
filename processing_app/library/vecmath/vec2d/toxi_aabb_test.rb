# Click on the box and drag it across the screen.
require 'toxiclibs'
attr_reader :block, :block_locked, :over_block, :gfx, :bounds
BLOCK_WIDTH = 150


def setup
  sketch_title 'Toxi::Rect Example'
  on_top
  @block = Block.new(
    TVec2D.new((width - BLOCK_WIDTH) / 2, (height - BLOCK_WIDTH) / 2),
    TVec2D.new((width + BLOCK_WIDTH) / 2, (height + BLOCK_WIDTH) / 2)
  )
  @locked = false
  @over_block = false
  @bounds = Toxi::Rect.new(
    TVec2D.new(-width / 2, -height / 2),
    TVec2D.new(width / 2,  height / 2)
  )
  @gfx = Gfx::ToxiclibsSupport.new(self)
  rectMode CENTER
end

def draw
  background 0
  fill 153
  if block.over?(TVec2D.new(mouse_x, mouse_y))
    @over_block = true
    stroke 255
    fill 255 if block_locked?
  else
    @over_block = false
    stroke 153
  end
  # Draw the box as a shape
  gfx.rect(block.aabb)
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
  position = TVec2D.new(mouse_x, mouse_y)
  block.move(position) {  bounds.contains_point(position) }
end

def mouse_released
  @block_locked = false
end

def settings
  size 640, 360
  smooth 4
end

# Use class to contatins_point block behaviour
class Block
  attr_reader :aabb  

  def initialize(a, b)
    @aabb = Toxi::Rect.new(a, b)
  end  

  def move(vec)
    if yield
      aabb.set_position(vec)
    end
  end

  def over?(vec)
    aabb.contains_point vec
  end
end

