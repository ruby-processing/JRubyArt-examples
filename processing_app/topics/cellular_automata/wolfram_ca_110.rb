# RULE 110
# 2 + 4 + 8 + 32 + 64 = 110
# using axiom in sense of an LSystem, starting condition
# see https://en.wikipedia.org/wiki/Rule_110
attr_reader :row, :axiom, :black

def setup
  sketch_title 'Wolfram CA Rule 110'
  @black = color(0)
  # one of most interesting starting points
  @axiom = [0, 1, 1, 1, 0, 1, 1, 0]
  initial
end

def draw
  reset if row > height
  display
end

def display
  (0..width).each_cons(3) do |triple|
    left, center, right = *triple
    a = get(left, row)
    b = get(center, row)
    c = get(right, row)
    idx = 0
    idx += 1 if a == black
    idx += 2 if b == black
    idx += 4 if c == black
    set(center, row.succ, black) unless axiom[idx].zero?
  end
  @row += 1
end

def settings
  size(400, 400)
end

def initial
  background(255)
  set(1, 0, black)
  @row = 0
end

def reset
  # create some random starting conditions and re-start
  initial
  asum = 0
  # filter out some of less interesting results
  while asum < 4 || asum > 5
    @axiom = Array.new(8) { rand(0..1) }
    asum = axiom.inject(:+)
  end
end
