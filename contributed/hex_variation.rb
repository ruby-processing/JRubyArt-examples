
# Part of the ReCode Project (http://recodeproject.com)
# Based on "Hex Variation" by William Kolmyjec
# Originally published in "Computer Graphics and Art" vol3 no4, 1978
# Copyright (c) 2012 Steve Berrick - OSI/MIT license (http://recodeproject/license).
SIZE = 20 # hexagon radius
ANGLES = [0, THIRD_PI, THIRD_PI * 2].freeze

def setup
  sketch_title 'Hex Variation'
  no_loop
  no_fill
  stroke(0)
  stroke_weight(2)
end

def draw
  # clear background
  background(255)
  # line length (hypotenuse)
  h = sin(THIRD_PI) * SIZE
  jsize = height  / h
  isize = width / (3 * SIZE)
  grid(isize, 2 + jsize.to_i) do |i, j|
    # reference points (centre of each hexagon)
    x = i * SIZE * 3 + (SIZE / 2)
    y = j * h
    # offset each odd row
    x += SIZE * 1.5 unless (j % 2).zero?
    push_matrix
    translate(x, y)
    # random hexagon rotation (0, 120, 240 degrees)
    rotate(ANGLES.sample)
    # draw line
    line(0, -h, 0, h)
    # draw arcs
    arc(-SIZE, 0, SIZE, SIZE, -THIRD_PI,     THIRD_PI)
    arc( SIZE, 0, SIZE, SIZE,  THIRD_PI * 2, THIRD_PI * 4)
    pop_matrix
  end
end

def mouse_pressed
  redraw
end

def settings
  size 600, 900
end
