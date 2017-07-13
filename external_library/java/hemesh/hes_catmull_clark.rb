load_library :hemesh
java_import 'wblut.processing.WB_Render' # ren
include_package 'wblut.hemesh'
attr_reader :mesh, :render

def setup
  sketch_title 'HES_CatmullClark Example'
  ArcBall.init(self)
  create_mesh
  subdividor = HES_CatmullClark.new
                               .set_keep_boundary(true) # preserve position of vertices on a surface boundary
                               .set_keep_edges(true) # preserve position of vertices on edge of selection (only useful if using subdivideSelected)
  mesh.subdivide(subdividor, 3)
  @render = WB_Render.new(self)
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  fill(255)
  noStroke
  render.draw_faces(mesh)
  stroke(0)
  render.draw_edges(mesh)
end

def create_mesh
  creator = HEC_Cylinder.new
                        .set_facets(6)
                        .set_steps(1)
                        .set_radius(250)
                        .set_height(500)
                        .set_cap(true, false)
  @mesh = HE_Mesh.new(creator)
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
