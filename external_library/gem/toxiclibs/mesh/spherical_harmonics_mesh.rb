require 'toxiclibs'

#######
# After Paul Bourke see http://paulbourke.net/geometry/sphericalh/
# radius =
# sin(m0*phi)**m1 + cos(m2*phi)**m3 + sin(m4*theta)**m5 + cos(m6*theta)**m7
# where phi = (0..PI) and theta = (0..TWO_PI)
# As implemented by Karsten Schmidt aka toxi/postspectacular
# Mouse-wheel to zoom, drag to rotate, 'r' key for a new random shape
#######

attr_reader :gfx, :mesh, :spherical, :param

def setup
  sketch_title 'Spherical Harmonics Mesh Builder'
  ArcBall.init(self)
  @param = [8, 4, 1, 5, 1, 4, 0, 0] # default function parameters (m0..m7)
  @mesh = spherical_mesh(param)
  @gfx = Gfx::MeshToVBO.new(self) # Mesh to vertex buffer object converter
  no_stroke
  @spherical = gfx.mesh_to_shape(mesh, true) # white
end

def draw
  background(0)
  lights
  shininess(16)
  directional_light(255, 255, 255, 0, -1, 1)
  specular(255)
  shape(spherical)
end

def key_pressed
  case(key) 
  when 'k', 'K'
    @mesh = spherical_mesh(random_parameters.to_java(:float))
   # no_stroke
    @spherical = gfx.mesh_to_colored_shape(mesh, true) # harmonic colors
  end
end

def random_parameters
  (0..8).map { rand(0..8) }
end

def spherical_mesh(param)
  b = SurfaceMeshBuilder.new(SphericalHarmonics.new(param.to_java(:float)))
  b.create_mesh(nil, 80, 60)
end

def settings
  size(1024, 576, P3D)
end
