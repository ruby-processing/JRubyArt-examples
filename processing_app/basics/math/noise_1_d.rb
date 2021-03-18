# Noise1D.
#
# Using 1D SimplexNoise2 to assign location.
DELTA = 0.01
attr_reader :xoff

def setup
  sketch_title 'Noise 1D'
  @xoff = 0
  background 0
  no_stroke
end

def draw
  fill 0, 10
  rect 0, 0, width, height
  n = noise(xoff) * width / 2.0
  @xoff += DELTA
  fill 200
  ellipse n, height / 2, 64, 64
end

def settings
  size 640, 360
end
