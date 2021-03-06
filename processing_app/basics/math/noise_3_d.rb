# Noise3D.
#
# Using 3D noise to create simple animated texture.
# Here, the third dimension ('z') is treated as time.
# SimplexNoise is in range -1.0 to 1.0
DELTA = 0.01
DELTA_TIME = 0.02

attr_reader :smth, :zoff

def setup
  sketch_title 'Noise 3D'
  frame_rate 30
  @zoff = 0.0
  @smth = false
end

def draw
  background 0
  load_pixels
  grid(width, height) do |x, y|
    if smth
      bright = (SmoothNoise.noise(x * DELTA, y * DELTA, zoff) + 1) * 128
    else
      bright = (noise(x * DELTA, y * DELTA, zoff) + 1) * 128
    end
    pixels[x + y * width] = color(bright, bright, bright)
  end
  update_pixels
  @zoff += DELTA_TIME
end

def settings
  size 640, 360
end

def mouse_pressed
  @smth = !smth
end
