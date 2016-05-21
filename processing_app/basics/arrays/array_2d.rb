# Demonstrates the syntax for creating a two-dimensional (2D) array in ruby
# Values in a 2D array are accessed through two index values.
# 2D arrays are useful for storing images. In this example, each dot
# is colored in relation to its distance from the center of the image.

attr_reader :distances

def setup
  sketch_title 'Array 2D'
  @distances = Array.new(width) { Array.new(height) }
  stroke_weight 2
  max_distance = dist(width / 2, height / 2, width, height)
  width.times do |x|
    height.times do |y|
      distance = dist(width / 2, height / 2, x, y)
      distances[x][y] = distance / max_distance * 255
    end
  end
end

def draw
  background 0
  x = 0
  while x < distances.length
    y = 0
    while y < distances[x].length
      stroke distances[x][y]
      point x, y
      y += 2
    end
    x += 2
  end
end

def settings
  size 640, 360
end
