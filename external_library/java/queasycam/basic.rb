load_library :queasycam
include_package 'queasycam'

def settings
  size(400, 400, P3D)
end

def setup
  sketch_title 'Basic Queasy Camera'
  QueasyCam.new(self)
  stroke_weight 3
end

def draw
  background 0
  box 200
end
