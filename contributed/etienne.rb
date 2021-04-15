# After a sketch by Etienne Jacob @etiennejcb

NUM_FRAMES = 38

def setup
  sketch_title 'Etienne Sketch'
end

def periodic_function(p, seed, x, y)
  radius = 1.3
  scl = 0.018
  1.0 * noise(seed + radius * cos(TWO_PI * p), radius * sin(TWO_PI * p), scl * x, scl * y)
end

def offset(x, y)
  0.015 * dist(x, y, width / 2, height / 2)
end

def draw
  background(0)
  t = 1.0 * frame_count / NUM_FRAMES
  m = 450
  stroke(255, 50)
  stroke_weight(1.5)
  grid(m, m) do |i, j|
    margin = 50
    x = map1d(i, 0..m - 1, margin..width - margin)
    y = map1d(j, 0..m - 1, margin..height - margin)
    dx = 20.0 * periodic_function(t - offset(x, y), 0, x, y)
    dy = 20.0 * periodic_function(t - offset(x, y), 123, x, y)
    point(x + dx, y + dy)
  end
  save_frame(data_path('fr###.png')) if frame_count <= NUM_FRAMES
  return unless frame_count == NUM_FRAMES

  puts('All frames have been saved')
  stop
end

def settings
  size 500, 500
end
