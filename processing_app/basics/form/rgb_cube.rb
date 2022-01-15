java_import 'monkstone.vecmath.GfxRender'
# RGB Cube.
#
# The three primary colors of the additive color model are red, green, and blue.
# This RGB color cube displays smooth transitions between these colors.

attr_reader :box_points

def setup
  sketch_title 'RGB Cube'
  no_stroke
  ArcBall.init(self, width / 2, height / 2)

  @box_points = {
    top_front_left: Vec3D.new(-90,  90,  90),
    top_front_right: Vec3D.new(90,  90,  90),
    top_back_right: Vec3D.new(90,  90, -90),
    top_back_left: Vec3D.new(-90,  90, -90),
    bottom_front_left: Vec3D.new(-90, -90,  90),
    bottom_front_right: Vec3D.new(90, -90,  90),
    bottom_back_right: Vec3D.new(90, -90, -90),
    bottom_back_left: Vec3D.new(-90, -90, -90)
  }
  # a box from defined points
  @box = {
    top: [box_points[:top_front_left], box_points[:top_front_right], box_points[:top_back_right],
    box_points[:top_back_left]],
    front: [box_points[:top_front_left], box_points[:top_front_right], box_points[:bottom_front_right],
    box_points[:bottom_front_left]],
    left: [box_points[:top_front_left], box_points[:bottom_front_left], box_points[:bottom_back_left],
    box_points[:top_back_left]],
    back: [box_points[:top_back_left], box_points[:top_back_right], box_points[:bottom_back_right],
    box_points[:bottom_back_left]],
    right: [box_points[:top_back_right], box_points[:bottom_back_right], box_points[:bottom_front_right],
    box_points[:top_front_right]],
    bottom: [box_points[:bottom_front_left], box_points[:bottom_front_right], box_points[:bottom_back_right],
    box_points[:bottom_back_left]]
  }
end

def draw
  background 1
  begin_shape QUADS
  %i[top front left back right bottom].each do |s|
    @box[s].each do |p|
      fill_from_points p
      p.to_vertex(renderer)
    end
  end
  end_shape
end

def fill_from_points(points)
  red = map1d(points.x, -90..90, 0..255)
  blue = map1d(points.y, -90..90, 0..255)
  green = map1d(points.z, -90..90, 0..255)
  fill(red, blue, green)
end

def renderer
  @renderer ||= GfxRender.new(g)
end

def settings
  size 640, 360, P3D
end
