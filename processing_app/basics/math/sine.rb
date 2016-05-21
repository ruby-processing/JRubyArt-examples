# Sine.
#

def setup
  sketch_title 'Sine'
  no_stroke
  @diameter = 84.0
  @sin = 0.0
  @angle = 0.0
  @rad_points = 90
end

def draw
  background 153
  translate width / 2, height / 2
  fill 255
  ellipse 0, 0, 16, 16
  angle_rot = 0.0
  fill 51
  (0...5).each do |i|
    push_matrix
    rotate angle_rot - 45
    ellipse(-116, 0, @diameter, @diameter)
    pop_matrix
    angle_rot += TAU / 5
  end
  @diameter = 34 * Math.sin(@angle) + 168
  @angle += 0.02
  #@angle = 0.0 if @angle > TAU
end

def settings
  size 640, 360
end
