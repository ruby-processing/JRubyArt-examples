load_library 'hemesh'

java_import 'wblut.processing.WB_Render3D'
java_import 'wblut.geom.WB_Point'
java_import 'wblut.geom.WB_RandomOnSphere'
include_package 'wblut.hemesh'

attr_reader :mesh, :render, :points

def setup
  sketch_title 'Voronoi On Sphere'
  ArcBall.init(self)
  rs = WB_RandomOnSphere.new
  creator = HEC_ConvexHull.new
  num = 500
  @points = (0...num).map { rs.next_point.mul_self(400.0) }
  creator.set_points(points)
  creator.set_n(num)
  imesh = HE_Mesh.new(creator)
  @mesh = HE_Mesh.new(HEC_Dual.new(imesh).set_fix_non_planar_faces(false))
  ext = HEM_Extrude.new.set_distance(0).set_chamfer(5).set_relative(false)
  mesh.modify(ext)
  mesh.get_selection('extruded').modify(HEM_Extrude.new.set_distance(-20))
  @render = WB_Render3D.new(self)
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  stroke(0)
  render.draw_edges(mesh)
  points.each { |point| render.draw_point(point) }
  no_stroke
  render.draw_faces(mesh)
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
