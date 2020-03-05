# frozen_string_literal: true

load_library :grammar, :penrose
attr_reader :penrose

def settings
  size 800, 800
end

def setup
  sketch_title 'Penrose Colored'
  stroke_weight 2
  @penrose = PenroseColored.new(width / 2, height / 2)
  penrose.create_grammar 5
  no_loop
end

def draw
  background 0
  penrose.render
end
