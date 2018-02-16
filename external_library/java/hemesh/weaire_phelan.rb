load_library :hemesh
java_import 'wblut.processing.WB_Render'
java_import 'wblut.hemesh.HEMC_WeairePhelan'
java_import 'wblut.geom.WB_Point'
java_import 'wblut.geom.WB_Vector'

attr_reader :meshes, :render

def setup
  sketch_title 'Weaire Phelan'
  ArcBall.init(self)
  wp = HEMC_WeairePhelan.new
  wp.set_origin(WB_Point.new(0, 0, -100))
  wp.set_extents(WB_Vector.new(400, 400, 400))
  wp.set_number_of_units(2, 2, 2)
  wp.set_scale(150, 150, 150)
  @meshes = wp.create
  @render = WB_Render.new(self)
end

def draw
  background(55)
  scale 1, -1, 1
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  noStroke
  render.draw_faces(meshes)
  stroke(0)
  render.draw_edges(meshes)
end

  def settings
    size(1000, 1000, P3D)
    smooth(8)
  end
