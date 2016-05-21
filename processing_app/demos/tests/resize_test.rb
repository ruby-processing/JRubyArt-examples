field_reader :surface # need field_reader to access surface

def setup
  sketch_title 'Resize Test'
  surface.set_resizable true
end

def draw
  background(255, 0, 0)
  ellipse(width / 2, height / 2, 100, 50) 
end

def settings
  size(400, 400, FX2D)
end
