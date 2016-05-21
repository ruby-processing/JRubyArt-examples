# Bicubic filtering (see bicubic.glsl file for details)
# Uncheck 'apply_filter' to show regular texture map filtering
# Ported to JRubyArt by Martin Prout
load_library :control_panel

attr_reader :bicubic, :my_image, :hide, :panel, :zoom

def setup  
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title = 'zoom / bicubic'
    c.slider    :zoom, 0.0..100, 60.0
    c.checkbox  :apply_filter, true
    @panel = c
  end
  @hide = false
  @my_image  = load_image('texture.jpg')
  @bicubic = load_shader('bicubic.glsl')
  bicubic.set('sketchSize', width.to_f, height.to_f)
  sketch_title 'Bicubic'
end

def draw
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background(0)
  # Draw the image on the scene
  image(my_image, 0, 0)
  mode = @apply_filter ? 1 : 0
  bicubic.set('mode', mode)
  level = map1d(zoom, (0..100), (0.5..0.1))
  bicubic.set('zoomLevel', level)
  # Applies the shader to everything that has already been drawn
  filter(bicubic)
end

def mouse_pressed
  @hide = false if hide
end

def settings
  size(512, 512, P2D)
end

