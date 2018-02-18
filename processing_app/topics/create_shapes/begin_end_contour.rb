#
# BeginEnd_contour
#
# How to cut a shape out of another using begin_contour and end_contour
#

attr_reader :contour

def setup
  sketch_title 'Begin End Contour'
  # Make a shape
  @contour = make_contour
end

def draw
  background(52)
  # Display shape
  translate(width / 2, height / 2)
  # Shapes can be rotated
  contour.rotate(0.01)
  shape(contour)
end

def make_contour
  create_shape.tap do |shp|
    shp.begin_shape
    shp.fill(0)
    shp.stroke(255)
    shp.stroke_weight(2)
    # Exterior part of shape
    shp.vertex(-100, -100)
    shp.vertex(100, -100)
    shp.vertex(100, 100)
    shp.vertex(-100, 100)
    # Interior part of shape
    shp.begin_contour
    shp.vertex(-20, -20)
    shp.vertex(-20, 20)
    shp.vertex(20, 20)
    shp.vertex(20, -20)
    shp.end_contour
    # Finishing off shape
    shp.end_shape(CLOSE)
  end
end

def settings
  size(640, 360, P2D)
end
