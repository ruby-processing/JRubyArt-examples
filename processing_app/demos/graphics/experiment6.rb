AMOUNT = 2.5
SCALE = 0.03
RADIUS = 0.45
FRAMES = 100

def field(x, y)
  count = frame_count - 1
  value1 = 400.0 * noise(SCALE * x, SCALE * y, RADIUS * cos(TWO_PI * 1.0 * count / FRAMES),
                         RADIUS * sin(TWO_PI * 1.0 * count / FRAMES))
  value2 = 400.0 * noise(1000 + SCALE * x, SCALE * y, RADIUS * cos(TWO_PI * 1.0 * count / FRAMES),
                         RADIUS * sin(TWO_PI * 1.0 * count / FRAMES))
  # int value2 = (int) Math.round(value)
  parameter1 = value1 / FRAMES
  parameter2 = value2 / FRAMES
  # if(random(100)<1) println(parameter)
  Vec2D.new(AMOUNT * parameter1, AMOUNT * parameter2)
end

def settings
  size(500, 500)
end

def setup
  sketch_title 'Experiment 6'
end

def draw
  background(0)
  grid(width - 300, height - 300, 5, 5) do |i, j|
    stroke(255, 25)
    no_fill
    pos = Vec2D.new(i + 150, j + 150)
    point(pos.x, pos.y)
    200.times do
      res = field(pos.x, pos.y)
      res *= 0.15
      pos += res
      point(pos.x, pos.y)
    end
    point(pos.x, pos.y)
  end
  # puts frame_count
  save_frame(data_path('fr###.tiff'))

  return unless frame_count == FRAMES

  # save_frame(data_path('expt6.png'))
  no_loop
  puts 'finished'
end
