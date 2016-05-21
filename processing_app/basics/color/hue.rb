# encoding: utf-8
# frozen_string_literal: true
# Hue is the color reflected from or transmitted through an object
# typically referred to as the name of the color (red, blue, yellow, etc.)
# Move the cursor vertically over each bar to alter its hue.
#

attr_reader :bar_width, :bar_height, :last_bar

def settings
  size(640, 360)
end

def setup
  sketch_title 'Hue'
  @bar_width = 20
  @last_bar = -1
  no_stroke
  background(0)
end

def draw
  which_bar = mouse_x / bar_width
  if which_bar != last_bar
    bar_x = which_bar * bar_width
    fill(
      hsb_color( # JRubyArt convenience method returns a RGB color int
        norm(mouse_y, 0, 360), # normalize mouse height
        1.0,
        1.0
      )
    )
    rect(bar_x, 0, bar_width, height)
    @last_bar = which_bar
  end
end
