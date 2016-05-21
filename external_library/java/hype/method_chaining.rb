# encoding: utf-8
load_library :hype
include_package 'hype'

def settings
  size(640, 640)
end

def setup
  sketch_title('Method Chaining')
  H.init(self)
  H.background(color('#242424'))
  rect1 = HRect.new(100)
  rect1.rounding(10) # set corner rounding
  rect1.stroke_weight(6) # set stroke weight
  rect1.stroke(color('#000000'), 150) # set stroke color and alpha
  rect1.fill(color('#FF6600')) # set fill color
  rect1.anchor_at(H::CENTER) # set where anchor point is / key point for rotation and positioning
  rect1.rotation(45) # set rotation of the rect
  rect1.loc(100, height / 2) # set x and y location
  H.add(rect1)

  # here's the same code / with method chaining

  rect2 = HRect.new(100)
  rect2.rounding(10)
       .stroke_weight(6)
       .stroke(color('#000000'), 150)
       .fill(color('#FF9900'))
       .anchor_at(H::CENTER)
       .rotation(45)
       .loc(247, height / 2)
  H.add(rect2)

  # here's the same code / minus the hard returns and indentation (tabs are bad)

  rect3 = HRect.new(100)
  rect3.rounding(10).stroke_weight(6).stroke(color('#000000'), 150).fill(color('#FFCC00')).anchor_at(H::CENTER).rotation(45).loc(394, height / 2)
  H.add(rect3)

  H.draw_stage # paint the stage

  # here is the non HYPE version / basic processing syntax

  push_matrix
  stroke_weight(6)
  stroke(color('#000000'), 150)
  fill(color('#FF3300'))
  translate(width - 100, (height / 2))
  rotate(45.radians)
  rect(0, 0, 100, 100, 10, 10, 10, 10)
  pop_matrix
  stroke_weight(1)
  stroke(color('#0095a8'))
  line(0, height / 2, width, height / 2)
end
