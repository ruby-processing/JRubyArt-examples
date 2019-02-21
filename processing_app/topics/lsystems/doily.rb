########################################################
# A Doily fractal implemented using a
# Lindenmayer System in JRubyArt by Martin Prout
########################################################
load_libraries :grammar

# Doily class
class Doily
  include Processing::Proxy
  attr_reader :draw_length, :vec, :theta, :axiom, :grammar
  DELTA = 45 # degrees
  def initialize(vec)
    @axiom = 'F-F-F-F-F-F-F-F' # Axiom
    rules =  { 'F' => 'F---F+F+F+F+F+F+F---F' }
    @grammar = Grammar.new(axiom, rules)
    @theta   = 0
    @draw_length = 100
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
        else
          puts("character #{ch} not in grammar")
        end
      end
    end
  end
end

attr_reader :points

def setup
  sketch_title 'Doily'
  doily = Doily.new(Vec2D.new(width * 0.35, height * 0.2))
  production = doily.generate 4 # 4 generations looks OK
  @points = doily.translate_rules(production)
  no_loop
end

def draw
  background(0)
  render points
end

def render(points)
  no_fill
  stroke 200.0
  stroke_weight 3
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
