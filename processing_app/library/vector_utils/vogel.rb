load_library :vector_utils

attr_reader :points

def settings
  size 600, 600
  smooth 4
end

def setup
  sketch_title 'Vogel Layout'
  @points = VectorUtil.vogel_layout(number: 200, node_size: 10.0)
end

def draw
  background 0
  fill 200, 130, 100
  translate width / 2, height / 2
  points.each do |vec|
    ellipse vec.x, vec.y, 10, 10
  end
end
