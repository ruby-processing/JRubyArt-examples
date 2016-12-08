# Loosely based on a sketch by Bárbara Almeida
# https://www.openprocessing.org/sketch/179567
# Here is a sketch that clearly demonstrates some of the most egregious parts of
# vanilla processing:-
# PVector is over complicated and overloads 2D and 3D functionality, cf Vec2D
# JRubyArt and propane which behaves as a 2D vector (cross product is a float)
# and can easily be used in chain calculations.

##################################################
# Usage click on screen with mouse to generate a point, repeat as required
# to create a triangle, and the circumcircle will be drawn unless the points are
# collinear. Additional clicks erase the first point and add a new point. To
# demonstrate the stupid processing coordinate convention press 'c' or 'C', you
# will see the graph is inverted and origin y is top left, also demonstrates
# the collinearity test press space-bar to clear
##################################################

load_library :simple_circle # but does not use math_point

attr_reader :pnt, :points, :circle, :renderer

def settings
  size 800, 800, P2D
  # pixel_density(2) # for HiDpi screens
  # smooth # see https://processing.org/reference/smooth_.html
end

def setup
  sketch_title 'Simplified Circumcircle Sketch'
  @pnt = Vec2D.new
  @points = SimplePoints.new
  ellipse_mode RADIUS
  @renderer = AppRender.new(self)
end

def draw
  graph_paper
  stroke_weight 4
  stroke 200, 0, 0
  point(pnt.x, pnt.y)
  points.map { |pt| point(pt.x, pt.y) }
  return unless points.full?
  return render_triangle if points.collinear? # Renders a straight line
  circle = Circumcircle.new(points)
  circle.calculate
  center = circle.center
  point(center.x, center.y)
  no_fill
  stroke_weight 2
  render_triangle
  stroke 0, 0, 255, 100
  ellipse(center.x, center.y, circle.radius, circle.radius)
end

def mouse_pressed
  points << Vec2D.new(mouse_x, mouse_y)
end

def render_triangle
  stroke 255, 255, 0, 100
  begin_shape
  points.each do |point|
    point.to_vertex(renderer)
  end
  end_shape(CLOSE)
end

def key_pressed
  case key
  when ' '
    points.clear
  when 'c', 'C'
    (0..400).step(200) do |i|
      points << Vec2D.new(i, i)
    end
    puts 'collinear points' if points.collinear?
  end
end

def graph_paper
  background(180)
  cell_size = 20 # size of the grid
  (0..width).step(cell_size) do |i|
    stroke(75, 135, 155)
    line(i, 0, i, height)
  end
  (0..height).step(cell_size) do |i|
    line(0, i, width, i)
  end
end
