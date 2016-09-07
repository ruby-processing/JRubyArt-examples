#######################################################
# penrose tiling in ruby processing using LSystems
# in JRubyArt by Martin Prout
######################################################
load_library :grammar
attr_reader :penrose

def settings
  size 800, 800
  smooth
end

def setup
  sketch_title 'Penrose'
  stroke_weight 2
  @penrose = PenroseColored.new(width / 2, height / 2)
  penrose.create_grammar 5
  no_loop
end

def draw
  background 0
  penrose.render
end
