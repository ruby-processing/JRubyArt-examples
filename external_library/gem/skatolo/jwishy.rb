require 'skatolo'
include EventMethod

VIEWPORT_W = 600
VIEWPORT_H = 600
GUI_X = 20
GUI_Y = 20
GUI_W = 200
SHAPES = %w[oval square triangle].freeze
attr_reader :skatolo, :back_color, :x_wiggle, :y_wiggle, :magnitude, :big

def setup
  sketch_title 'Wishy Worm'
  create_gui
  skatolo.update
  @shape = 'oval'
  @big = false
  @x_wiggle, @y_wiggle = 10.0, 0
  @magnitude = 8.15
  @back_color = [0.06, 0.03, 0.18]
  color_mode RGB, 1
  ellipse_mode CORNER
end

def draw_background
  back_color[3] = alpha_value
  fill(*back_color.to_java(:float))
  rect 0, 0, width - GUI_W, height
end

def reset!
  @y_wiggle = 0
  @shape = 'oval'
end

def toggle_big
  @big = !big
end

def random_shape
  srand
  @shape = SHAPES.sample
end

def draw
  draw_background
  # Seed the random numbers for consistent placement from frame to frame
  srand(0)
  horiz, vert, mag = x_wiggle, y_wiggle, magnitude

  if big
    mag *= 2
    vert /= 2
  end

  blu = bluish_value
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
  size VIEWPORT_W + GUI_W, VIEWPORT_H
end

def create_gui
  @skatolo = Skatolo.new(self)
  sx = 100
  sy = 14
  oy = (sy * 1.5).to_i
  ######################################
  # GUI - FLUID
  ######################################
  control = skatolo.add_group('control')
  control.set_title('Control Panel')
         .set_height(20)
         .set_size(GUI_W, VIEWPORT_H)
         .set_position(VIEWPORT_W, 0)
         .set_background_color(color(100))
         .set_color_background(color(100))
  px = 10
  py = 15
  skatolo.add_slider('bluish')
         .set_size(sx, sy)
         .set_position(px, py += oy)
         .set_range(0, 1.0)
         .set_value(0.5)
         .set_group(control)
  skatolo.add_slider('alpha')
         .set_size(sx, sy)
         .set_position(px, py += oy)
         .set_range(0, 1.0)
         .set_value(0.5)
         .set_group(control)
  skatolo.add_button('toggle_big')
         .set_size(sx, 15)
         .set_position(px, py += oy)
         .set_group(control)
  skatolo.add_button('reset!')
         .set_size(sx, 15)
         .set_position(px, py += oy)
         .set_group(control)
  skatolo.add_button('random_shape')
         .set_size(sx, 15)
         .set_position(px, py += oy)
         .set_group(control)
end
