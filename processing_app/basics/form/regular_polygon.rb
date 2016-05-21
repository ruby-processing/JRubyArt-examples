#
# Regular Polygon
#
# What is your favorite? Pentagon? Hexagon? Heptagon?
# No? What about the icosagon? The polygon function
# created for this example is capable of drawing any
# regular polygon. Try placing different numbers into the
# polygon function calls within draw to explore.
#
def setup
  sketch_title 'Regular Polygon'
end

def draw
  background(102)
  push_matrix
  translate(width * 0.2, height * 0.5)
  rotate(frame_count / 200.0)
  polygon(0, 0, 82, 3)
  pop_matrix
  push_matrix
  translate(width * 0.5, height * 0.5)
  rotate(frame_count / 50.0)
  polygon(0, 0, 80, 20)
  pop_matrix
  push_matrix
  translate(width * 0.8, height * 0.5)
  rotate(frame_count / -100.0)
  polygon(0, 0, 70, 7)
  pop_matrix
end

def polygon(x, y, radius, npoints)
  angle = TAU / npoints
  begin_shape
  (0..TAU).step(angle) do |a|
    sx = x + Math.cos(a) * radius
    sy = y + Math.sin(a) * radius
    vertex(sx, sy)
  end
  end_shape(CLOSE)
end

def settings
  size(640, 360)
end
