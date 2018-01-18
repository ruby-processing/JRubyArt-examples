# Loosely based on a sketch by Bárbara Almeida
# https://www.openprocessing.org/sketch/179567
# Here is a sketch that clearly demonstrates some of the most egregious parts of
# vanilla processing:-
# PVector is over complicated and overloads 2D and 3D functionality, cf Vec2D
# JRubyArt and propane which behaves as a 2D vector (cross product is a float)
# and can easily be used in chain calculations.
# The inverted Y axis in processing requires remapping to use in graphs etc.
# The map method of processing can be used to do this remapping, however in many
# languages (python, ruby etc) map is a keyword with alternative usage.
# For this reason in JRubyArt and propane we have replaced vanilla processing
# map with map1d.

##################################################
# Usage click on screen with mouse to generate a point, repeat as required
# to create a triangle, and the circumcircle will be drawn unless the points are
# collinear. Additional clicks erase the first point and add a new point. To
# demonstrate collinear test press 'c' or 'C', press space-bar to clear
##################################################

load_library :circle

attr_reader :point, :font, :points, :circle, :center

def settings
  size 800, 800
  # pixel_density(2) # for HiDpi screens
  # smooth see https://processing.org/reference/smooth_.html
end

def setup
  sketch_title 'Circumcircle Through Three Points'
  @point = MathPoint.new
  @font = create_font('Arial', 16, true)
  @points = TPoints.new
  ellipse_mode RADIUS
  @renderer = AppRender.new(self)
end

def draw
  graph_paper
  point.display
  points.map(&:display)
  return unless circle
  center.display
  no_fill
  stroke 200
  render_triangle(points)
  ellipse(center.screen_x, center.screen_y, circle.radius, circle.radius)
end

def mouse_pressed
  points << MathPoint.new.from_sketch(mouse_x, mouse_y)
  return unless points.full?
  @circle = Circumcircle.new(points.array)
  # circle.calculate
  @center = MathPoint.new(circle.center)
end

def render_triangle(points)
  begin_shape
  points.each do |point|
    vertex(point.screen_x, point.screen_y)
  end
  end_shape(CLOSE)
end

def key_pressed
  case key
  when ' '
    points.clear
  when 'c', 'C'
    (0..400).step(200) do |i|
      points << MathPoint.new(Vec2D.new(i, i))
    end
    puts 'collinear points' if points.collinear?
  end
end

def graph_paper
  background(0)
  cell_size = 20 # size of the grid
  dim = cell_size * 2
  (dim..width - dim).step(cell_size) do |i|
    stroke(75, 135, 155)
    line(i, dim, i, height - dim)
  end
  (dim..height - dim).step(cell_size) do |i|
    line(dim, i, width - dim, i)
  end
end
