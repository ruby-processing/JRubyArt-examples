# Using struct for turtle/pen
Turtle = Struct.new(:position, :angle, :color)

#############################
# PenroseColored class
#############################
class PenroseColored
  include Processing::Proxy

  attr_reader :axiom, :grammar, :start_length, :theta, :production,
  :draw_length, :repeats, :pos

  DELTA = PI / 5  # degrees
  RED = 70<<24|200<<16|0<<8|0 # using bit operations to set color int
  BLUE = 70<<24|0<<16|0<<8|200 # NB colors have degree of alpha/transparency

  def initialize(pos) # Note use of abbreviated grammar
    @axiom = '[X]2+[X]2+[X]2+[X]2+[X]' # nos, used to indicate repeats
    @grammar = Grammar.new(
      axiom,
      'F' => '',  # a so called deletion rule
      'W' => 'YBF2+ZRF4-XBF[-YBF4-WRF]2+',
      'X' => '+YBF2-ZRF[3-WRF2-XBF]+',
      'Y' => '-WRF2+XBF[3+YBF2+ZRF]-',
      'Z' => '2-YBF4+WRF[+ZRF4+XBF]2-XBF')
    @start_length = 1000.0
    @theta = 0
    @pos = pos
    @production = axiom.split('')
    @draw_length = start_length
  end

  ##############################################################################
  # Not strictly in the spirit of either processing in my render
  # function I have ignored the processing translate/rotate functions in favour
  # of the direct calculation of the new x and y positions, thus avoiding such
  # affine transformations.
  ##############################################################################

  def render
    repeats = 1
    ignored = %w[W X Y Z]
    repeated = %w[1 2 3 4]
    pen = Turtle.new(pos, theta, RED) # simple Struct for pen, symbol
    stack = [] # simple array for stack
    production.each do |element|
      case element
      when 'F'
        pen = draw_line(pen, draw_length)
      when '+'
        pen.angle += DELTA * repeats
        repeats = 1
      when '-'
        pen.angle -= DELTA * repeats
        repeats = 1
      when '['
        stack << pen.dup # push a copy current pen to stack
      when ']'
        pen = stack.pop # assign current pen to instance off the stack
      when 'R'
        pen.color = RED
      when 'B'
        pen.color = BLUE
      when *ignored
      when *repeated
        repeats = element.to_i
      else puts format('Character %s not in grammar', element)
      end
    end
  end
  #####################################################
  # create grammar from axiom and # rules (adjust scale)
  #####################################################

  def create_grammar(gen)
    @draw_length *= 0.5**gen
    @production = grammar.generate gen
  end

  private

  ####################################################################
  # draws line using current pen position, angle, color and length
  # parameters returns a pen corresponding to the new position
  # makes use of Vec2D from_angle costructor
  ###################################################################

  def draw_line(pen, length)
    stroke(pen.color)
    pos = pen.position
    new_pos = pos - Vec2D.from_angle(pen.angle) * length
    line(pos.x, pos.y, new_pos.x, new_pos.y) # draw line
    Turtle.new(new_pos, pen.angle, pen.color) # return pen @ new pos
  end
end
