# Move Eye. 
# by Simon Greenwold.
# 
# The camera lifts up (controlled by mouseY) while looking at the same point.

def setup
  sketch_title 'Move Eye'
  fill 204
end

def draw
  lights
  background 0    
  camera 30, mouse_y, 220, 0, 0, 0, 0, 1, 0    
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
