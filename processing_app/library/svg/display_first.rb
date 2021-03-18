load_library :svg

def settings
  size(400, 400)
end

def setup
  sketch_title 'Display First'
  no_loop
  begin_record(SVG, data_path('filename.svg'))
end

def draw
  # Draw something good here
  background 0, 0, 200
  fill 200, 0, 0
  ellipse(width / 2, height / 2, width * 0.9, height * 0.5)
  end_record
end
