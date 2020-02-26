# Penrose Tile Generator
# Using a variant of the "ArrayList" recursion technique: http://natureofcode.com/book/chapter-8-fractals/chapter08_section4
# Penrose Algorithm from: http://preshing.com/20110831/penrose-tiling-explained
# Daniel Shiffman May 2013
# Translated (and refactored) to JRubyArt July 2015 by Martin Prout

load_libraries :tile, :control_panel
attr_reader :tris, :s, :acute, :tiler

def setup
  sketch_title 'Penrose'
  control_panel do |c|
    c.title 'Tiler Control'
    c.look_feel 'Nimbus'
    c.checkbox  :seed
    c.checkbox  :acute
    c.button    :generate
    c.button    :reset!
  end

  @tiler = TileFactory.new(acute) # set the Tiler first
  init false # defaults to regular penrose
end

def draw
  background(255)
  translate(width / 2, height / 2)
  tris.each(&:display)
end

def generate
  next_level = []
  tris.each do |tri|
    tri.subdivide.each { |sub| next_level << sub }
  end
  @tris = next_level
end

def reset!
  @tiler = TileFactory.new(acute) # set the Tiler first
  init @seed
  java.lang.System.gc # but does it do any good?
end

def init(alt_seed)
  @tris = []
  10.times do |i| # create 36 degree segments
    a = Vec2D.new
    b = Vec2D.from_angle((2 * i - 1) * PI / 10)
    c = Vec2D.from_angle((2 * i + 1) * PI / 10)
    b *= 370
    c *= 370
    tile = i.even? ? tiler.tile(b, a, c) : tiler.tile(c, a, b) if alt_seed
    tile = i.even? ? tiler.tile(a, b, c) : tiler.tile(a, c, b) unless alt_seed
    tris << tile
  end
end

def settings
  size 1024, 576
end
