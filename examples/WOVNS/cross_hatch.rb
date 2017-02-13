# Divan Quality, Landscape 1 Palette
# This draws a cross-hatch pattern, i.e. a grid of cells, each of which contains
# multiple lines. The lines in each cell alternate between horizontal and vertical.

# the number of stripes to draw in each cell of the grid
NUM_STRIPES = 5

def settings
  size(2400, 6372) # 13.5" x 36", 177 DPI
  no_smooth
end

def setup
  sketch_title 'Cross Hatch'
  background(color('#050406')) # Black Satin
  stroke(color('#C2C2BF')) # Pearl
  strokeWeight(10) # draw lines 10 pixels thick
  # the width and height of each cell of the grid
  w = width / 18
  h = height / 48
  # the distance between stripes
  w2 = w / NUM_STRIPES
  h2 = h / NUM_STRIPES
  grid(w, h) do |col, row|
    (0..NUM_STRIPES).each do |i|
      if (row + col).even?
        # horizontal lines
        line(w * col + w2 / 2, h * row + i * h2 + h2 / 2,
        w * (col + 1) - w2 / 2, h * row + i * h2 + h2 / 2)
      else
        # vertical lines
        line(w * col + i * w2 + w2 / 2, h * row + h2 / 2,
        w * col + i * w2 + w2 / 2, h * (row + 1) - h2 / 2)
      end
    end
  end
  save(data_path('hatch.png'))
end
