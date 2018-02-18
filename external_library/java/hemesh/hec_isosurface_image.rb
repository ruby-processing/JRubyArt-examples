load_library :hemesh
include_package 'wblut.hemesh'
java_import 'wblut.processing.WB_Render'

attr_reader :mesh, :render

def settings
  size(1000, 1000, P3D)
  smooth(8)
end

def setup
  sketch_title 'HEC_Isosurface_Image example'
  ArcBall.init(self)
  format_string = '/square-%03d.png' # format up to 3 leading zeroes
  images = (1..360).map { |index| data_path(format(format_string, index)) }
  creator = HEC_IsoSurface.new.tap do |iso|
    iso.set_size(8, 8, 8)
    iso.set_values(images.to_java(:string), self, 64, 64, 64)
    iso.set_isolevel(128)
    iso.set_invert(false)
    iso.set_boundary(-20_000)
    iso.set_gamma(0.3)
  end
  @mesh = HE_Mesh.new(creator)
  @render = WB_Render.new(self)
end

def draw
  background(55)
  lights
  no_stroke
  render.draw_faces(mesh)
  stroke(0)
  render.draw_edges(mesh)
end

def key_pressed
  return unless key == 's'
  save_frame(data_path('example.png'))
end
