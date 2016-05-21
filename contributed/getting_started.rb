# Let's define a setup method, for code that gets
# run one time when the app is started.
attr_reader :rotation

def setup
  sketch_title 'Getting Started'
  background 0
  no_stroke
  @rotation = 0
end

def draw
  fill 0, 20
  rect 0, 0, width, height  
  translate width / 2, height / 2
  rotate rotation
  fill 255
  ellipse 0, -60, 20, 20
  @rotation += 0.1
end

def settings
  size 200, 200
  smooth
end
