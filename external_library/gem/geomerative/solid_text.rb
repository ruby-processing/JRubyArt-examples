require 'geomerative'

attr_reader :em

def settings
  size(600, 400, P3D)
  smooth
end

def setup
  sketch_title 'Solid Text'
  RG.init(self)
  grp = RG.get_text('Depth!', data_path('FreeSans.ttf'), 50, CENTER)
  RG.polygonizer = RCommand::UNIFORMLENGTH
  RG.polygonizer_length = 1
  @em = RExtrudedMesh.new(grp)
end

def draw
  background(100)
  lights
  translate(width / 2, height / 2, 200)
  rotate_y(millis / 2000.0)
  fill(255, 100, 0)
  no_stroke
  em.draw
end

# Custom extrusion class, including Proxy to access App methods
class RExtrudedMesh
  include Processing::Proxy
  attr_reader :mesh, :points_array, :depth

  def initialize(grp, dpth = 10)
    @depth = dpth
    @mesh = grp.to_mesh
    @points_array = grp.points_in_paths
  end

  def draw_face(strips, depth)
    strips.each do |strip|
      begin_shape(TRIANGLE_STRIP)
      strip.vertices.each do |point|
        vertex(point.x, point.y, depth / 2.0)
      end
      end_shape(CLOSE)
    end
  end

  def draw_sides(points_array, depth)
    points_array.each do |points|
      begin_shape(QUAD_STRIP)
      points.each do |point|
        vertex(point.x, point.y, depth / 2.0)
        vertex(point.x, point.y, -depth / 2.0)
      end
      end_shape(CLOSE)
    end
  end

  def draw
    strips = mesh.strips
    draw_face(strips, depth)
    draw_face(strips, depth * -1)
    draw_sides(points_array, depth)
  end
end
