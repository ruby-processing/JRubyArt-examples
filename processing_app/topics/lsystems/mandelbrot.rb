# frozen_string_literal: true

# The Mandelbrot Set
# by Daniel Shiffman.
#
# Simple rendering of the Mandelbrot set.

# Maximum number of iterations for each poon the complex plane
MAXITERATIONS = 100

def setup
  sketch_title 'Mandelbrot'
  background(255)

  # Establish a range of values on the complex plane
  # A different range will allow us to "zoom" in or out on the fractal

  # It all starts with the width, try higher or lower values
  w = 4
  h = (w * height) / width

  # Start at negative half the width and height
  xmin = -w / 2.0
  ymin = -h / 2.0

  # Make sure we can write to the pixels[] array.
  # Only need to do this once since we don't do any other drawing.
  load_pixels

  # x goes from xmin to xmax
  xmax = xmin + w
  # y goes from ymin to ymax
  ymax = ymin + h

  # Calculate amount we increment x,y for each pixel
  dx = (xmax - xmin) / width
  dy = (ymax - ymin) / height

  # Start y
  y = ymin
  (0...height).each do |j|
    # Start x
    x = xmin
    (0...width).each do |i|
      # Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
      a = x
      b = y
      n = 0
      while n < MAXITERATIONS
        aa = a * a
        bb = b * b
        twoab = 2.0 * a * b
        a = aa - bb + x
        b = twoab + y
        # Infinity in our finite world is simple, let's just consider it 16
        break if dist(aa, bb, 0, 0) > 4.0 # Bail

        n += 1
      end

      # We color each pixel based on how long it takes to get to infinity
      # If we never got there, let's pick the color black
      if n == MAXITERATIONS
        pixels[i + j * width] = color(0)
      else
        # Gosh, we could make fancy colors here if we wanted
        norm = map1d(n, 0..MAXITERATIONS, 0..1.0)
        pixels[i + j * width] = color(map1d(sqrt(norm), 0..1.0, 0..255))
      end
      x += dx
    end
    y += dy
  end
  update_pixels
  no_loop
end

def settings
  size(640, 360)
end
