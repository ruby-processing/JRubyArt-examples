#
# Tile Images
#
# Draws an image larger than the screen by tiling it into small sections.
# The scale_value variable sets amount of scaling: 1 is 100%, 2 is 200%, etc.
#
attr_reader :scale_value, :x_offset, :y_offset

def setup
  sketch_title 'Tile Images'
  stroke(0, 100)
  @x_offset = 0     # x-axis offset
  @y_offset = 0     # y-axis offset
  @scale_value = 3  # Multiplication factor
end

def draw
  scale(scale_value)
  translate(x_offset * (-width / scale_value), y_offset * (-height / scale_value))
  line(10, 150, 500, 50)
  line(0, 600, 600, 0)
  set_offset
end

def settings
  size(600, 600)
end

def set_offset
  save_frame(format('lines-%d-%d.png', y_offset, x_offset))
  @x_offset += 1
  if x_offset == scale_value
    @x_offset = 0
    @y_offset += 1
    exit if y_offset == scale_value
  end
  background(204)
end
