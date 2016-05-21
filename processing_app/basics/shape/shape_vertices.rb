#
# Shape Vertices.
#
# How to iterate over the vertices of a shape.
# When loading an obj or SVG, get_vertex_count
# will typically return 0 since all the vertices
# are in the child shapes.
#
# You should iterate through the children and then
# iterate through their vertices.
#

attr_reader :uk

def settings
  size(640, 360)
end

def setup
  sketch_title 'Shape Vertices'
  # Load the shape
  @uk = load_shape('uk.svg')
end

def draw
  background(80)
  # Center where we will draw all the vertices
  translate(width / 2 - uk.width / 2, height / 2 - uk.height / 2)
  # Iterate over the children
  uk.get_child_count.times do |i|
    child = uk.get_child(i)
    # Now we can actually get the vertices from each child
    child.get_vertex_count.times do |j|
      v = child.get_vertex(j)
      # Cycling brightness for each vertex
      stroke((frame_count + (i + 1) * j) % 255)
      # Just a dot for each one
      point(v.x, v.y)
    end
  end
end
