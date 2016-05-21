# GLSL version of Conway's game of life, ported from GLSL sandbox:
# http://glsl.heroku.com/e/207.3
# Exemplifies the use of the ppixels uniform in the shader, that gives
# access to the pixels of the previous frame.
attr_accessor :pg, :conway, :time

def setup
  sketch_title 'Conway'
  @pg = createGraphics(400, 400, P2D)
  pg.no_smooth
  # @conway = load_shader('conway.glsl') # sketch needs --noruby flag to run
  # @conway = load_shader(File.absolute_path('data/conway.glsl')) # no flag required
  @conway = load_shader(data_path('conway.glsl')) # no flag required
  conway.set('resolution', width.to_f, height.to_f)
  @time = Time.now
end

def draw
  conway.set('time', time.usec / 1000.0)
  xm = map1d(mouse_x, (0..width), (0..1.0))
  ym = map1d(mouse_y, (0..height), (1.0..0))
  conway.set('mouse', xm, ym)
  pg.begin_draw
  pg.background(0)
  pg.shader(conway)
  pg.rect(0, 0, pg.width, pg.height)
  pg.end_draw
  image(pg, 0, 0, width, height)
end

def settings
  size(400, 400, P2D)
end
