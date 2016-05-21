# encoding: utf-8
require 'geomerative'
# After an original sketch by fjenett
# Declare the objects we are going to use, so that they are accesible
# from setup and from draw
attr_reader :shp, :x, :y, :xd, :yd

def settings
  size(600, 400)
  smooth(4)
end

def setup
  sketch_title 'Blobby Trail'
  RG.init(self)
  @xd = rand(-5..5)
  @yd = rand(-5..5)
  @x = width / 2
  @y = height / 2
  @shp = RShape.new
end

def draw
  background(120)
  move
  elli = RG.getEllipse(x, y, rand(2..20))
  @shp = RG.union(shp, elli)
  RG.shape(shp)
end

def move
  @x += xd
  @xd *= -1 unless (0..width).cover?(x)
  @y += yd
  @yd *= -1 unless (0..height).cover?(y)
end