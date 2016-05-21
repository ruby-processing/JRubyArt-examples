# Original shader by mrharicot
# https://www.shadertoy.com/view/4dfGDH
# Ported to Processing by Raphaël de Courville <twitter: @sableRaph>
# Ported to JRubyArt by Martin Prout
# Keep mouse pressed to show unfiltered image

attr_reader :apply, :bilateral, :my_image

def setup  
  @my_image  = load_image('texture.jpg')
  @bilateral = load_shader('bilateral.glsl')
  bilateral.set('sketchSize', width.to_f, height.to_f)
  sketch_title 'Bilateral'
end

def draw
  background(0)
  # Draw the image on the scene
  image(my_image, 0, 0)
  # Applies the shader to everything that has already been drawn
  return if mouse_pressed?
  filter(bilateral)
end

def settings
  size(512, 512, P2D)
end
