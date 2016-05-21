# Simple 3D Bird
# by Ira Greenberg.
#
# Using a box and 2 rects to simulate a flying bird.
# Trig functions handle the flapping and sinuous movement.
attr_reader :ang, :ang2, :ang3, :ang4, :flap_speed

def setup
  sketch_title 'Bird'
  no_stroke
  @ang, @ang2, @ang3, @ang4 = 0.0, 0.0, 0.0, 0.0
  @flap_speed = 0.2
end

def draw
  background 0
  lights
  px = DegLut.sin(ang3) * 170
  py = DegLut.cos(ang3) * 300
  pz = DegLut.sin(ang4) * 500
  translate width / 2 + px, height / 2 + py, -700 + pz
  rotate_x DegLut.sin(ang2) * 120
  rotate_y DegLut.sin(ang2) * 50
  rotate_z DegLut.sin(ang2) * 65
  fill 153
  box 20, 100, 20
  fill 204
  push_matrix
  rotate_y DegLut.sin(ang) * -20
  rect(-75, -50, 75, 100)
  pop_matrix
  push_matrix
  rotate_y DegLut.sin(ang) * 20
  rect 0, -50, 75, 100
  pop_matrix
  @ang += flap_speed
  @flap_speed *= -1 if ang.abs > PI
  @ang2 += 0.01
  @ang3 += 2.0
  @ang4 += 0.75
end

def settings
  size 640, 360, P3D
end
