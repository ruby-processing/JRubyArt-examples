# Circles by Bárbara Almeida
#  A fork of Circle through 3 points by Bárbara Almeida.
# Draw circles from 3 points moving on smooth random trajectories.
# https://www.openprocessing.org/sketch/211167

# JRubyArt version by Martin Prout
PBisector = Struct.new(:vector, :angle) # perpendicular bisector
Vect = Struct.new(:x, :y, :z) # for calculation of center

def settings
  size(800, 400, P2D)
end

def setup
  sketch_title 'Circles From Three Moving Points'
  color_mode(HSB, 360, 100, 100, 100)
  @c = rand(360)
  @points = (0..2).map { Point.new(rand(width), rand(height)) }
  background 0
end

def draw
  fill(0, 0, 0)
  noStroke
  rect(0, 0, width, height) if (frame_count % 8_000).zero?
  @points.each do |point|
    # change direction sometimes
    point.set_dir rand(-PI..PI) if rand > 0.96
    point.update
    point.check_edges
  end
  # set the style of the circle
  @dc = map1d(millis, 0..150_000, 0..360) # slowly changes hue
  stroke((@c + @dc) % 360, 50, 100, 5)
  no_fill
  # verifies if there is a circle and draw it
  return if collinear(@points[0].pos, @points[1].pos, @points[2].pos)
  draw_circle @points
end

def draw_circle(pts)
  # find the bisectors of 2 sides
  mp = []
  mp[0] = bisector(pts[0].pos, pts[1].pos)
  mp[1] = bisector(pts[1].pos, pts[2].pos)
  center_point = center(mp) # find the center of the circle
  # calculate the radius
  radius = center_point.dist(pts[2].pos)
  # if not collinear display circle
  ellipse(center_point.x, center_point.y, 2 * radius, 2 * radius)
end

def bisector(a, b)
  midpoint = (a + b) / 2.0 # middle of AB
  theta = atan2(b.y - a.y, b.x - a.x) # inclination of AB
  PBisector.new(midpoint, theta - HALF_PI)
end

def collinear(a, b, c)
  (a - b).cross(b - c).zero?
end

def center(bisector)
  # equation of the first bisector (ax - y =  -b)
  eq = bisector.map do |mp|
    a = tan mp.angle
    v = mp.vector
    Vect.new(a, -1, -1 * (v.y - v.x * a))
  end
  # calculate x and y coordinates of the circumcenter
  ox = (eq[1].y * eq[0].z - eq[0].y * eq[1].z) /
  (eq[0].x * eq[1].y - eq[1].x * eq[0].y)
  oy =  (eq[0].x * eq[1].z - eq[1].x * eq[0].z) /
  (eq[0].x * eq[1].y - eq[1].x * eq[0].y)
  Vec2D.new(ox,oy)
end

class Point
  include Processing::Proxy
  attr_accessor :pos, :velocity, :acceleration

  def initialize(x, y)
    @pos = Vec2D.new(x, y)
    @velocity = Vec2D.new
    @acceleration = Vec2D.random
  end

  # change direction
  def set_dir(angle)
    # direction of the acceleration is defined by the new angle
    @acceleration = Vec2D.from_angle(angle)
    dif = acceleration.angle_between velocity
    dif = map1d(dif, 0..PI, 0.1..0.001)
    @acceleration *= dif
  end

  # update position
  def update
    @velocity += acceleration
    velocity.set_mag(1.5) { velocity.mag > 1.5 } # limit velocity
    @pos += velocity
  end

  def check_edges
    pos.x = constrain(pos.x, 0, width)
    pos.y = constrain(pos.y, 0, height)
  end
end
