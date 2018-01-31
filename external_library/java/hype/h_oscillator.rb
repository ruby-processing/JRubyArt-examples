load_library :hype

HYPE = %w[H HCanvas HDrawablePool HRect].freeze
EXTENDED = %w[
  behavior.HTimer behavior.HOscillator colorist.HPixelColorist
].freeze
hype_format = 'hype.%s'
hype_extended_format = 'hype.extended.%s'
HYPE.each { |klass| java_import format(hype_format, klass) }
EXTENDED.each { |klass| java_import format(hype_extended_format, klass) }

attr_reader :colors, :pool, :xo, :ao, :wo, :ro, :zo

def setup
  sketch_title 'Oscillator'
  H.init(self)
  H.background(color(0xff000000))
  H.use3D(true)
  @colors = HPixelColorist.new(data_path('gradient.jpg'))
  canvas = HCanvas.new(P3D).autoClear(true)
  H.add(canvas)
  @pool = HDrawablePool.new(1_000)
  pool.autoParent(canvas)
  .add(HRect.new.rounding(10))
  .on_create do |obj|
    i = pool.current_index
    obj.no_stroke
    .size(rand(40..80), rand(60..80))
    .loc(rand(width), rand(height))
    .anchorAt(H::CENTER)
    @xo = HOscillator.new
    .target(obj)
    .property(H::X)
    .relative_val(obj.x)
    .range(rand(-10..-5), rand(5..10))
    .speed(rand(0.005..0.2))
    .freq(10)
    .current_step(i)
    @ao = HOscillator.new
    .target(obj)
    .property(H::ALPHA)
    .range(50, 255)
    .speed(rand(0.3..0.9))
    .freq(5)
    .current_step(i)
    @wo = HOscillator.new
    .target(obj)
    .property(H::WIDTH)
    .range(-obj.width, obj.width)
    .speed(rand(0.05..0.2))
    .freq(10)
    .current_step(i)
    @ro = HOscillator.new
    .target(obj)
    .property(H::ROTATION)
    .range(-180, 180)
    .speed(rand(0.005..0.05))
    .freq(10)
    .current_step(i)
    @zo = HOscillator.new
    .target(obj)
    .property(H::Z)
    .range(-400, 400)
    .speed(rand(0.005..0.01))
    .freq(15)
    .current_step(i * 5)
  end
  .onRequest do |obj|
    obj.scale(1).alpha(0).loc(rand(width), rand(height), -rand(200))
    xo.register
    ao.register
    wo.register
    ro.register
    zo.register
  end.onRelease do
    xo.unregister
    ao.unregister
    wo.unregister
    ro.unregister
    zo.unregister
  end
  HTimer.new(50)
  .callback do
    pool.request
  end
end

def draw
  pool.each do |d|
    d.loc(d.x, d.y - rand(0.25..1), d.z)
    d.no_stroke
    d.fill(colors.get_color(d.x, d.y))
    # if the z axis hits this range, change fill to light yellow
    d.fill(color(0xffFFFFCC)) if d.z > -10 && d.z < 10
    pool.release(d) if d.y < -40
  end
  H.draw_stage
end

def settings
  size 640, 640, P3D
end
