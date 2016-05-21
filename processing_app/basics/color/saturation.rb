# Saturation is the strength or purity of the color and represents the
# amount of gray in proportion to the hue. A "saturated" color is pure
# and an "unsaturated" color has a large percentage of gray.
# Move the cursor vertically over each bar to alter its saturation.
attr_reader :bar_width, :saturation

def setup
  sketch_title 'Saturation'
  no_stroke
  @bar_width = 20
  @saturation = Array.new(width / bar_width, 0)
end

def draw
  j = 0
  (1...width).step(bar_width) do |i|
    saturation[j] = mouse_y if (i..i + bar_width).include? mouse_x
    fill hsb_color(norm(i, 0, 360), norm(saturation[j], 0, 360), 0.75)
    rect i, 0, bar_width, height
    j += 1
  end
end

def settings
  size 640, 360, FX2D
end
