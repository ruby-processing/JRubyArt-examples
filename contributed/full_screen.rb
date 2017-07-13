# Description:
# This is a full-screen demo
# Using JRubyArt grid method

GRID_SIZE = 100
HALF = 50

def setup
  sketch_title 'Full Screen'
  no_stroke
end

def draw
  lights
  background 0
  fill 120, 160, 220
  grid(width, height, GRID_SIZE, GRID_SIZE) do |x, y|
    push_matrix
    translate x + HALF, y + GRID_SIZE
    rotate_y(((mouse_x.to_f + x) / width) * Math::PI)
    rotate_x(((mouse_y.to_f + y) / height) * Math::PI)
    box 90
    pop_matrix
  end
end

def settings
  full_screen(P3D)
end
