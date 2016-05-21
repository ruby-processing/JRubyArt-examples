require 'cf3'
#######
# Simple example demonstrating rewind
# also how to make simple composite shapes
# from primitive terminals (revaluates on mouse clicked)
# valid hue = (0..360) hues values are added (or subtracted)
###

def settings
  size 400, 200
end

def setup
  sketch_title 'plus or cross'
  @stars = ContextFree.define do
    shape :stars do
      split do
        cross size: 0.5, x: -2
        rewind
        cross size: 0.5, x: 2, hue: 60
      end
    end

    shape :cross do # diagonal cross
      square w: 1, h: 3, rotation: -45
      square w: 1, h: 3, rotation: 45
    end

    shape :cross do # vertical cross
      square w: 1, h: 3
      square w: 1, h: 3, rotation: 90
    end
  end
end

def draw_it
  background 0.2
  @stars.render :stars, size: height/2, color: [rand(300), 1, 1, 1]
end

def draw
  # Do nothing.
end

def mouse_clicked
  draw_it
end
