attr_reader :img

def settings
  size 400, 400
end

def setup
  sketch_title 'Color Gradient'
  @img = load_image(data_path('gradient.jpg'))
end

def draw
  background(img.get(mouse_x, mouse_y))
end
