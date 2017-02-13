# Divan Quality, Spectrum 2 Palette
def settings
  size(2400, 6372)
  no_smooth
end

def setup
  sketch_title 'SVG Input'
  background(color('#696774')) # Reflector
  # load an SVG from the data/ directory
  s = load_shape(data_path('circles.svg'))
  # draw 10 copies of the shape, with random sizes and locations
  10.times do
    scale = rand(0.5..2.0) # scale factor, from half to double the original size
    # draw the shape at a random location, scaled according the random scale factor
    shape(s, rand(width), rand(height), s.width * scale, s.height * scale)
  end
  save(data_path('random.png'))
end
