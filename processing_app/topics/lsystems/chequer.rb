########################################################
# Chequer implemented using a grammar library
# Lindenmayer System in JRubyArt by Martin Prout
########################################################
load_library :grammar
attr_reader :chequer

def setup
  sketch_title 'Chequer'
  @chequer = Chequer.new width * 0.9, height / 10
  chequer.create_grammar 4
  no_loop
end

def draw
  background 0
  chequer.render
end

def settings
  size 600, 600
end

# Chequer class
class Chequer
  include Processing::Proxy
  attr_accessor :axiom, :grammar, :production, :draw_length, :theta, :xpos, :ypos
  DELTA = Math::PI / 2

  def initialize(xpos, ypos)
    @xpos = xpos
    @ypos = ypos
    @axiom = 'F-F-F-F'        # Axiom
    @grammar = Grammar.new(axiom, 'F' => 'FF-F-F-F-FF')
    @draw_length = 500
    stroke 0, 255, 0
    stroke_weight 2
    @theta = 0
  end

  def render
    production.each do |element|
      case element
      when 'F'
        x_temp = xpos
        y_temp = ypos
        @xpos -= draw_length * cos(theta)
        @ypos -= draw_length * sin(theta)
        line(x_temp, y_temp, xpos, ypos)
      when '+'
        @theta += DELTA
      when '-'
        @theta -= DELTA
      else
        puts format("Character '%s' is not in grammar", element)
      end
    end
  end

  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @draw_length /= 3**gen
    @production = @grammar.generate gen
  end
end



