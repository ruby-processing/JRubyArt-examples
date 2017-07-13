load_library :hemesh
java_import 'wblut.processing.WB_Render' # ren
include_package 'wblut.hemesh'
attr_reader :mesh, :render

def setup
  sketch_title 'HES_DooSabin Example'
  ArcBall.init(self)
  create_mesh
  # HEC_Doo_sabin only support closed meshes.
  subdividor = HES_DooSabin.new
                           .set_factors(1.0, 1.0)# Relative importance of edges vs. face. Default (1.0,1.0)
                           .set_absolute(false)# Specify offset relative or absolute
                           .set_distance(50.0)# Specify distance when absolute, will be multiplied with factors
  mesh.subdivide(subdividor, 2)
  @render = WB_Render.new(self)
end

def draw
  background(120)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  fill(255)
  no_stroke
  render.draw_faces(mesh)
  stroke(0)
  render.drawEdges(mesh)
end

def create_mesh
  creator = HEC_Box.new(100, 200, 400, 1, 2, 4)
  @mesh = HE_Mesh.new(creator)
  mesh.modify(HEM_Noise.new.set_distance(20))
end

def settings
  size(800, 800, P3D)
  smooth(8)
end
