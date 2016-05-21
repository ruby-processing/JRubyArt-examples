# Redraw.
#
# The redraw() function makes draw() execute once.
# In this example, draw() is executed once every time
# the mouse is clicked.

def setup
  sketch_title 'Redraw'
  @y = 100
  stroke 255
  no_loop
end

def draw
  background 0
  @y = @y - 1
  @y = height if @y < 0
  line 0, @y, width, @y
end

def mouse_pressed
  redraw
end

def settings
  size 200, 200
end
