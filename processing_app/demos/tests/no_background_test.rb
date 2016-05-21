def setup
  sketch_title 'No Background Test'
  background(255, 0, 0)
  fill(255, 150)
end

def draw
  ellipse(mouse_x, mouse_y, 100, 100) 
end

def settings
  size(400, 400, FX2D)
end
