#
# PolygonPShapeOOP.
#
# Wrapping a PShape inside a custom class
# and demonstrating how we can have a multiple objects each
# using the same PShape.
#
load_library 'polygon'

# A list of objects
attr_reader :polygons

def settings
  size(640, 360, P2D)
  smooth
end

def setup
  sketch_title 'Polygon PShape OOP 002'
  # Make a PShape
  star = create_shape
  star.begin_shape
  star.no_stroke
  star.fill(0, 127)
  star.vertex(0, -50)
  star.vertex(14, -20)
  star.vertex(47, -15)
  star.vertex(23, 7)
  star.vertex(29, 40)
  star.vertex(0, 25)
  star.vertex(-29, 40)
  star.vertex(-23, 7)
  star.vertex(-47, -15)
  star.vertex(-14, -20)
  star.end_shape(CLOSE)
  # We coud make polygons with different PShapes
  @polygons = (0..25).map do
    Polygon.new(shape: star, max_x: width, max_y: height)
  end
end

def draw
  background(255)
  # Display and move them all
  polygons.each(&:run)
end

