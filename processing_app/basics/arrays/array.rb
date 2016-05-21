# An array is a list of data. Each piece of data in an array
# is identified by an index number representing its position in
# the array. Arrays are zero based, which means that the first
# element in the array is [0], the second element is [1], and so on.
# In this example, an array named "coswave" is created using ruby
# map with the cosine values. This data is displayed three
# separate ways on the screen.
attr_reader :coswave

def setup
  sketch_title 'Array'
  @coswave = (0..width).map do |i|    
    Math.cos(map1d(i, (0..width), (0..PI))).abs
  end 
end

def draw
  coswave.each_with_index do |val, i|
    stroke(val * 255)
    line(i, 0, i, height / 3)
    stroke(val * 255 / 4)
    line(i, height / 3, i, height / 3 * 2)
    stroke(255 - val * 255)
    line(i, height / 3 * 2, i, height)
  end
end

def settings
  size 640, 360
end
