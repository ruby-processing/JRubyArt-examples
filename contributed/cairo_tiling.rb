ANGLE = PI / 2
PTS = [Vec2D.new(-30, 0), Vec2D.new(30, 0), Vec2D.new(45, 45), Vec2D.new(0, 60), Vec2D.new(-45, 45)]
S = 15
W = 12 * S
H = 6 * S

def settings
  size(W * 3, H * 6)
end

def setup
  sketch_title 'Cairo tiling'
  @renderer ||= GfxRender.new(g)
  cols = width + W
  rows = height + H
  grid(cols, rows, W, H) do |x, y|
    (y % W).zero? ? composite_tile(x + W / 2, y, S) : composite_tile(x, y, S)
  end
end

def composite_tile(x, y, s)
  stroke_weight 2
  fill(255, 220, 0)
  pentagon(x, y, s)
  fill(255, 220, 155)
  pentagon(x + 6 * s, y, s, r = 1)
  fill(0, 100, 200)
  pentagon(x - 6 * s, y, s, r = 3)
  fill(140, 180, 255)
  pentagon(x, y, s, r = 2)
end

def pentagon(xo, yo, s, r = 0)
  push_matrix
  translate(xo, yo)
  rotate(ANGLE * r)
  begin_shape
  PTS.map { |vec| vec.to_vertex(@renderer) }
  end_shape
  pop_matrix
end
