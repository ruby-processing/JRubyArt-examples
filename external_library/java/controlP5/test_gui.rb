load_libraries :controlP5, :gui

attr_reader :gui

def settings
  size 400, 400, P2D
end

def setup
  sketch_title 'Test Gui'
  @gui = Gui.new(self)
end

def draw
  background(200, 200, 200)
  push_matrix
  push_matrix
  fill(255, 255, 0)
  rect(gui.v1, 100, 60, 200)
  fill(0, 255, 110)
  rect(40, gui.v1, 320, 40)
  translate(200, 200)
  rotate(map1d(gui.v1, 100..300, -PI..PI))
  fill(255, 0, 128)
  rect(0, 0, 100, 100)
  pop_matrix
  translate(600, 100)
  20.times do |i|
    push_matrix
    fill(255)
    translate(0, i*10)
    rotate(map1d(gui.v1+i, 0..300, -PI..PI))
    rect(-150, 0, 300, 4)
    pop_matrix
  end
  pop_matrix
end
