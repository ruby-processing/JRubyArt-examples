# Noise2D
# after Daniel Shiffman.
# NB: SimplexNoise is in range -1.0 to 1.0
# Using 2D noise to create simple texture.
DELTA = 0.01

def setup
  sketch_title 'Noise 2D'
end

def draw
  background 0
  load_pixels
  grid(width, height) do |x, y|
    pixels[x + y * width] = color((noise(x * DELTA, y * DELTA) + 1) * 128)
  end
  update_pixels
end

def settings
  size 640, 360
end
