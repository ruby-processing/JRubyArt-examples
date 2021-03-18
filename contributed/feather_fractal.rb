A = -0.48
B = 0.93

def settings
  size(640, 480)
end

def setup
  background(235, 215, 182)
  color_mode(HSB, 360, 1.0, 1.0)
  stroke(0)
  sketch_title 'Fantastic Feather Fractal'
  no_loop
end

def draw
  x = 4.0
  y = 0.0
  120_000.times do |i|
    x1 = B * y + func(x)
    y = -x + func(x1)
    x = x1
    fill(i % 360, 1.0, 1.0)
    p = 350 + x * 26
    q = 280 - y * 26
    circle(p, q, 5)
  end
end

def func(x)
  A * x - (1.0 - A) * ((2 * (x**2)) / (1.0 + x**2))
end
