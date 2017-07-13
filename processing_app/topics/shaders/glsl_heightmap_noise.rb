# Noise-Based GLSL Heightmap by Amnon Owed (May 2013)
# https://github.com/AmnonOwed
# http://vimeo.com/amnon
#
# Creating a GLSL heightmap running on shader-based procedural noise.
#
# c = cycle through the color maps
#
# Requires JRubyArt-1.0.5+
#
# Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/)
# made available under a CC Attribution 3.0 license.
#
DIM = 300 # the grid dimensions of the heightmap
attr_reader :blur_factor # the blur for the displacement map
attr_reader :resize_factor # the resize factor for the displacement map
attr_reader :displace_strength
attr_reader :positions
attr_reader :tex_coords
attr_reader :height_map # PShape holds the geometry, textures etc.
attr_reader :displace # GLSL shader

attr_reader :images # array to hold 2 input images
attr_reader :color_map # variable to keep track of the current colorMap

def setup
  sketch_title 'Glsl Heightmap Noise'
  @blur_factor = 3
  @resize_factor = 0.25
  displace_strength = 0.25 # the displace strength of the GLSL shader
  # load the images
  textures = %w(Texture01.jpg Texture02.jpg)
  @images = textures.map { |texture| load_image(data_path(texture)) }
  @color_map = 0
  # load the PShader with a fragment and a vertex shader
  shader_name = %w(displaceFrag.glsl displaceVert.glsl)
  shaders = shader_name.map { |s| data_path(s) }
  @displace = load_shader(shaders[0], shaders[1])
  displace.set('displaceStrength', displace_strength) # set the displace_strength
  displace.set('colorMap', images[color_map]) # set the initial colorMap
  # create the heightmap PShape (see custom creation method) and put it in the
  # global height_map reference
  @height_map = create_plane(DIM, DIM)
end

def draw
  # required for texLight shader
  pointLight(255, 255, 255, 2 * (mouse_x - width / 2), 2 * (mouse_y - height / 2), 500)
  translate(width / 2, height / 2) # translate to center of the screen
  rotate_x(60.radians) # fixed rotation of 60 degrees around the X axis
  rotate_z(frame_count * 0.005) # dynamic rotation around the Z axis

  background(0) # black background
  # perspective for close shapes
  perspective(PI / 3.0, width.to_f / height, 0.1, 1_000_000)
  scale(750) # scale by 750 (the model itself is unit length
  displace.set('time', millis / 5_000.0) # feed time to the GLSL shader
  shader(displace) # use shader
  shape(height_map) # display the PShape

  # write the fps and the current color_map in the top-left of the window
  title_format = 'Frame Rate: %d | Color Map: %d'
  surface.set_title(format(title_format, frame_rate.to_i, color_map + 1))
end

# custom method to create a PShape plane with certain xy DIMensions
def create_plane(xsegs, ysegs)
  # STEP 1: create all the relevant data

  @positions = [] # arrayList to hold positions
  @tex_coords = [] # arrayList to hold texture coordinates

  usegsize = 1 / xsegs.to_f # horizontal stepsize
  vsegsize = 1 / ysegs.to_f # vertical stepsize

  grid(xsegs, ysegs) do |x, y| # using JRubyArt grid method
    u = x / xsegs.to_f
    v = y / ysegs.to_f
    
    # generate positions for the vertices of each cell
    # (-0.5 to center the shape around the origin)
    positions << Vec3D.new(u - 0.5, v - 0.5, 0)
    positions << Vec3D.new(u + usegsize - 0.5, v - 0.5, 0)
    positions << Vec3D.new(u + usegsize - 0.5, v + vsegsize - 0.5, 0)
    positions << Vec3D.new(u - 0.5, v + vsegsize - 0.5, 0)
    
    # generate texture coordinates for the vertices of each cell
    tex_coords << Vec2D.new(u, v)
    tex_coords << Vec2D.new(u + usegsize, v)
    tex_coords << Vec2D.new(u + usegsize, v + vsegsize)
    tex_coords << Vec2D.new(u, v + vsegsize)
  end

  # STEP 2: put all the relevant data into the PShape

  texture_mode(NORMAL) # set texture_mode to normalized (range 0 to 1)
  tex = images[0]

  mesh = create_shape # create the initial PShape
  renderer = ShapeRender.new(mesh) # initialize the shape renderer
  mesh.begin_shape(QUADS) # define the PShape type: QUADS
  mesh.no_stroke
  mesh.texture(tex) # set a texture to make a textured PShape
  # put all the vertices, uv texture coordinates and normals into the PShape
  positions.each_with_index do |p, i|
    p.to_vertex_uv(renderer, tex_coords[i]) # NB: tex_coords as Vec2D
    # p.to_vertex_uv(renderer, u, v) # u, v as floats is the alternate form
  end
  mesh.end_shape
  mesh # our work is done here, return DA MESH! -)
end

def key_pressed
  case key
  when '1', '2'
    @color_map = key.to_i % 2 # images.size for more than two
    displace.set('colorMap', images[color_map])
  else
    puts format('key pressed: %s', key)
  end # cycle through color_maps (set variable and set color_map in PShader)
end

def settings
  size(1280, 720, P3D) # use the P3D OpenGL renderer
end
