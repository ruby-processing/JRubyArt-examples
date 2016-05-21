attr_reader :dithering, :my_image, :noise_image

def setup
  sketch_title 'Dithering'
  @my_image  = load_image('texture.jpg')
  @noise_image  = load_image('noise.png')
  # Load and configure the shader
  @dithering = load_shader('dithering.glsl')
  dithering.set('sketchSize', width.to_f, height.to_f)
  dithering.set("noiseTexture", noise_image)
end

def draw
  background(0)
  # Draw the image on the scene
  image(my_image, 0, 0)
  # Applies the shader to everything that has already been drawn
  return if mouse_pressed?
  filter(dithering)
end

def settings
  size(512, 512, P2D)
end
