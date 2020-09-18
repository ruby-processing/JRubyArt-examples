# Jim Bumgardner

DIM = 24
attr_reader :cells, :tile1, :tile2

def make_tile(state)
  create_graphics(DIM, DIM, P2D).tap do |g|
    g.smooth(4)
    g.begin_draw
    g.background(255)
    g.stroke(0)
    g.stroke_weight(4)
    g.no_fill
    g.ellipse_mode(RADIUS)
    if state
      g.ellipse(0, 0, DIM / 2, DIM / 2)
      g.ellipse(DIM, DIM, DIM / 2, DIM / 2)
    else
      g.ellipse(0, DIM, DIM / 2, DIM / 2)
      g.ellipse(DIM, 0, DIM / 2, DIM / 2)
    end
    g.end_draw
  end
end

def setup
  sketch_title 'Truchet Tiling'
  @tile1 = make_tile(false)
  @tile2 = make_tile(true)
  @cells = []

  grid(width, height, DIM, DIM) do |posx, posy|
    cells << Cell.new(Vec2D.new(posx, posy))
  end
  no_loop
end

def draw
  background(255)
  cells.each(&:render)
end

def settings
  size(576, 576, P2D)
  smooth(4)
end


class Cell
  include Processing::Proxy
  attr_reader :vec, :state

  def initialize(vec)
    @vec = vec
    @state = rand < 0.5
  end

  def render
    return image(tile1, vec.x, vec.y, tile1.width, tile1.height) if state

    image(tile2, vec.x, vec.y, tile2.width, tile2.height)
  end
end
