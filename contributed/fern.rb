# The Fern Fractal
# by Luis Correia

attr_reader :bnds

def setup
  sketch_title 'Fern'
  @bnds = Boundary.new(0, width)
  no_loop
  puts 'Be patient. This takes about 10 seconds to render.'
end

def draw
  background 0
  load_pixels
  x0, y0 = 0.0, 0.0
  x, y, r = 0.0, 0.0, 0.0
  i, j = 0, 0
  max_iterations = 200_000
  max_iterations.times do
    r = rand(0..100.0)
    if r <= 1
      x = 0.0
      y = 0.16 * y0
    elsif r <= 7
      x = 0.2 * x0 - 0.26 * y0
      y = 0.23 * x0 + 0.22 * y0
    elsif r <= 14
      x = -0.15 * x0 + 0.28 * y0
      y = 0.26 * x0 + 0.24 * y0
    else
      x = 0.85 * x0 + 0.04 * y0
      y = -0.004 * x0 + 0.85 * y0 + 1.6
    end
    i = height - (y * 45).to_i
    j = width / 2 + (x * 45).to_i
    pixels[i * height + j] += 2_560 if bnds.include?(i) && bnds.include?(j)
    x0, y0 = x, y
  end
  update_pixels
end

# Abstract bnds checking to this
# lightweight class
#

Boundary = Struct.new(:lower, :upper) do
  def include?(x)
    (lower...upper).cover? x
  end
end

def settings
  size 500, 500
end
