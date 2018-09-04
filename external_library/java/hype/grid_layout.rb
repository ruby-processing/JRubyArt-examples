# encoding: utf-8
load_library :hype

%w[H HDrawablePool HBox].freeze.each do |klass|
  java_import "hype.#{klass}"
end

%w[behavior.HOscillator colorist.HColorPool layout.HGridLayout].freeze.each do |klass|
  java_import "hype.extended.#{klass}"
end

attr_reader :pool, :osc, :scale, :r

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'Grid Layout'
  H.init(self)
  H.background(color('#242424'))
  H.use3D(true)
  @r = 0
  @scale = 0
  @osc = HOscillator.new.range(0.2, 2.5).speed(10).freq(2)
  @pool = HDrawablePool.new(125)
  pool.auto_add_to_stage
      .add(HBox.new.depth(25).width(25).height(25))
      .layout(
        HGridLayout.new
                   .start_x(180)
                   .start_y(180)
                   .start_z(-140)
                   .spacing(70, 70, 70)
                   .cols(5)
                   .rows(5)
      )
      .request_all
end

def draw
  lights
  translate(width / 2, height / 2)
  rotate_y(r.radians)
  translate(-width / 2, -height / 2)
  @r += 0.3
  i = 0
  pool.each do |d|
    osc.current_step(frame_count + i * 3).next_raw
    @scale = osc.curr
    d.depth(25 * scale).width(25 * scale).height(25 * scale)
    i += 1
  end
  H.draw_stage
end
