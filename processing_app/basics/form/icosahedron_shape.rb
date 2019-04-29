# This sketch uses magic numbers for icosahedron, see lib/icosahedron.rb for a calculated version
# But neatly illustrates use of `tap` with PShape and `slice` with an array
attr_reader :ico

def setup
  sketch_title('Icosahedron Shape')
  @ico = create_icosahedron
end

def draw
  background(0, 0, 200)
  lights
  translate(width / 2, height / 2)
  scale(150)
  push_matrix
  rotate_x(0.01 * frame_count)
  rotate_z(0.025 * frame_count)
  shape(ico)
  pop_matrix
end

FACES = [
  2, 1, 0,
  3, 2, 0,
  4, 3, 0,
  5, 4, 0,
  1, 5, 0,

  11, 6,  7,
  11, 7,  8,
  11, 8,  9,
  11, 9,  10,
  11, 10, 6,

  1, 2, 6,
  2, 3, 7,
  3, 4, 8,
  4, 5, 9,
  5, 1, 10,

  2,  7, 6,
  3,  8, 7,
  4,  9, 8,
  5, 10, 9,
  1, 6, 10
].freeze

VERTS = [
  0.000,  0.000,  1.000,
  0.894,  0.000,  0.447,
  0.276,  0.851,  0.447,
  -0.724,  0.526,  0.447,
  -0.724, -0.526,  0.447,
  0.276, -0.851,  0.447,
  0.724,  0.526, -0.447,
  -0.276,  0.851, -0.447,
  -0.894,  0.000, -0.447,
  -0.276, -0.851, -0.447,
  0.724, -0.526, -0.447,
  0.000,  0.000, -1.000
].freeze

def create_icosahedron
  create_shape.tap do |sh|
    sh.begin_shape(TRIANGLES)
    sh.no_stroke
    sh.fill(200, 0, 0)
    FACES.each_slice(3).each do |a, b, c|
      one = a * 3
      two = b * 3
      three = c * 3
      sh.vertex(VERTS[one], VERTS[one + 1], VERTS[one + 2])
      sh.vertex(VERTS[two], VERTS[two + 1], VERTS[two + 2])
      sh.vertex(VERTS[three], VERTS[three + 1], VERTS[three + 2])
    end
    sh.end_shape
  end
end

def settings
  size(400, 400, P3D)
end
