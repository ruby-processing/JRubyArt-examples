# Pixelate effect
# Original shader by simesgreen
# https://www.shadertoy.com/view/4sl3zr
# Ported to Processing by Raphaël de Courville <twitter: @sableRaph>
# Ported to JRubyArt by Martin Prout
# Hold mouse click to show unfiltered image

attr_reader :my_filter, :my_image

def setup
  sketch_title 'Pixelate'
  @my_image  = load_image('texture.jpg')
  @my_filter = load_shader('pixelate.glsl')
  my_filter.set('sketchSize', width.to_f, height.to_f)
end

def draw
  background(0)
  # Draw the image on the scene
  image(my_image, 0, 0)
  oscillation = make_even(map1d(sin(frame_count * 0.01), (-1.0..1.0), (2..128)))
  offset_x = make_even(width % oscillation * 0.5).to_f
  offset_y = make_even(height % oscillation * 0.5).to_f
  my_filter.set('pixelSize', oscillation.to_f)
  my_filter.set('offset', offset_x, offset_y)
  # Applies the shader to everything that has already been drawn
  return if mouse_pressed?
  filter(my_filter)
end

def make_even(source)
  return source.floor if source.floor.even?
  (source / 2).floor * 2
end

def settings
  size(512, 512, P2D)
end

