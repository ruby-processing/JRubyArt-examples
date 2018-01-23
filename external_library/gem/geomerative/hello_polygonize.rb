# Move image round screen with mouse
# top left to view least polygonized version
# NB: constrained_map is a JRubyArt method
require 'geomerative'

attr_reader :shp

def settings
  size(600, 600)
end

def setup
  sketch_title 'polygonize'
  RG.init(self)
  shp = RG.load_shape(data_path('lion.svg'))
  @shp = RG.center_in(shp, g, 100)
end

def draw
  background(255)
  # The separation between the polygon points depends on mouse_x
  point_separation = constrained_map(mouse_x, (100..(width - 100)), (5..200))
  # Creating a polygonized version
  RG.set_polygonizer(RCommand::UNIFORMLENGTH)
  RG.set_polygonizer_length(point_separation)
  polyshp = RG.polygonize(shp)
  # Move to the mouse position
  translate(mouse_x, mouse_y)
  # Draw the polygonized group with the SVG styles
  RG.shape(polyshp)
end
