# Original shader by mrharicot
# https://www.shadertoy.com/view/4dfGDH

# Ported to Processing by Raphaël de Courville <twitter: @sableRaph>
# Ported to JRubyArt by Martin Prout
# Hold mouse click to show unfiltered image
load_library :control_panel
attr_reader :my_filter, :my_image, :amount, :panel, :hide

def setup
  sketch_title 'Fisheye Pincushion'
  setup_control
  @my_image  = load_image('texture.jpg')
  @hide = false
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background(0)
  @my_filter = load_shader('fish_eye.glsl')
  my_filter.set('sketchSize', width.to_f, height.to_f)
  # Draw the image on the scene
  image(my_image, 0, 0)
  # Set the fisheye amount (the range is between -0.5 and 0.5)
  # Negative for pincushion and positive for fisheye
  my_filter.set('amount', amount / 100)
  filter(my_filter)
end

def setup_control
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title = 'adjust pin..fish'
    c.slider :amount, -50.0..50.0, 0
    @panel = c
  end
end

def settings
  size(512, 512, P2D)
end
