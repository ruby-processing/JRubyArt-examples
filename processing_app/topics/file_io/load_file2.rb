
# LoadFile 1
#
# Loads a text file that contains two numbers separated by a tab ('\t'). A new
# pair of numbers is loaded each frame and used to draw a point on the screen.
#

attr_reader :points, :count
X, Y = 0, 1

def setup
  sketch_title 'Load File1'
  background(0)
  stroke(255)
  stroke_weight 3
  frame_rate(12)
  @count = 0
  @points = []
  # The use of vanilla processing load_strings convenience method is
  # of dubious value in ruby processing when you can do this
  mult = -> (a.to_i, b) { a * b }
  mult2 = mult.curry.call(2)
  File.open('data/positions.txt').each_line do |line|
    points << line.split(/\t/).map!(&mult2)
  end
end

def draw
  return unless count < points.size
  point(points[count][X], points[count][Y])
  @count += 1
end

def settings
  size(200, 200)
end
