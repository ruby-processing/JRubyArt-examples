load_library :control_panel

attr_reader :bluish
def setup
  sketch_title 'Simple Slider'
  control_panel do |c|
    c.title 'Slider'
    c.slider :bluish, 0.2..1.0, 0.5
  end
  color_mode(RGB, 1.0)
end

def draw
  background(0, 0, bluish)
end

def settings
  size 300, 300
end
