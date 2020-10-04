# After a sketch by Jim Bumgardner
# http://joyofprocessing.com/blog/tag/tilings/page/2/
# Here we create an array of offscreen images
# Create a grid using the ruby-processing :grid method
# Then randomly render tile images from the array
DIM = 24
TYPE = %i[corner alt_corner alt_oval oval alt_line line].freeze
attr_reader :tiles, :images

def make_image(dim, alternate = :line)
  create_graphics(dim, dim).tap do |g|
    g.smooth(4)
    g.begin_draw
    g.background(255)
    g.stroke(0)
    g.stroke_weight(4)
    g.no_fill
    g.ellipse_mode(RADIUS)
    case alternate
    when :corner
      g.line(dim / 2, 0, dim / 2, dim / 2)
      g.line(0, dim / 2, dim / 2, dim / 2)
      g.line(dim / 2, dim, dim, dim / 2)
    when :alt_corner
      g.line(dim / 2, 0, dim / 2, dim / 2)
      g.line(dim / 2, dim / 2, dim, dim /  2)
      g.line(0, dim / 2, dim / 2, dim)
    when :line
      g.line(dim / 2, 0, dim, dim / 2)
      g.line(0, dim / 2, dim / 2, dim)
    when :alt_line
      g.line(0, dim / 2, dim / 2, 0)
      g.line(dim / 2, dim, dim, dim / 2)
    when :alt_oval
      g.ellipse(0, dim, dim / 2, dim / 2)
      g.ellipse(dim, 0, dim / 2, dim / 2)
    when :oval
      g.ellipse(0, 0, dim / 2, dim / 2)
      g.ellipse(dim, dim, dim / 2, dim / 2)
    end
    g.end_draw
  end
end

def create_image_array(except = [])
  @images = TYPE.reject do |type|
    except.include?(type)
  end.map { |type| make_image(DIM, type) }
  @tiles = []
end

def create_grid
  @tiles = []
  grid(width, height, DIM, DIM) do |posx, posy|
    tiles << Tile.new(Vec2D.new(posx, posy))
  end
end

def setup
  sketch_title 'Mixed Truchet Tiling'
  create_image_array
  create_grid
  no_loop
end

def key_pressed
  case key
  when 'o', 'O'
    create_image_array(%i[alt_line line corner alt_corner])
  when 'c', 'C'
    create_image_array(%i[alt_line line oval alt_oval])
  when 'l', 'L'
    create_image_array(%i[alt_oval oval])
  end
  create_grid
  redraw
end

def draw
  background(255)
  tiles.each(&:render)
end

def settings
  size(576, 576)
  smooth(4)
end

# encapsulate Tile as a class
class Tile
  include Processing::Proxy
  attr_reader :vec, :img

  def initialize(vec)
    @vec = vec
    @img = images.sample
  end

  def render
    image(img, vec.x, vec.y, img.width, img.height)
  end
end
