load_library :vector_utils

attr_reader :points

def settings
  size 600, 600
  smooth 4
end

def setup
  sketch_title 'Spiral Layout'
  @points = VectorUtil.spiral_layout(
    number: 300,
    radius: 200,
    resolution: 0.3,
    spacing: 0.01,
    inc: 1.15
  )
end

def draw
  background 0
  fill 200, 130, 100
  translate width / 2, height / 2
  points.each do |vec|
    ellipse vec.x, vec.y, 10, 10
  end
end
