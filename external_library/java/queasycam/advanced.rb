load_library :queasycam
include_package 'queasycam'

attr_reader :cam, :counter

def settings
  size(400, 400, P3D)
end

def setup
  sketch_title 'Advanced Queasy Camera'
  @cam = QueasyCam.new(self)
  cam.sensitivity = 0.5
  cam.speed = 0.1
  perspektiv(
    fov: PI / 3,
    aspect_ratio: width.to_f / height,
    near_z: 0.01,
    far_z: 10000.0
  )
  @counter = 0
end

def draw
  background(51)
  @counter += 0.005
  (-10..10).each do |x|
    (-10..10).each do |y|
      z = noise(x / 33.0 + counter, y / 33.0 + counter) * 50
      push_matrix
      translate(x * 5, z, y * 5)
      r = map1d(x, -10..10, 100..255)
      g = map1d(y, -10..10, 100..255)
      b = map1d(z, 0..10, 100..255)
      fill(r, g, b)
      box(1)
      pop_matrix
    end
  end
end
