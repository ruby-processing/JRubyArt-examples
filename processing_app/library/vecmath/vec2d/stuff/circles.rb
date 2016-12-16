# Circles by Bárbara Almeida
#  A fork of Circle through 3 points by Bárbara Almeida.
# Draw circles from 3 points moving on smooth random trajectories.
# https://www.openprocessing.org/sketch/211167

# JRubyArt version by Martin Prout
load_library :circles

attr_reader :points

def settings
  size(800, 400, P2D)
end

def setup
  sketch_title 'Circles From Three Moving Points'
  color_mode(HSB, 360, 100, 100, 100)
  ellipse_mode RADIUS
  hint DISABLE_DEPTH_SORT
  reset
end

def draw
  no_stroke
  reset if (frame_count % 8_000).zero?
  points.each(&:update)
  # set the style of the circle
  @dc = map1d(millis, 0..150_000, 0..360) # slowly changes hue
  stroke((@c + @dc) % 360, 50, 100, 5)
  no_fill
  # verifies if there is a circle and draw it
  return if points.collinear?
  draw_circle
end

def draw_circle
  # find the bisectors of 2 sides
  circle = Circumcircle.new(points)
  circle.calculate
  center_point = circle.center # find the center of the circle
  # calculate the radius
  radius = circle.radius
  # if not collinear display circle
  ellipse(center_point.x, center_point.y, radius, radius)
end

def reset
  background 0
  @c = rand(360)
  @points = TPoints.new
  (0..2).each { points << TPoint.new(Vec2D.new(rand(width), rand(height)))}
end
