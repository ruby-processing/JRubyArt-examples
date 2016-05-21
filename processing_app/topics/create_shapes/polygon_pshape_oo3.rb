#
# PolygonPShapeOOP.
#
# Wrapping a PShape inside a custom class
# and demonstrating how we can have a multiple objects each
# using the same PShape.
#
load_library :polygon

# A list of objects
attr_reader :polygons

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title 'Polygon PShape 003'
  shapes = []
  shape = create_shape(ELLIPSE, 0, 0, 100, 100) # circle
  shape.set_fill(color(255, 127))
  shape.set_stroke(false)
  shapes << shape                               # square
  shape = create_shape(RECT, 0, 0, 100, 100)
  shape.set_fill(color(255, 127))
  shape.set_stroke(false)
  shapes << shape
  shape = create_shape
  shape.begin_shape                             # star
  shape.fill(0, 127)
  shape.no_stroke
  shape.vertex(0, -50)
  shape.vertex(14, -20)
  shape.vertex(47, -15)
  shape.vertex(23, 7)
  shape.vertex(29, 40)
  shape.vertex(0, 25)
  shape.vertex(-29, 40)
  shape.vertex(-23, 7)
  shape.vertex(-47, -15)
  shape.vertex(-14, -20)
  shape.end_shape(CLOSE)
  shapes << shape
  # Create an Array of polygons see polygon library
  @polygons = (0..25).map do
    Polygon.new(shape: shapes.sample, max_x: width, max_y: height)
  end
end

def draw
  background(102)
  # Display and move them all
  polygons.each(&:run)
end
