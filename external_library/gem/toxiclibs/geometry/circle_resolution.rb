# frozen_string_literal: true

require 'toxiclibs'
java_import 'toxi.geom.Circle'
attr_reader :gfx

def setup
  sketch_title 'Circle Resolution'
  @gfx = Gfx::ToxiclibsSupport.new(self)
end

def draw
  background(0)
  no_stroke
  fill(255)
  res = map1d(mouse_x, 0..width, 3..72)
  poly = Circle.new(TVec2D.new(width / 2, height / 2), 200).toPolygon2D(res)
  gfx.polygon2D(poly)
  fill(255, 0, 0)
  poly.each { |vertex| gfx.circle(vertex, 5) }
  text(res, 20, 20)
end

def settings
  size(600, 600)
  smooth 8
end
