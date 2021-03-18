# frozen_string_literal: true

# RULE 110
# using axiom in sense of an LSystem, starting condition
# see https://en.wikipedia.org/wiki/Rule_110
attr_reader :row, :axiom, :black, :white

def setup
  sketch_title 'Wolfram CA Rule 110'
  # Starting point for Sierpinski
  @axiom = decimal_rule_to_a(170)
  color_mode(HSB, 1.0)
  @black = color(0)
  @white = color(1.0)
  initial
end

def decimal_rule_to_a(dec)
  format('%08b', dec).split('').map(&:to_i)
end

def draw
  reset if row > height - 2
  display
end

def display
  (0..width).each_cons(3) do |triple|
    left, center, right = *triple
    a = pixels[row * width + left]
    b = pixels[row * width + center]
    c = pixels[row * width + right]
    idx = 0
    case a + b + c
    when 3 * white
      idx = 7
    when 2 * black + white
      idx = (a == b)? 1 : (a == c)? 2 : 4
    when 2 * white + black
      idx = (b == c)? 3 : (a == c)? 5 : 6
    end
    pixels[row.succ * width + center] = black unless axiom[idx].zero?
  end
  @row += 1
  update_pixels
end

def settings
  size(400, 400)
end

def initial
  # start from a single point at one end
  background(white)
  load_pixels
  pixels[width - 2] = black
  update_pixels
  @row = 0
end

def reset
  # create random starting conditions and re-start
  @black = color(rand, 1.0, 1.0)
  @white = color(rand, 1.0, 1.0)
  background(white)
  load_pixels # reload after background set
  (0..width).map { |idx| pixels[idx] = black if rand > 0.5 }
  update_pixels
  @row = 0
end
