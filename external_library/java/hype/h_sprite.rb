#encoding: utf-8
load_library :hype
include_package 'hype'
EXTENDED = %w[
  colorist.HColorPool behavior.HOscillator behavior.HOrbiter3D
].freeze
hype_extended_format = 'hype.extended.%s'
EXTENDED.each { |klass| java_import format(hype_extended_format, klass) }

PALETTE = %w(#FFFFFF #F7F7F7 #ECECEC #CCCCCC #999999 #666666 #4D4D4D #333333 #FF3300 #FF6600).freeze
attr_reader :pool,

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'Sprite'
  H.init(self)
  H.background(color('#242424'))
  H.use3D(true)
  @pool = HDrawablePool.new(400)
  pool.auto_add_to_stage
      .add(HSprite.new(50,50).texture(HImage.new(data_path('tex1.png'))))
      .add(HSprite.new(50,50).texture(HImage.new(data_path('tex2.png'))))
      .add(HSprite.new(50,50).texture(HImage.new(data_path('tex3.png'))))
      .colorist(HColorPool.new(web_to_color_array(PALETTE)).fill_only)
      .on_create do |obj|
    i = pool.current_index
    obj.anchorAt(H::CENTER).rotation(45)
    HOrbiter3D.new(width / 2, height / 2, 0)
                    .target(obj)
                    .radius(225)
                    .ySpeed(1)
                    .zSpeed(1)
                    .yAngle((i + 1) *2)
                    .zAngle((i + 1) *3)
    HOscillator.new
               .target(obj)
               .property(H::SCALE)
               .range(0.1, 1.0)
               .speed(0.1)
               .freq(10)
    HOscillator.new
               .target(obj)
               .property(H::ROTATION)
               .range(-180, 180)
               .speed(0.1)
               .freq(10)
               .current_step(i)
  end.request_all
end

def draw
  H.draw_stage
  sketch_title(format('HSprite %d fps', frame_rate))
end
