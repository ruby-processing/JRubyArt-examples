require 'toxiclibs'

# by Martin Prout.
# Using noise to create simple texture.
# control parameter with mouse
DELTA = 0.02

def setup
  sketch_title 'Noisy Texture'
end

def draw
  background 0
  load_pixels
  x_val = map1d(mouse_x, 0..width, 1..10)
  grid(width, height) do |x, y|
    bright = (
      Toxi::SimplexNoise.noise(x * DELTA / x_val, y * DELTA / x_val) + 1
      ) * 128
    pixels[x + y * width] = color(bright)
  end
  update_pixels
end

def settings
  size 640, 360
end
