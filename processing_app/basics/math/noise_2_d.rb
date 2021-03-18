# Noise2D
# after Daniel Shiffman.
# NB: SimplexNoise is in range -1.0 to 1.0
# Using 2D noise to create simple texture.
DELTA = 0.01
attr_reader :xoff, :yoff

def setup
  sketch_title 'Noise 2D'
end

def draw
  background 0
  load_pixels
  @xoff = 0.0
  (0...width).each do |x|
    @xoff += DELTA
    @yoff = 0.0
    (0...height).each do |y|
      @yoff += DELTA
      bright = (noise(xoff, yoff) + 1) * 128
      pixels[x + y * width] = color(bright)
    end
  end
  update_pixels
end

def settings
  size 640, 360
end
