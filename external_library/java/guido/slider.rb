load_library :guido
include_package 'de.bezier.guido'

# see https://github.com/fjenett/Guido/

def settings
  size 400, 400
end

def setup
  sketch_title 'Guido Slider'
  Interactive.make self
  @slider = Slider.new x: 10, y: height - 20, w: width - 20, h: 10
end

def draw
  background 180
  fill 255
  v = 10 + @slider.value * (width - 30)
  ellipse width / 2, height / 2, v, v
end

# Slider class
class Slider < ActiveElement
  attr_reader :value, :width, :height, :x, :y

  def initialize(x:, y:, w:, h:)
    super x, y, w, h
    @x = x
    @y = y
    @width = w
    @height = h
    @hover = false
    @value = 0
    @value_x = x
  end

  def mouseEntered(_mx, _my)
    @hover = true
  end

  def mouseExited(_mx, _my)
    @hover = false
  end

  def mouseDragged(mx, _my, _dx, _dy)
    @value_x = mx - height / 2
    @value_x = x if @value_x < x
    @value_x = x + @width - @height if @value_x > x + width - height
    @value = norm(@value_x, x, x + width - height)
  end

  def draw
    no_stroke
    fill @hover ? 220 : 150
    rect @x, @y, width, height
    fill 120
    rect @value_x, @y, height, height
  end
end
