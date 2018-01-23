require 'geomerative'

# Declare the objects we are going to use, so that they are accesible from setup() and from draw()
attr_reader :grp

def settings
  size(600, 400)
end

def setup
  sketch_title 'Hola Mundo'
  RG.init(self)
  background(255)
  fill(255, 102, 0)
  stroke(0)
  @grp = RG.getText('Hola Mundo!', data_path('FreeSans.ttf'), 72, CENTER)
end

def draw
  background(255)
  translate(width / 2, height / 2)
  grp.draw
end
