load_library :vector_utils

attr_reader :points

def settings
  size 600, 600, P3D
  smooth 4
end

def setup
  sketch_title 'Fibonacci Layout'
  ArcBall.init self
  @points = VectorUtil.fibonacci_sphere(number: 500, radius: 300.0)
end

def draw
  background 0
  fill 200, 130, 100
  lights
  directional_light 200, 200, 200, -1, 1, 0
  points.each do |vec|
    push_matrix
    translate vec.x, vec.y, vec.z
    polar = VectorUtil.cartesian_to_polar(vec: vec)
    box 10
    rotate_y vec.y
    rotate_z vec.z
    pop_matrix
  end
end
