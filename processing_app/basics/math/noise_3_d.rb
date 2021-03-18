# Noise3D.
#
# Using 3D noise to create simple animated texture.
# Here, the third dimension ('z') is treated as time.
# SimplexNoise is in range -1.0 to 1.0
DELTA = 0.01
DELTA_TIME = 0.02

attr_reader :zoff

def setup
  sketch_title 'Noise 3D'
  frame_rate 30
  @zoff = 0.0
end

def draw
  background 0
  load_pixels
  xoff = 0.0
  (0...width).each do |x|
    xoff += DELTA
    yoff = 0.0
    (0...height).each do |y|
      yoff += DELTA
      bright = (noise(xoff, yoff, zoff) + 1) * 128
      pixels[x + y * width] = color(bright, bright, bright)
    end
  end
  update_pixels
  @zoff += DELTA_TIME
end

def settings
  size 640, 360
end
