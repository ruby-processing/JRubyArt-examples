load_library :hype
include_package 'hype'
java_import 'hype.extended.layout.HGridLayout'
java_import 'hype.extended.behavior.HAttractor'

attr_reader :a, :r, :hf

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'Attractor'
  H.init(self)
  H.background(color('#242424'))
  H.use3D(true)
  @r = 0
  @a = 0
  ha = HAttractor.new(320, 320, 100, 260).debug_mode(true)
  @hf = ha.get_force(0)
  pool = HDrawablePool.new(576)
  pool.auto_add_to_stage
      .add(HBox.new.depth(10).width(10).height(10))
      .layout(
        HGridLayout.new
                   .start_x(26)
                   .start_y(26)
                   .start_z(0)
                   .spacing(26, 26, 26)
                   .cols(24)
                   .rows(24)
      )
      .on_create do |obj|
        obj.no_stroke
           .fill(color('#ECECEC'))
           .anchor_at(H::CENTER)
        ha.add_target(obj, 20, 0.5)
      end
      .request_all
end

def draw
  lights
  x = 320 + cos(a.radians) * 200
  y = 320 + sin(a.radians) * 200
  @a += 1.0 / 1.4
  hf.loc(x, y, 100)
  translate(width / 2, height / 2)
  rotate_y(r.radians)
  translate(-width / 2, -height / 2)
  @r += 0.4
  H.draw_stage
end
