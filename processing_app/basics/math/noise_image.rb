
# OpenSimplex has a range -1.0 to 1.0

SCALE = 0.02

def setup
  sketch_title 'Noise Image'
  background(0)
  stroke(255)
  no_fill
end

def draw
  background(0)
  load_pixels
  grid(500, 500) do |x, y|
    col = noise(SCALE * x, SCALE * y) > 0 ? 255 : 0
    pixels[x + width * y] = color(col, 0, 0)
  end
  update_pixels
end

def settings
  size 500, 500
end

def key_pressed
  return unless key == 's'

  save_frame(data_path('noise_image.png'))
end
