def setup
  sketch_title 'Random Anwhere'
  background 255
end

def draw
  no_loop if frame_count > 64
  line(rand(0..width), rand(0..height), rand(0..width), rand(0..height))
end

def settings
  size 200, 200
end
