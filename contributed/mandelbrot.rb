# Mandelbrot Set example
# by Jordan Scales (http://jordanscales.com)
# Modified to use map1d (instead of map), and somewhat
# optimized (update_pixels instead of set, and hypot for abs)
# no need to loop

def setup
  sketch_title 'Mandelbrot'
  load_pixels
  no_loop
end

# main drawing method
def draw
  (0...900).each do |x|
    (0...600).each do |y|
      c = Complex.new(map1d(x, (0...900), (-3..1.5)), map1d(y, (0...600), (-1.5..1.5)))
      # mandel will return 0 to 20 (20 is strong)
      #   map this to 0, 255 (and flip it)
      pixels[x + y * 900] = color(255 - map1d(mandel(c, 20), (0..20), (0..255)).to_i)
    end
  end
  update_pixels
end

# calculates the "accuracy" of a given point in the mandelbrot set
#    : how many iterations the number survives without becoming chaotic
def mandel(z, max = 10)
  score = 0
  c = z.clone
  while score < max
    # z = z^2 + c
    z.square
    z.add c
    break if z.abs > 2
    score += 1
  end
  score
end

# rolled my own Complex class
# including only the functionality I need (abs, square, add, to_s)
#
# Using this class, runs in ~12.5s on my MacBook Air
# compared to ~22s using ruby's Complex struct
class Complex
  attr_accessor :real, :imag

  def initialize(real, imag)
    @real = real
    @imag = imag
  end

  # squares a complex number - overwriting it
  def square
    r = real * real - imag * imag
    i = 2 * real * imag
    @real = r
    @imag = i
  end

  # adds a given complex number
  def add(c)
    @real += c.real
    @imag += c.imag
  end

  # computes the magnitude (HelperMethods dist is a safer version of Math.hypot)
  def abs
    dist(0, 0, real, imag)
  end

  def to_s
    format('(%f+%fi)', real, imag)
  end
end

def settings
  size 900, 600
end
