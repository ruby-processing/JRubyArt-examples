load_library :hype

HYPE = %w[H HDrawablePool HRect].freeze
EXTENDED = %w[behavior.HOscillator colorist.HColorPool layout.HGridLayout].freeze
hype_format = 'hype.%s'
hype_extended_format = 'hype.extended.%s'
HYPE.each { |klass| java_import format(hype_format, klass) }
EXTENDED.each { |klass| java_import format(hype_extended_format, klass) }
PALETTE = %w[#FFFFFF #F7F7F7 #ECECEC #333333 #0095A8 #00616F #FF3300 #FF6600].freeze
attr_reader :img, :pool, :xo, :ao, :wo, :ro, :zo

def setup
  sketch_title 'Oscillator'
  H.init(self)
  H.background(color('#242424'))
  @pool = HDrawablePool.new(90)
  layout = HGridLayout.new
                      .start_loc(9, height / 2)
                      .spacing(7, 0)
                      .cols(90)
  pool.auto_add_to_stage
      .add(HRect.new(6).rounding(10).anchor_at(H::CENTER).no_stroke)
      .colorist(HColorPool.new(web_to_color_array(PALETTE)))
      .layout(layout)
      .on_create do |obj|
        i = pool.current_index
        HOscillator.new
                   .target(obj)
                   .property(H::HEIGHT)
                   .range(6, 200)
                   .speed(1)
                   .freq(3)
                   .current_step(i * 3)
                   .waveform(H::SAW)
        end
  .request_all
end

def draw
  H.draw_stage
end

def settings
  size 640, 640
end
