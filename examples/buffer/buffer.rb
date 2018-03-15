# Using the JRubyArt convenience method buffer to create_graphics you
# do not need to begin_draw, end_draw since the buffer method wraps them
# around user provided block. In practice you probably won't use this method
# much, because you should avoid creating offscreen buffers in the draw loop.
# This sketch is OK because you create the offscreen graphics in the setup.

attr_reader :pg

def setup
  sketch_title 'Create graphics using :buffer'
  @pg = buffer(60, 70, P2D) do |buf|
    buf.background 51
    buf.no_fill
    buf.stroke 255
    buf.rect 0, 0, 59, 69
  end
end

def draw
  fill 0, 12
  rect 0, 0, width, height
  image pg, mouse_x - 60, mouse_y - 70
end

def settings
  size 640, 380, P2D
end
