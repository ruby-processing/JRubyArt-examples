#
# WigglePShape. Demonstrates initialization and use of ShapeRender,
# that allows us to send Vec2D to PShape vertex
#
# How to move the individual vertices of a PShape
#
attr_reader :wiggle_object

def setup
  sketch_title 'Wiggle PShape'
  @wiggle_object = Wiggler.new
end

def draw
  background(255)
  wiggle_object.display
  wiggle_object.wiggle
end

# An object that wraps the PShape
class Wiggler
  include Processing::Proxy
  attr_reader :original, :wiggler, :yoff, :xoff

  def initialize
    @yoff = 0

    # The "original" locations of the vertices make up a circle
    @original = (0...16).map{ |angle| Vec2D.from_angle(PI * angle / 8) * 100 }
    # Now make the PShape with those vertices
    @wiggler = create_shape
    renderer = Sketch::ShapeRender.new(wiggler) # Prefix with Sketch classname
    wiggler.begin_shape
    wiggler.fill(127)
    wiggler.stroke(0)
    wiggler.stroke_weight(2)
    original.map{ |vert| vert.to_vertex(renderer) }
    wiggler.end_shape(CLOSE)
  end

  def wiggle
    @xoff = 0
    # Apply an offset to each vertex
    rad = ->(pos){ (Vec2D.from_angle(TAU * noise(xoff, yoff)) * 4) + pos }
    original.each_with_index do |pos, i|
      # Calculate a new vertex location based on noise around "original" location
      r = rad.call(pos)
      # Set the location of each vertex to the new one
      wiggler.set_vertex(i, r.x, r.y)
      # increment perlin noise x value
      @xoff += 0.5
    end
    # Increment perlin noise y value
    @yoff += 0.02
  end

  def display
    push_matrix
    translate(width / 2, height / 2) # center display
    shape(wiggler)
    pop_matrix
  end
end

def settings
  size(640, 360, P2D)
end
