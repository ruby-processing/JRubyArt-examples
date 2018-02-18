load_libraries :hemesh
java_import 'wblut.processing.WB_Render'
java_import 'wblut.hemesh.HEC_IsoSurface'
java_import 'wblut.hemesh.HE_Mesh'
java_import 'wblut.hemesh.HEM_Smooth'

RES ||= 20
attr_reader :mesh, :inv_mesh, :render

def setup
  sketch_title 'Twin Iso'
  ArcBall.init(self)
  values = [] # build a multi-dimensional array in ruby
  (0..RES).each do |i| # the inclusive range is intentional here
    valu = []
    (0..RES).each do |j|
      val = []
      (0..RES).each do |k|
        val << 2.1 * noise(0.35 * i, 0.35 * j, 0.35 * k)
      end
      valu << val
    end
    values << valu
  end
  creator = HEC_IsoSurface.new.tap do |surf|
    surf.set_resolution(RES, RES, RES) # number of cells in x,y,z direction
    surf.set_size(400.0 / RES, 400.0 / RES, 400.0 / RES) # cell size
    # JRuby requires a bit of help to determine correct 'java args', particulary with
    # overloaded arrays args as seen below. Note we are saying we have an 'array' of
    # 'float array' here, where the values can also be double[][][].
    java_values = values.to_java(Java::float[][]) # pre-coerce values to java
    surf.set_values(java_values)               # the grid points
    surf.set_isolevel(1)   # isolevel to mesh
    surf.set_invert(false) # invert mesh
    surf.set_boundary(100) # value of isoFunction outside grid
    # use creator.clear_boundary to set boundary values to "no value".
    # A boundary value of "no value" results in an open mesh
  end
  @mesh = HE_Mesh.new(creator)
  # mesh.modify(HEM_Smooth.new.set_iterations(10).setAutoRescale(true))
  creator.set_invert(true)
  @inv_mesh = HE_Mesh.new(creator)
  inv_mesh.modify(HEM_Smooth.new.set_iterations(10).set_auto_rescale(true))
  @render = WB_Render.new(self)
end

def settings
  size 800, 800, P3D
  smooth(8)
end

def draw
  background(200)
  lights
  define_lights
  no_stroke
  fill(255, 0, 0)
  render.draw_faces(inv_mesh)
  stroke(0)
  render.draw_edges(mesh)
  stroke(255, 0, 0, 80)
  render.draw_edges(inv_mesh)
end

def define_lights
  ambient(80, 80, 80)
  ambient_light(80, 80, 80)
  point_light(30, 30, 30, 0, 0, 1)
  directional_light(40, 40, 50, 0, 0, 1)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, 0.5, PI / 2, 2)
end
