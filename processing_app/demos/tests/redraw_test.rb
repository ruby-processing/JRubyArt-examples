def setup
  sketch_title 'Redraw Test'
  no_loop
end

def draw
  background(255, 0, 0)
  ellipse(mouse_x, mouse_y, 100, 50)
  puts("draw")  
end

def key_pressed
  redraw
end

def settings
  size(400, 400, FX2D)
end
