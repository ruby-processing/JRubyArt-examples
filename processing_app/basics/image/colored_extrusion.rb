# Extrusion.
#
# Move the cursor over the image to alter its position. Click and press
# the mouse to zoom and set the density of the matrix by typing numbers 1-5.
# This program displays a series of lines with their heights corresponding to
# a color value read from an image.

def setup
  sketch_title 'Colored Extrusion'
  no_fill
  stroke 255
  @nmx = 0.0
  @nmy = 0.0
  @sval = 1.0
  @res = 5
  @img = load_image(data_path('ystone08.jpg'))
  @img_pixels = []
  (0...@img.height).each do |y|
    @img_pixels << []
    (0...@img.width).each do |x|
      @img_pixels.last << @img.get(y, x)
    end
  end
end

def draw
  background 0
  @nmx += (mouse_x - @nmx) / 20
  @nmy += (mouse_y - @nmy) / 20
  if mouse_pressed?
    @sval += 0.005
  else
    @sval -= 0.01
  end
  @sval = @sval.clamp(1.0, 2.5)
  translate width / 2 + @nmx * @sval - 100, height / 2 + @nmy * @sval - 200, -50
  scale @sval
  rotate_z PI / 9 - @sval + 1
  rotate_x PI / @sval / 8 - 0.125
  rotate_y @sval / 8 - 0.125
  translate -width / 2, -height / 2
  (0...@img.height).step(@res) do |y|
    (0...@img.width).step(@res) do |x|
      rr = red @img_pixels[y][x]
      gg = green @img_pixels[y][x]
      bb = blue @img_pixels[y][x]
      tt = rr + gg + bb
      stroke rr, gg, gg
      line y, x, tt / 10 - 20, y, x, tt / 10
    end
  end
end

def key_pressed
  k = key.to_i
  @res = k if (1..5).include? k
end

def settings
  size 640, 360, P3D
end
