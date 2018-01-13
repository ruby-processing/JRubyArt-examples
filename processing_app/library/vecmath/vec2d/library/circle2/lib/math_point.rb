# frozen_string_literal: true
# In processing the Y-axis is inverted, plus we have a fake origin for display
# pos is the position in the Math World, which we need to translate to sketch
class MathPoint
  include Processing::Proxy # to access sketch methods, including height
  OR = 40.0
  FORM = '(%d, %d)'.freeze
  attr_reader :pos, :from_mouse
  def initialize(pos = Vec2D.new)
    @pos = pos
    @from_mouse = false
  end

  def from_sketch(x, y)
    @from_mouse = true
    @pos = Vec2D.new(x - OR, map1d(y, height - OR..-OR, 0..height))
    self
  end

  def xpos
    pos.x
  end

  def ypos
    pos.y
  end

  def screen_x
    pos.x + OR
  end

  def screen_y
    map1d(pos.y, 0..height, height - OR..-OR)
  end

  def display
    fill 200
    no_stroke
    ellipse(screen_x, screen_y, 2.5, 2.5)
    display_text
    return unless from_mouse
    no_fill
    stroke(200, 0, 0)
    ellipse(screen_x, screen_y, 5, 5)
  end

  private

  def display_text
    from_mouse ? fill(255, 255, 0) : fill(0, 255, 0)
    text_font(font, 12)
    text(format(FORM, xpos.round, ypos.round), screen_x + 5, screen_y - 5)
  end
end
