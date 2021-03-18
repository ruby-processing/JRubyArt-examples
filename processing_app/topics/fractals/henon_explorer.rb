load_library :control_panel
H = 0.02
MAX = 10.0e+9
attr_reader :a, :cosa, :sina, :points, :center, :choice, :modulo

def settings
  size(500, 500)
end

def setup
  sketch_title 'Henon Phase Diagram Explorer'
  control_panel do |c|
    c.title 'Select a'
    c.look_feel 'Nimbus'
    c.menu(:choice, %w[-10 1.2 1.6 1.57 2.0 2.2], '2.0') { |m| m }
    c.checkbox :modulo
    c.button :reset!
  end
  @modulo = false
  @center = Vec2D.new(width / 2, height / 2)
  color_mode HSB, 350, 1.0, 1.0
  reset!
end

def reset!
  calculate
  redraw
end

def calculate(x0 = 0.01, y0 = -0.02)
  x = x0
  y = y0
  @a = choice.to_f
  @cosa = cos(a)
  @sina = sin(a)
  @points = []
  funcx = if modulo
            ->(cx) { cx * cx.abs }
          else
            ->(cx) { cx * cx }
          end
  (0..50).each do |j|
    1500.times do
      next unless (x < MAX) && (y < MAX)

      x1 = x * cosa - (y - funcx.call(x)) * sina
      y = x * sina + (y - funcx.call(x)) * cosa
      x = x1
      points << Vec2D.new((x + 1.25) * 180, (1.4 - y) * 180)
    end
    x = x0 + j * H
    y = y0 + j * H
  end
end

def draw
  background 100
  points.each do |pos|
    fill(center.dist(pos), 1.0, 1.0)
    circle(pos.x, pos.y, 2)
  end
  fill(10, 1, 1)
  text_size(14)
  mod = 'x * |x|'
  text(mod, 10, 30) if modulo
  msg = format('Quadratic Henon-Equation for a = %3.4f', a)
  text(msg, 10, height - 30)
  img = format('henon_%3.4f.jpg', a)
  save_frame(data_path(img))
  no_loop
end
