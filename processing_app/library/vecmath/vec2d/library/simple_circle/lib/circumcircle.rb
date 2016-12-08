# frozen_string_literal: true
PBisector = Struct.new(:vector, :angle) # perpendicular bisector
Vect = Struct.new(:x, :y, :z) # for calculation of center
# Circumcircle from 3 points
class Circumcircle
  include Math
  attr_reader :center, :radius, :points
  def initialize(points)
    @points = points
  end

  def calculate
    ab = bisector(points[0], points[1]) # find 2 midpoints
    bc = bisector(points[1], points[2])
    @center = circumcenter(ab, bc)
    @radius = center.dist(points[2]) # points[2] = c
  end

  def bisector(a, b)
    midpoint = (a + b) / 2.0 # middle of ab (or bc)
    theta = atan2(b.y - a.y, b.x - a.x) # slope of ab (or bc)
    PBisector.new(midpoint, theta - PI / 2)
  end

  def circumcenter(pb1, pb2)
    # equation of the first bisector (ax - y =  -b)
    a0 = tan pb1.angle
    v0 = pb1.vector
    a1 = tan pb2.angle
    v1 = pb2.vector
    eq0 = Vect.new(a0, -1, -1 * (v0.y - v0.x * a0))
    eq1 = Vect.new(a1, -1, -1 * (v1.y - v1.x * a1))
    # calculate x and y coordinates of the circumcenter
    ox = (eq1.y * eq0.z - eq0.y * eq1.z) /
         (eq0.x * eq1.y - eq1.x * eq0.y)
    oy = (eq0.x * eq1.z - eq1.x * eq0.z) /
         (eq0.x * eq1.y - eq1.x * eq0.y)
    Vec2D.new(ox, oy)
  end
end
