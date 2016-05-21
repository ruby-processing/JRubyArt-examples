# Setup and Draw.
#
# The draw() function creates a structure in which
# to write programs that change with time.

def setup
  sketch_title 'Setup Draw'
  @y = 100
  stroke 255
  frame_rate 30
end

def draw
  background 0
  @y = @y - 1
  @y = height if @y < 0
  line 0, @y, width, @y
end

def settings
  size 640, 360
end
