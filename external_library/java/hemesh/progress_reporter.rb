load_library :hemesh
# namespace for hemesh java classes
module WBlut
  java_import 'wblut.processing.WB_Render'
  java_import 'wblut.core.WB_ProgressReporter'
  include_package 'wblut.hemesh'
end

attr_reader :mesh, :render, :pr
def settings
  size(1000, 1000, P3D)
  smooth(8)
end

def setup
  sketch_title 'Progress Reporter'
  ArcBall.init(self)
  @pr= WBlut::WB_ProgressReporter.new(5) # maximum depth of reporting
  pr.start
  create_mesh
  @render= WBlut::WB_Render.new(self)
end

def draw
  background(120)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  fill(255)
  no_stroke
  render.draw_faces(mesh)
  stroke(0)
  render.draw_edges(mesh)
end


def create_mesh
  creator= WBlut::HEC_Geodesic.new.setC(2).setB(2).set_radius(300)
  @mesh= WBlut::HE_Mesh.new(creator)
  mesh.add(WBlut::HE_Mesh.new(
    WBlut::HEC_Grid.new(10, 10, 700, 700).set_center(0, 0, -350))
  )
  modifier= WBlut::HEM_Lattice.new
  modifier.set_width(10) # desired width of struts
  modifier.set_depth(10) # depth of struts
  # treat edges sharper than this angle as hard edges
  modifier.set_threshold_angle(1.5 * HALF_PI)
 # try to fuse planar adjacent planar faces created by the extrude
  modifier.set_fuse(true)
   # threshold angle to be considered coplanar
  modifier.set_fuse_angle(0.1 * HALF_PI)
  sel= WBlut::HE_Selection.select_random_faces(mesh, 0.4)
  sel.modify(modifier)
  mesh.smooth(2)
end

def stop
 pr.interrupt
 super.stop
end
