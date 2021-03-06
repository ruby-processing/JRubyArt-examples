require 'toxiclibs'
# Noise3D.
#
# Using 3D noise to create simple animated texture.
# Here, the third dimension ('z') is treated as time.
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
  grid(width, height) do |x, y|
    bright = (Toxi::SimplexNoise.noise(x * DELTA, y * DELTA, zoff) + 1) * 128
    # perlin = Toxi::PerlinNoise.new
    # bright = perlin.noise(x * DELTA, y * DELTA, zoff) * 255
    pixels[x + y * width] = color(bright, bright, bright)
  end
  update_pixels
  @zoff += DELTA_TIME
end

def settings
  size 640, 360
end
