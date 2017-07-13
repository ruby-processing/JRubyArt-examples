# Talma Quality, Landscape 18 Palette
INCH = 84
STRPE = INCH * 3

def settings
  size(3984, 3000) # 46-48" x 36" at 84 DPI
  no_smooth #
end

def setup
  sketch_title 'Plaid'
  background(color('#000500')) # Black Feather
  no_stroke # Draw vertical stripes every three inches.
  fill(color('#0D644C')) # Malachite
  0.step(by: STRPE, to: width) do |x|
    rect(x, 0, INCH, height) # one inch wide, full-height stripes
  end
  # Draw stripes every three inches along the height.
  fill(color('#B9B34B')) # Black & Gold
  0.step(by: STRPE, to: height) do |y|
    # For each value of y, draw five stripes, at:
    # y, y + 21, y + 42, y + 63, and y + 84.
    5.times do |i|
      rect(0, y + i * 21, width, 10)
    end
  end
  # Combine the two loops (using JRubyArt grid) to draw a different color where
  # the horizontal and vertical stripes intersect.
  fill(color('#6A8E51')) # Peridot
  grid(width, height, STRPE, STRPE) do |x, y|
    5.times do |i|
      rect(x, y + i * 21, INCH, 10)
    end
  end
  save(data_path('plaid.png'))
end
