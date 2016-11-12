# This one has a long lineage:
# It was originally adapted to Shoes in Ruby,
# from a Python example for Nodebox, and then, now
# to JRubyArt.

# For fun, try running it using live mode, and
# playing with the attr_accessors, as
# well as the background.

# This example now demonstrates the use of the control_panel.

# -- omygawshkenas

load_library :control_panel

attr_reader :alpha, :back_color, :bluish, :hide, :magnitude, :panel
attr_reader :x_wiggle, :y_wiggle

def setup
  sketch_title 'Wishy Worm'
  control_panel do |c|
    c.title = 'Control Panel'
    c.look_feel 'Nimbus'
    c.slider    :bluish, 0.0..1.0, 0.5
    c.slider    :alpha,  0.0..1.0, 0.5
    c.checkbox  :go_big
    c.button    :reset
    c.menu      :shape, %w(oval square triangle)
    @panel = c
  end
  @hide = false
  @shape = 'oval'
  @go_big = false
  @x_wiggle, @y_wiggle = 10.0, 0
  @magnitude = 8.15
  @back_color = [0.06, 0.03, 0.18]
  color_mode RGB, 1
  ellipse_mode CORNER
  smooth
end

def draw_background
  back_color[3] = alpha
  fill(*back_color.to_java(:float))
  rect 0, 0, width, height
end

def reset
  @y_wiggle = 0
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  draw_background

  # Seed the random numbers for consistent placement from frame to frame
  srand(0)
  horiz, vert, mag = x_wiggle, y_wiggle, magnitude

  if @go_big
    mag *= 2
    vert /= 2
  end

  blu = bluish
  x, y = (width / 2), -27
  c = 0.0

  64.times do
    x += cos(horiz) * mag
    y += log10(vert) * mag + sin(vert) * 2
    fill(sin(y_wiggle + c), rand * 0.2, rand * blu, 0.5)
    s = 42 + cos(vert) * 17
    args = [@shape, x - s / 2, y - s / 2, s, s]
    draw_shape(args)
    vert += rand * 0.25
    horiz += rand * 0.25
    c += 0.1
  end

  @x_wiggle += 0.05
  @y_wiggle += 0.1
end

def mouse_pressed
  return unless hide
  @hide = false
end

def draw_shape(args)
  case args[0]
  when 'triangle'
    draw_triangle(args)
  when 'square'
    rect(args[1], args[2], args[3], args[4])
  else
    oval(args[1], args[2], args[3], args[4]) # ellipse alias
  end
end

def draw_triangle(args)
  x2 = args[1] + (args[3] * 0.6)
  y0 = args[2] + (args[4] * 0.396)
  y1 = args[2] - (args[4] * 0.792)
  y2 = args[2] + (args[4] * 0.396)
  triangle(args[1] - (args[3] * 0.6), y0, args[1], y1, x2, y2)
end

def settings
  size 600, 600
end
