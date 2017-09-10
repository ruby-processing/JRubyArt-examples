require 'geomerative'
# Original by Edward Loveall, converted to JRubyArt by Martin Prout
# Click in frame to start the line (repeat as required to generate path)
# Makes use of JRubyArt Vec2D class
attr_reader :shp1, :oldvec, :stp

def settings
  size(400, 400)
end

def setup
  sketch_title 'Geomerative Path'
  background(0)
  @stp = 0
  RG.init(self)
  @oldvec = Vec2D.new(width / 4, height / 2)
  start = RPoint.new(oldvec.x, oldvec.y)
  @shp1 = RPath.new(start)
end

def draw
  background(0)
  stroke(255)
  stroke_weight(3)
  no_fill
  translate(stp, 0) # move line by stp
  shp1.draw
  @stp -= 1
end

def mouse_pressed
  distvec = Vec2D.new(mouse_x, mouse_y) - oldvec
  point_one = RPoint.new(oldvec.x + adjust_x(distvec) - stp, oldvec.y)
  point_two = RPoint.new(oldvec.x - adjust_x(distvec) - stp, mouse_y)
  point_three = RPoint.new(mouse_x - stp, mouse_y)
  shp1.add_bezier_to(point_one, point_two, point_three)
  @oldvec = Vec2D.new(mouse_x, mouse_y)
end

private

def adjust_x(vec)
  (vec.x * 0.25).to_i
end
