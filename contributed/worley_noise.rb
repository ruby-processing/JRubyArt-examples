# Worley Noise
# After
# The Coding Train / Daniel Shiffman
attr_reader :points

NPOINTS = 20

def settings
  size(400, 400)
end

def setup
  sketch_title 'Worley Noise'
  @points = (0..NPOINTS).map { Vec3D.new(rand(width), rand(height), rand(width)) }
end

def draw
  load_pixels
  grid(width, height) do |x, y|
    distances = []
    NPOINTS.times do |i|
      v = points[i]
      z = frame_count % width
      distances << dist(x, y, z, v.x, v.y, v.z)
    end
    sorted = distances.sort!
    r = map1d(sorted[0], 0..150, 0..255)
    g = map1d(sorted[1], 0..50, 255..0)
    b = map1d(sorted[2], 0..200, 255..0)
    pixels[x + y * width] = color(r, g, b)
  end
  update_pixels
end
