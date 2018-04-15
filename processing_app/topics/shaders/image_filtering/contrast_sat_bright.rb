load_library :control_panel

attr_reader :my_filter, :my_image, :brightness, :contrast, :saturation

def setup
  sketch_title 'Contrast Sat Bright'
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title 'Control'
    c.slider  :brightness, 0..100, 60
    c.slider  :saturation,  0..100, 70
    c.slider  :contrast,  50..150, 100
  end  
  @my_image  = load_image(data_path('texture.jpg'))
  @my_filter = load_shader(data_path('shader.glsl'))
end

def draw
  background(0)
  # Draw the image on the scene
  image(my_image, 0, 0)
  # contrast settings: 1.0 = 100% 0.5 = 50% 1.5 = 150%
  c = map1d(contrast, (50..150), (0.5..1.5))
  s = map1d(saturation, (0..100), (0.0..1.5))
  b = map1d(brightness, (0..100), (0.3..1.5))
  # Pass the parameters to the shader
  my_filter.set('contrast', c)
  my_filter.set('saturation', s)
  my_filter.set('brightness', b)
  # Applies the shader to everything that has already been drawn
  filter(my_filter)
end

def settings
  size(512, 512, P2D)
end
