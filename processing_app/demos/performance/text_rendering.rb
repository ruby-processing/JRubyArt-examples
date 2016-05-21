def setup
  sketch_title 'Text Rendering'
  fill(0)
end

def draw
  background(255)
  (0..10_000).each do
    x = rand(width)
    y = rand(height)
    text("HELLO", x, y)
  end
  puts(frame_rate) if (frame_count % 10).zero?
end

def settings
  size(800, 600, FX2D)
end
