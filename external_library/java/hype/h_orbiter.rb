# encoding: utf-8
load_library :hype
include_package 'hype'
# namespace for imported classes
module Hype
  java_import 'hype.extended.behavior.HOrbiter3D'
  java_import 'hype.extended.colorist.HColorPool'
end

attr_reader :colors, :pool
PALETTE = %w(#333333 #494949 #5F5F5F #707070 #7D7D7D #888888 #949494 #A2A2A2 #B1B1B1 #C3C3C3 #D6D6D6 #EBEBEB #FFFFFF).freeze

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title('HOrbiter Example')
  H.init(self)
  H.background(color('#242424'))
  H.use3D(true)
  H.add(HSphere.new)
   .size(200)
   .stroke_weight(0)
   .no_stroke
   .fill(color('#666666'))
   .anchor_at(H::CENTER)
   .loc(width / 2, height / 2)
  @pool = HDrawablePool.new(100)
  pool.autoAddToStage
      .add(HSphere.new)
      .colorist(Hype::HColorPool.new(web_to_color_array(PALETTE)).fill_only)
      .on_create do |obj|
        ran_size = 10 + (rand(0..3) * 7)
        obj.size(ran_size).stroke_weight(0).no_stroke.anchor_at(H::CENTER)
        orb = Hype::HOrbiter3D.new(width / 2, height / 2, 0)
                              .target(obj)
                              .z_speed(rand(-1.5..1.5))
                              .y_speed(rand(-0.5..0.5))
                              .radius(195)
                              .z_angle(rand(0..360))
                              .y_angle(rand(0..360))
        obj.extras(HBundle.new.obj('o', orb))
      end
      .request_all
end

def draw
  point_light(100, 0, 0, width / 2, height, 200) # under red light
  point_light(51, 153, 153, width / 2, -50, 150) # over teal light
  # mid light gray light
  point_light(204, 204, 204, width / 2, (height / 2) - 50, 500)
  pool.each do |d|
    obj1 = d.extras
    o = obj1.obj('o')
    o.radius(rand(190..220))
  end
  sphere_detail(20)
  H.draw_stage
end
