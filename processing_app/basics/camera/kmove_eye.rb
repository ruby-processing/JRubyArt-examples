# Move Eye. 
# Using kamera with keyword arguments
# cf processing camer
# 
# The camera lifts up (controlled by mouseY) while looking at the same point.

def setup
  sketch_title 'Move Eye Kamera'
  fill 204
end

def draw
  lights
  background 0    
  kamera eye: Vec3D.new(30, mouse_y, 220), center: Vec3D.new   
  no_stroke
  box 90
  stroke 255
  line( -100, 0, 0, 100, 0, 0)
  line( 0, -100, 0, 0, 100, 0)
  line( 0, 0, -100, 0, 0, 100)
end

def settings
  size 640, 360, P3D
end
