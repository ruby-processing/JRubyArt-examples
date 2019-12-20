# frozen_string_literal: true

# simple class for drawing the gui
class Rect
  include Processing::Proxy
  attr_reader :x, :y, :w, :h, :steps, :stepId

  def initialize(_x, _y, _steps, _id)
    @x = _x
    @y = _y
    @w = 14
    @h = 30
    @steps = _steps
    @stepId = _id
  end

  def draw
    steps[stepId] ? fill(0, 255, 0) : fill(255, 0, 0)
    rect(x, y, w, h)
  end

  def mouse_pressed
    if mouse_x >= x && mouse_x <= x + w && mouse_y >= y && mouse_y <= y + h
      steps[stepId] = !steps[stepId]
    end
  end
end
