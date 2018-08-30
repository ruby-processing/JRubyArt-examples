########################################################
# A Moore Curve fractal implemented using a
# Lindenmayer System in JRubyArt by Martin Prout
########################################################
load_libraries :grammar

# MooreCurve class
class MooreCurve
  include Processing::Proxy
  attr_reader :draw_length, :vec, :theta, :axiom, :grammar
  DELTA = 90 # degrees
  def initialize(vec)
    @axiom = 'LFL+F+LFL' # Axiom
    rules = {
      'L' => '-RF+LFL+FR-', # LSystem Rules
      'R' => '+LF-RFR-FL+'
    }
    @grammar = Grammar.new(axiom, rules)
    @theta   = 0
    @draw_length = 800
    @vec = vec
  end

  def generate(gen)
    @draw_length = draw_length * 0.4**gen
    grammar.generate gen
  end

  def translate_rules(prod)
    coss = ->(orig, alpha, len) { orig + len * DegLut.cos(alpha) }
    sinn = ->(orig, alpha, len) { orig - len * DegLut.sin(alpha) }
    [].tap do |pts| # An array to store line vertices as Vec2D
      prod.each do |ch|
        case ch
        when 'F'
          pts << vec.copy
          @vec = Vec2D.new(
            coss.call(vec.x, theta, draw_length),
            sinn.call(vec.y, theta, draw_length)
          )
          pts << vec
        when '+'
          @theta += DELTA
        when '-'
          @theta -= DELTA
        when 'L', 'R'
        else
          puts("character #{ch} not in grammar")
        end
      end
    end
  end
end

attr_reader :points

def setup
  sketch_title 'Moore Curve'
  curve = MooreCurve.new(Vec2D.new(width * 0.125, height * 0.5))
  production = curve.generate 6 # 4 generations looks good with stroke = 4
  @points = curve.translate_rules(production)
  no_loop
end

def draw
  background(0)
  render points
end

def render(points)
  no_fill
  stroke 200.0
  stroke_weight 1
  begin_shape
  points.each_slice(2) do |v0, v1|
    v0.to_vertex(renderer)
    v1.to_vertex(renderer)
  end
  end_shape
end

def renderer
  @renderer ||= AppRender.new(self)
end

def settings
  size(800, 800)
end
