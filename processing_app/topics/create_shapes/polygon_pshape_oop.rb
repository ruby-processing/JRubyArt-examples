#
# PolygonPShapeOOP.
#
# Wrapping a PShape inside a custom class
#/

load_library 'star'
# A Star object
attr_reader :s1, :s2

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title 'Polygon PShape OOP'
  # Make a new Star
  @s1 = Star.new width, height
  @s2 = Star.new width, height
end

def draw
  background(51)
  s1.run # Display & move the first star
  s2.run # Display & move the second star
end
