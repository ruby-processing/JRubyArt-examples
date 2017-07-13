load_library :hemesh
include_package 'wblut.math'
include_package 'wblut.processing'
include_package 'wblut.core'
include_package 'wblut.hemesh'
include_package 'wblut.geom'

attr_reader :mesh, :render, :old_mesh

def settings
  size(1000, 1000, P3D)
  smooth(8)
end

def setup
  sketch_title 'Simplify'
  create_mesh
  @render = WB_Render.new(self)
  text_align(CENTER)
  text_size(16)
end

def draw
  background(120)
  translate(width / 2, height / 2)
  setup_lights
  fill(255)
  no_stroke
  text('Click to reduce number of faces by 10%.', 0, 470);
  render.draw_faces(mesh)
  stroke(255, 0, 0, 100)
  render.draw_edges(old_mesh)
  stroke(0)
  render.draw_edges(mesh)
end

def create_mesh
  creator = HEC_Beethoven.new
                         .set_scale(10)
                         .set_zaxis(0, -1, 0)
  @mesh = HE_Mesh.new(creator)
  @old_mesh = mesh.get
end

def setup_lights
  lights
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
end

def mouse_pressed
  mesh.simplify(HES_TriDec.new.set_goal(0.9))
end
