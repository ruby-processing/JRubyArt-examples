# Earth model with bump mapping, specular texture and dynamic cloud layer.
# Adapted from the THREE.js tutorial to processing by Andres Colubri,
# translated to JRubyArt by Martin Prout:
# http://learningthreejs.com/blog/2013/09/16/how-to-make-the-earth-in-webgl/

attr_reader :earth, :clouds, :earth_shader, :cloud_shader, :earth_rotation
attr_reader :clouds_rotation, :target_angle

def setup
  sketch_title 'Blue Marble'
  @earth_rotation = 0
  @clouds_rotation = 0
  earth_tex = load_image('earthmap1k.jpg')
  cloud_tex = load_image('earthcloudmap.jpg')
  alpha_tex = load_image('earthcloudmaptrans.jpg')
  bump_map = load_image('earthbump1k.jpg')
  spec_map = load_image('earthspec1k.jpg')
  @earth_shader = load_shader('EarthFrag.glsl', 'EarthVert.glsl')
  earth_shader.set('texMap', earth_tex)
  earth_shader.set('bumpMap', bump_map)
  earth_shader.set('specularMap', spec_map)
  earth_shader.set('bumpScale', 0.05)
  @cloud_shader = load_shader('CloudFrag.glsl', 'CloudVert.glsl')
  cloud_shader.set('texMap', cloud_tex)
  cloud_shader.set('alphaMap', alpha_tex)
  @earth = create_shape(SPHERE, 200)
  earth.setStroke(false)
  earth.setSpecular(color(125))
  earth.setShininess(10)
  @clouds = create_shape(SPHERE, 201)
  clouds.setStroke(false)
end

def draw
  background(0)
  translate(width / 2, height / 2)
  point_light(255, 255, 255, 300, 0, 500)
  target_angle = map1d(mouse_x, (0..width), (0..TWO_PI))
  @earth_rotation += 0.05 * (target_angle - earth_rotation)
  shader(earth_shader)
  push_matrix
  rotate_y(earth_rotation)
  shape(earth)
  pop_matrix
  shader(cloud_shader)
  push_matrix
  rotate_y(earth_rotation + clouds_rotation)
  shape(clouds)
  pop_matrix
  @clouds_rotation += 0.001
end

def settings
  size(600, 600, P3D)
end
