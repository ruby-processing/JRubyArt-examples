# An image is recreated from its individual component colors.
# The many colors of the image are created through modulating the
# red, green, and blue values. This is an exageration of an LCD display.

def setup
  sketch_title 'Read Color'
  no_stroke
  background 0
  c = load_image 'cait.jpg'
  xoff, yoff = 0, 0
  p = 2
  pix = p * 3
  (c.width * c.height).times do |i|
    pixel = c.pixels[i]
    fill red(pixel), 0, 0
    rect xoff, yoff, p, pix
    fill 0, green(pixel), 0
    rect xoff + p, yoff, p, pix
    fill 0, 0, blue(pixel)
    rect xoff + p * 2, yoff, p, pix
    xoff += pix
    next unless xoff >= (width - pix)
    xoff = 0
    yoff += pix
  end
end

def settings
  size 200, 200
end
