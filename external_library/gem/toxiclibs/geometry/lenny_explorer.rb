# lenny_explorer.rb
require 'toxiclibs'
java_import 'toxi.geom.Circle'
java_import 'toxi.geom.Rect'
load_library :lenny

attr_reader :path

def settings
  size(600, 600)
end

def setup
  sketch_title 'Lenny Explorer'
  no_fill
  # @path = Path.new(
  #   RectBoundary.new(Rect.new(10, 10, width - 20, height - 20)),
  #   10,
  #   0.03,
  #   3_000
  # )
  @path = Path.new(
    CircularBoundary.new(Circle.new(width / 2, height / 2, 250)),
    10,
    0.03,
    3_000
  )
end

def draw
  background(255)
  50.times { path.grow }
  path.render(g)
end
