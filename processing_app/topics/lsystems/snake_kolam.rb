# frozen_string_literal: true

#######################################################
# Lindenmayer System in ruby-procesDegLut.sing by Martin Prout
# snake_kolam.rb uDegLut.sing l-systems
#######################################################
load_library :grammar

attr_reader :kolam

def setup
  sketch_title 'Snake Kolam'
  @kolam = SnakeKolam.new width / 8, height * 0.8
  kolam.create_grammar 3 # create grammar from rules
  no_loop
end

def draw
  background 0
  stroke_weight 3
  stroke 200
  kolam.render
end

def settings
  size 500, 500
end

# class SnakeKolam
class SnakeKolam
  include Processing::Proxy

  attr_accessor :axiom, :start_length, :xpos, :ypos, :grammar, :production, :draw_length, :gen
  XPOS = 0
  YPOS = 1
  ANGLE = 2
  DELTA = 90 # degrees

  def initialize(xpos, ypos)
    setup_grammar
    @start_length = 120.0
    @theta = 90 # degrees
    @draw_length = start_length
    @xpos = xpos
    @ypos = ypos
  end

  def setup_grammar
    @axiom = 'FX+F+FX+F'
    @grammar = Grammar.new(
      axiom,
      'X' => 'X-F-F+FX+F+FX-F-F+FX'
    )
  end

  def render # NB not using affine transforms here
    turtle = [xpos, ypos, 0.0]
    production.each do |element|
      case element
      when 'F'
        turtle = draw_line(turtle, draw_length)
      when '+'
        turtle[ANGLE] += DELTA
      when '-'
        turtle[ANGLE] -= DELTA
      when 'X'
      else
        puts "Character '#{element}' is not in grammar"
      end
    end
  end

  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @gen = gen
    @draw_length *= 0.6**gen
    @production = @grammar.generate gen
  end

  private

  ######################################################
  # draws line uDegLut.sing current turtle and length parameters
  # returns a turtle corresponding to the new position
  ######################################################

  def draw_line(turtle, length)
    new_xpos = turtle[XPOS] + length * DegLut.cos(turtle[ANGLE])
    new_ypos = turtle[YPOS] + length * DegLut.sin(turtle[ANGLE])
    line(turtle[XPOS], turtle[YPOS], new_xpos, new_ypos)
    [new_xpos, new_ypos, turtle[ANGLE]]
  end
end
