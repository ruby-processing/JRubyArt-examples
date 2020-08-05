# Sprite (Teddy)
# by James Patterson.
#
# Demonstrates loading and displaying a transparent GIF image.

def setup
  sketch_title 'Sprite'
  @teddy = load_image(data_path('teddy.gif'))
  @xpos, @ypos = width / 2, height / 2
  @drag = 30.0
  frame_rate 60
end

def draw
  background 102
  difx = mouse_x - @xpos - @teddy.width / 2
  if difx.abs > 1.0
    @xpos += difx / @drag
    @xpos = @xpos.clamp(0, width - @teddy.width / 2)
  end
  dify = mouse_y - @ypos - @teddy.height / 2
  if dify.abs > 1.0
    @ypos += dify/@drag
    @ypos = @ypos.clamp(0, height - @teddy.height / 2)
  end
  image @teddy, @xpos, @ypos
end

def settings
  size 200, 200
end
