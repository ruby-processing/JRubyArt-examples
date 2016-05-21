############################
# Use mouse drag to rotate
# the arcball. Use mousewheel
# to zoom. Constrained to
# rotation around z-axis
############################

def setup
  sketch_title 'Arcball Box'
  ArcBall.constrain self, :zaxis
  fill 180
end

def draw
  background 50 
  box 300, 300, 300
end

def settings
  size 600, 600, P3D
  smooth 8
end
