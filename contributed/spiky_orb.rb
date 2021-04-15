# spiky_orb.rb
# After a vanilla processing sketch by
# Ben Notorianni aka lazydog
# Features dynamic creation of a colour table
# Use 's' key to toggle spikes
BALL_RADIUS = 160

attr_reader :colour_table, :orb_vertices, :flat, :smoothing, :sub_division_depth
attr_reader :orb_radii

def settings
  size 640, 480, P3D
end

def setup
  sketch_title 'Spiky Orb'
  @orb_vertices = []
  @flat = false
  @smoothing = 3
  @sub_division_depth = 4
end

def draw
  background(0)
  lights
  spot_light(255, 255, 255, 400, 400, 400, -1, -1, -1, PI / 2, 2)
  translate(width / 2, height / 2)
  smooth_rotation(5.0, 6.7, 7.3)
  create_sphere
  draw_tesselated_icosahedron(orb_vertices, colour_table)
end

def calc_color(red, green, blue)
  r = 127 * sin(PI * frame_count * red) + 127
  g = 127 * sin(PI * frame_count * green) + 127
  b = 127 * sin(PI * frame_count * blue) + 127
  color(r, g, b)
end

def generate_colour_table(depth)
  c1 = calc_color(0.00400, 0.002200, 0.00300)
  c2 = calc_color(0.00328, 0.00328, 0.00328)
  c3 = calc_color(0.00496, 0.00780, 0.00450)
  c4 = calc_color(0.00420, 0.00520, 0.00620)
  colour_set = [
    [c1, c1, c1, c2],
    [c1, c1, c1, c2],
    [c1, c1, c1, c2],
    [c4, c4, c4, c3]
  ]
  @colour_table = []
  20.times do
    (4**(depth - 1)).times do |j|
      colour_table << colour_set[(j / 16) % 4][j % 4]
    end
  end
  colour_table
end

def subdivide_triangle(depth, index, pt1, pt2, pt3)
  if depth == 1
    orb_vertices[index += 1] = pt1.x
    orb_vertices[index += 1] = pt1.y
    orb_vertices[index += 1] = pt1.z
    orb_vertices[index += 1] = pt2.x
    orb_vertices[index += 1] = pt2.y
    orb_vertices[index += 1] = pt2.z
    orb_vertices[index += 1] = pt3.x
    orb_vertices[index += 1] = pt3.y
    orb_vertices[index += 1] = pt3.z
  else
    vec1 = pt1 + pt2
    vec2 = pt2 + pt3
    vec3 = pt3 + pt1
    if depth <= sub_division_depth - smoothing
      vec1 *= 0.5
      vec2 *= 0.5
      vec3 *= 0.5
    else
      r = orb_radii[depth]
      vec1 = vec1.normalize * r
      vec2 = vec2.normalize * r
      vec3 = vec3.normalize * r
    end
    index = subdivide_triangle(depth - 1, index, pt1, vec1, vec3)
    index = subdivide_triangle(depth - 1, index, vec1, pt2, vec2)
    index = subdivide_triangle(depth - 1, index, vec2, pt3, vec3)
    index = subdivide_triangle(depth - 1, index, vec1, vec2, vec3)
  end
  index
end

def tesselate_icosahedron(radii, depth)
  gr = (1 + sqrt(5)) / 2.0
  r = radii[depth] / sqrt(1 + gr * gr)
  v = [
    Vec3D.new(0, -r, r * gr),
    Vec3D.new(0, -r, -r * gr),
    Vec3D.new(0,  r, -r * gr),
    Vec3D.new(0, r, r * gr),
    Vec3D.new(r, -r * gr, 0),
    Vec3D.new(r, r * gr, 0),
    Vec3D.new(-r, r * gr, 0),
    Vec3D.new(-r, -r * gr, 0),
    Vec3D.new(-r * gr, 0, r),
    Vec3D.new(-r * gr, 0, -r),
    Vec3D.new(r * gr, 0, -r),
    Vec3D.new(r * gr, 0, r)
  ]
  index = 0
  index = subdivide_triangle(depth, index, v[0], v[7], v[4])
  index = subdivide_triangle(depth, index, v[0], v[4], v[11])
  index = subdivide_triangle(depth, index, v[0], v[11], v[3])
  index = subdivide_triangle(depth, index, v[0], v[3], v[8])
  index = subdivide_triangle(depth, index, v[0], v[8], v[7])
  index = subdivide_triangle(depth, index, v[1], v[4], v[7])
  index = subdivide_triangle(depth, index, v[1], v[10], v[4])
  index = subdivide_triangle(depth, index, v[10], v[11], v[4])
  index = subdivide_triangle(depth, index, v[11], v[5], v[10])
  index = subdivide_triangle(depth, index, v[5], v[3], v[11])
  index = subdivide_triangle(depth, index, v[3], v[6], v[5])
  index = subdivide_triangle(depth, index, v[6], v[8], v[3])
  index = subdivide_triangle(depth, index, v[8], v[9], v[6])
  index = subdivide_triangle(depth, index, v[9], v[7], v[8])
  index = subdivide_triangle(depth, index, v[7], v[1], v[9])
  index = subdivide_triangle(depth, index, v[2], v[1], v[9])
  index = subdivide_triangle(depth, index, v[2], v[10], v[1])
  index = subdivide_triangle(depth, index, v[2], v[5], v[10])
  index = subdivide_triangle(depth, index, v[2], v[6], v[5])
  subdivide_triangle(depth, index, v[2], v[9], v[6])
end

def smooth_rotation(ro1, ro2, ro3)
  mills = millis * 0.00003
  rotate_x 0.5 * Math.sin(mills * ro1) + 0.5
  rotate_y 0.5 * Math.sin(mills * ro2) + 0.5
  rotate_z 0.5 * Math.sin(mills * ro3) + 0.5
end

def generate_radii(base_radius, depth)
  return (0..depth).map { base_radius } if flat

  (0..depth).map do |i|
    r = noise(frame_count * 0.003, (i.to_f / depth) - 1) + 1
    base_radius * (0.9 * r)
  end
end

def draw_tesselated_icosahedron(verticies, colour_table)
  index = 0
  no_stroke
  begin_shape(TRIANGLES)
  colour_table.each do |col|
    fill(col)
    vertex(verticies[index += 1], verticies[index += 1], verticies[index += 1])
    vertex(verticies[index += 1], verticies[index += 1], verticies[index += 1])
    vertex(verticies[index += 1], verticies[index += 1], verticies[index += 1])
  end
  end_shape
end

def create_sphere
  @orb_radii = generate_radii(BALL_RADIUS, sub_division_depth)
  tesselate_icosahedron(orb_radii, sub_division_depth)
  generate_colour_table(sub_division_depth)
end

def key_pressed
  return unless key == 's'

  @flat = !flat
end
