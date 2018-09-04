# Planets, by Andres Colubri
#
# Sun and mercury textures from http://planetpixelemporium.com
# Star field picture from http://www.galacticimages.com/

attr_reader :textures, :sun, :planet, :mercury

IMAGES = %w[starfield sun planet mercury)
KEY = %i[starfield sun planet mercury)

def setup
  sketch_title 'Planets'
  images = IMAGES.map { |img| load_image(data_path("#{img}.jpg")) }
  @textures = KEY.zip(images).to_h  
  no_stroke
  fill(255)
  sphere_detail(40)
  @sun = create_shape(SPHERE, 150)
  @sun.set_texture(textures[:sun])  
  @planet = create_shape(SPHERE, 150)
  planet.set_texture(textures[:planet])  
  @mercury = create_shape(SPHERE, 50)
  mercury.set_texture(textures[:mercury])
end

def draw
  # Even we draw a full screen image after this, it is recommended to use
  # background to clear the screen anyways, otherwise P3D will think
  # you want to keep each drawn frame in the framebuffer, which results in 
  # slower rendering.
  background(0)  
  # Disabling writing to the depth mask so the 
  # background image doesn't occludes any 3D object.
  hint(DISABLE_DEPTH_MASK)
  image(textures[:starfield], 0, 0, width, height)
  hint(ENABLE_DEPTH_MASK)   
  push_matrix
  translate(width / 2, height / 2, -300)   
  push_matrix
  rotate_y(PI * frame_count / 500)
  shape(sun)
  pop_matrix
  point_light(255,  255,  255,  0,  0,  0)  
  rotate_y(PI * frame_count / 300)
  translate(0, 0, 300)
  shape(mercury)    
  pop_matrix  
  no_lights
  point_light(255,  255,  255,  0,  0,  -150)   
  translate(0.75 * width,  0.6 * height,  50)
  shape(planet)
end

def settings
  size(1024, 768, P3D)
end
