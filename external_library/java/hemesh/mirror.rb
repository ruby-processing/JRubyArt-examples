load_library :hemesh

include_package 'wblut.math'
include_package 'wblut.processing'
include_package 'wblut.core'
include_package 'wblut.hemesh'
include_package 'wblut.geom'

attr_reader :mesh, :render, :plane, :plane2, :plane3, :modifier

def settings
  size(1000, 1000, P3D)
  smooth(8)
end

def setup
  sketch_title 'Half Edge Mirror'
  ArcBall.init(self)
  create_mesh
  @modifier = HEM_Mirror.new
  @plane = WB_Plane.new(0, 0, 0, 0, 1, 1)
  modifier.set_plane(plane)
  modifier.set_offset(0)
  modifier.set_reverse(false)
  mesh.modify(modifier)
  @plane2 = WB_Plane.new(0, 0, 0, 1, -1, 1)
  modifier.set_plane(plane2) #  mirror plane
  mesh.modify(modifier)
  @plane3 = WB_Plane.new(-80, 0, 0, 1, 0, 0)
  modifier.set_plane(plane3) #  mirror plane
  mesh.modify(modifier)
  mesh.validate
  @render = WB_Render.new(self)
end

def draw
  background(120)
  setup_lights
  fill(255)
  no_stroke
  render.draw_faces(mesh)
  no_fill
  stroke(0, 50)
  render.draw_edges(mesh)
  stroke(255, 0, 0)
  render.draw_plane(@plane, 300)
  render.draw_plane(@plane2, 300)
  render.draw_plane(@plane3, 300)
end

def create_mesh
  @mesh = HE_Mesh.new(HEC_Beethoven.new.set_scale(10))
end

def setup_lights
  lights
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
end
