############################
# pentagonal.rb here I roll one of my own
###########################
load_library :grammar

##
# A Pentagonal Fractal created using a
# Lindenmayer System in JRubyArt by Martin Prout
###
class Pentagonal
  include Processing::Proxy
  DELTA = 72    # degrees
  attr_accessor :draw_length
  attr_reader :axiom, :grammar, :theta, :production, :xpos, :ypos
  def initialize
    @axiom = 'F-F-F-F-F'
    @grammar = Grammar.new(axiom, 'F' => 'F+F+F-F-F-F+F+F')
    @draw_length = 400
    @theta = 0.0
    @xpos = 0.0
    @ypos = 0.0
  end

  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @draw_length *= 0.25**gen
    @production = grammar.generate gen
  end

  def make_shape
    no_fill
    create_shape.tap do |shape|
      shape.begin_shape
      shape.stroke 200
      shape.stroke_weight 3
      shape.vertex(xpos, ypos)
      production.each do |element|
        case element
        when 'F'
          shape.vertex(@xpos -= adjust(:cos), @ypos += adjust(:sin))
        when '+'
          @theta += DELTA
        when '-'
          @theta -= DELTA
        else puts 'Grammar not recognized'
        end
      end
      shape.end_shape
    end
  end

  ###########################################
  # a helper method that returns dx or dy with type
  ###########################################

  def adjust(type)
    # using equal? for identity comparison
    (type.equal? :cos) ? draw_length * DegLut.cos(theta) : draw_length * DegLut.sin(theta)
  end
end

#  Empirically determined position adjustments
ADJUST = [[800, 50], [500, 500], [500, 500], [300, 280], [50, 600]]

attr_reader :pentagonal, :pentive

def setup
  sketch_title 'Pentagonal'
  @pentagonal = Pentagonal.new
  pentagonal.create_grammar 2
  @pentive = pentagonal.make_shape
  pentive.translate(ADJUST[1][0], ADJUST[1][1])
end

def draw
  background 0
  shape(pentive)
end

def key_pressed
  case key
  when '1', '2', '3', '4', '5'  # key corresponds to generation
    gen = key.to_i
    @pentagonal = Pentagonal.new
    pentagonal.create_grammar gen
    @pentive = pentagonal.make_shape
    pentive.translate(ADJUST[gen - 1][0], ADJUST[gen - 1][1])
  else
    @pentagonal = Pentagonal.new
    pentagonal.create_grammar 2
    @pentive = pentagonal.make_shape
    pentive.translate(ADJUST[1][0], ADJUST[1][1])
  end
end

def settings
  size 800, 800, P2D
end

