load_library :control_panel

attr_reader :hide, :panel, :bluish
def setup
  sketch_title 'Simple Slider'
  control_panel do |c|
    c.look_feel 'Motif'
    c.title 'Slider'
    c.slider :bluish, 0.2..1.0, 0.5
    @panel = c
  end
  color_mode(RGB, 1.0)
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background(0, 0, bluish)
end

def settings
  size 300, 300
end
