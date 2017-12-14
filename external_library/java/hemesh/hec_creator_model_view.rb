load_library :hemesh
java_import 'wblut.processing.WB_Render'
include_package 'wblut.hemesh'

attr_reader :meshes, :render, :mesh

def setup
  sketch_title 'HEC Creator Model View'
  ArcBall.init(self)
  creator = HEC_Icosahedron.new
  # the default mode ignores Processing transforms
  # creator.set_edge(40).setToWorldview # ignore Processing transforms
  creator.set_edge(40).setToModelview(self) # use Processing transforms
  @meshes = (0..27).map do |idx|
    push_matrix
    rotate_z(idx * PI / 6.0)
    translate(200, 0, -260 + 20 * idx)
    scale(idx * 0.06)
    @mesh = HE_Mesh.new(creator)
    pop_matrix
    mesh
  end
  @render = WB_Render.new(self)
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  meshes.each do |mesh|
    stroke(0)
    render.draw_edges(mesh)
    no_stroke
    render.draw_faces(mesh)
  end
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
