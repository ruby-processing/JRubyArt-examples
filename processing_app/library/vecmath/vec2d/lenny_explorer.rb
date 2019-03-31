# A simple lenny explorer (see Vec2D library folder for more examples)
# After 'The Explorer' by Leander Herzog, and a toxiclibs version by Karsten
# Schmidt. This is a pure JRubyArt version by Martin Prout
load_library :lenny
attr_reader :path, :renderer

def settings
  size(600, 600)
end

def setup
  sketch_title 'Lenny Explorer'
  no_fill
  # @path = Path.new(
  #   Boundary.new(Circle.new(Vec2D.new(width / 2, height / 2), 250)),
  #   10,
  #   0.03,
  #   5_000
  # )
  @path = Path.new(
    Boundary.new(
      Rect.new(
        Vec2D.new(10, 10),
        Vec2D.new(width - 20, height - 20)
      )
    ),
    10,
    0.03,
    5_000
  )
  @renderer = GfxRender.new(g)
end

def draw
  background(255)
  50.times { path.grow }
  path.render(g, renderer)
end

def mouse_pressed
  save_frame data_path('lenny.png')
end
