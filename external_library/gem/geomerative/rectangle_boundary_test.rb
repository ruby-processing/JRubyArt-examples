require 'geomerative'

attr_reader :bounds, :my_rect

def settings
  size(600, 480, P2D)
end

def setup
  sketch_title 'Geomerative Boundary Test'
  RG.init(self)
  RG.set_polygonizer(RG.ADAPTATIVE)
  @bounds = RShape.create_rectangle(100, 100, 100, 50)
end

def draw
  fill 255
  stroke 0
  @my_rect = RShape.create_rectangle(mouseX, mouseY, 10, 10)
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
