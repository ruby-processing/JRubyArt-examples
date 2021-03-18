# RULE 30
# using axiom in sense of an LSystem, starting condition
# see https://en.wikipedia.org/wiki/Rule_30
attr_reader :row, :axiom

def setup
  sketch_title 'Wolfram CA Rule 60'
  # An interesting starting point
  @axiom = [1, 0, 1, 1, 0, 0, 1, 0]

  initial
end

def black
  color(0)
end

def white
  color(255)
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
    case a + b + c
    when 3 * white
      idx = 7
    when 2 * black + white
      idx = (c == white)? 1 : (b == white)? 2 : 4
    when 2 * white + black
      idx = (c == black)? 3 : (a == black)? 5 : 6
    end
    set(center, row.succ, white) unless axiom[idx].zero?
  end
  @row += 1
end

def settings
  size(400, 400)
end

def initial
  background(0)
  set(width / 2, 0, white)
  @row = 0
end

def reset
  # create some random starting conditions and re-start
  initial
  @axiom = Array.new(8) {rand(0..1)}
  puts axiom.inspect
end
