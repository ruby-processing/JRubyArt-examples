#-------------------------------------------------------------
# Display endless moving background using a tile texture.
# Contributed by martiSteiger
#-------------------------------------------------------------

attr_reader :tile_texture, :tile_shader, :time0

def settings
  size(640, 480, P2D)
end

def setup
  sketch_title 'Infinite Tiling'
  texture_wrap(REPEAT)
  @tile_texture = load_image(data_path('penrose.jpg'))
  load_tile_shader
  @time0 = Time.now
end

def load_tile_shader  
  @tile_shader = load_shader(data_path('scroller.glsl'))
  tile_shader.set('resolution', width.to_f, height.to_f)  
  tile_shader.set('tileImage', tile_texture)
end

def draw
  mil = (Time.now - time0).to_f
  tile_shader.set('time', mil)
  shader(tile_shader)                    
  rect(0, 0, width, height)
end