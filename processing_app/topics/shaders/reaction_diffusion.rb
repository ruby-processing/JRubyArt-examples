attr_reader :shader_grayscott, :shader_render, :pg_src, :pg_dst, :pass

def settings
  size(800, 800, P2D)
end

def setup
  @pass = 0
  @shader_grayscott = load_shader(sketch_path('grayscott2.frag'))
  @shader_render = load_shader(sketch_path('render2.frag'))
  @pg_src = create_texture(width, height)
  @pg_dst = create_texture(width, height)
  # init
  pg_src.begin_draw
  pg_src.background(color(0xFFFF0000))
  pg_src.fill(color(0x0000FFFF))
  pg_src.no_stroke
  pg_src.rect_mode(CENTER)
  pg_src.rect(width / 2, height / 2, 20, 20)
  pg_src.end_draw
  frame_rate(1000)
end

def create_texture(w, h)
  pg = create_graphics(w, h, P2D)
  pg.smooth(0)
  pg.begin_draw
  pg.texture_sampling(2)
  pg.blend_mode(REPLACE)
  pg.clear
  pg.no_stroke
  pg.end_draw
  pg
end

def swap
  @pg_dst, @pg_src = pg_src, pg_dst
end

def reaction_diffusion_pass
  pg_dst.begin_draw
  shader_grayscott.set('dA' , 1.0)
  shader_grayscott.set('dB' , 0.5)
  shader_grayscott.set('feed' , 0.055)
  shader_grayscott.set('kill' , 0.062)
  shader_grayscott.set('dt', 1.0    )
  shader_grayscott.set('wh_rcp', 1.0 / width, 1.0 / height)
  shader_grayscott.set('tex', pg_src)
  pg_dst.shader(shader_grayscott)
  pg_dst.rect_mode(CORNER)
  pg_dst.rect(0, 0, width, height)
  pg_dst.end_draw
  swap
  @pass += 1
end

def draw
  # multipass rendering, ping-pong
  100.times { reaction_diffusion_pass }
  # display result
  shader_render.set('wh_rcp', 1.0 / width, 1.0 / height)
  shader_render.set('tex', pg_src)
  shader(shader_render)
  rect(0, 0, width, height)
  format_string = 'Reaction Diffusion  [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, pass, frame_rate))
end

def key_released
  return unless  key == 's'
  save_frame(data_path('grayscott.jpg'))
end
