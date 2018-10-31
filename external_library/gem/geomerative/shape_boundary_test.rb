require 'geomerative'
load_library :boundary_shape

attr_reader :bounds, :my_rect

def settings
  size(600, 480, P2D)
end

def setup
  sketch_title 'Geomerative Boundary Shape Test'
  RG.init(self)
  RG.set_polygonizer(RG.ADAPTATIVE)
  circle = RShape.createCircle(100, 100, 100);
  rectangle = RShape.createRectangle(100, 100, 100, 50);
  @bounds = RShape.new(circle.union(rectangle))
end

def draw
  fill 255
  stroke 0
  @my_rect = RShape.create_rectangle(mouse_x, mouse_y, 10, 10)
  bounds.draw
  draw_my_rect
end

def draw_my_rect
  if bounds.contains_shape(my_rect)
    no_stroke
    fill 255, 0, 0
  else
    stroke 0
    fill 255
  end
  my_rect.draw
end
