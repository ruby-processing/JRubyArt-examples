# encoding: utf-8
load_library :hype
include_package 'hype'
java_import 'hype.extended.layout.HPolarLayout'
java_import 'hype.extended.behavior.HOscillator'
java_import 'hype.extended.colorist.HColorPool'

PALETTE = %w(#FFFFFF #F7F7F7 #ECECEC #CCCCCC #999999 #666666 #4D4D4D #333333 #242424 #202020 #111111 #080808 #000000).freeze
attr_reader :pool, :colors, :box_depth

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'PolarLayout'
  H.init(self)
  H.background(color('#000000'))
  H.use3D(true)
  @ranSeedNum = 1
  @box_depth = 60
  @colors = HColorPool.new(web_to_color_array(PALETTE))
  layout = HPolarLayout.new(0.7, 0.1).offset(width / 2, height / 2)
  @pool = HDrawablePool.new(600)
  pool.auto_add_to_stage
    .add(HBox.new.depth(box_depth).width(box_depth).height(box_depth))
    .layout(layout)
    .on_create do |obj|
      i = pool.current_index
      HOscillator.new.target(obj).property(H::Z).range(-900, 100).speed(1).freq(1).current_step(i)
      HOscillator.new.target(obj).property(H::ROTATION).range(-360, 360).speed(0.05).freq(3).current_step(i)
      HOscillator.new.target(obj).property(H::ROTATIONX).range(-360, 360).speed(0.3).freq(1).current_step(i * 2)
      HOscillator.new.target(obj).property(H::ROTATIONY).range(-360, 360).speed(0.3).freq(1).current_step(i * 2)
      HOscillator.new.target(obj).property(H::ROTATIONZ).range(-360, 360).speed(0.5).freq(1).current_step(i * 2)
    end
    .request_all
end

def draw
  lights
  i = 0
  pool.each do |d|
    d.no_stroke.fill(colors.get_color(i * @ranSeedNum))
    i += 1
  end
  @ranSeedNum += 0.5
  @ranSeedNum = 1 if @ranSeedNum > 300
  H.draw_stage
end