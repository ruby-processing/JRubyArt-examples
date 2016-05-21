# Move the mouse left and right to change the field of view (fov).
# Click to modify the aspect ratio. The perspektiv method
# sets a perspective projection applying foreshortening, making 
# distant objects appear smaller than closer ones. The parameters 
# define a viewing volume with the shape of truncated pyramid. 
# while farther objects appear smaller. This projection simulates 
# the perspective of the world more accurately than orthographic projection. 
# The version of perspektiv without parameters sets the default 
# perspective and the version with up to four parameters allows the programmer 
# to set the environment more precisely.

attr_reader :aspect

def setup
  sketch_title 'Perspektiv Example'
  ArcBall.constrain self
  @aspect = width.to_f / height 
  no_stroke
end

def draw
  lights
  background 204
  camera_y = height / 2.0
  fov = mouse_x / width.to_f * PI / 2.0
  camera_z = camera_y / Math.tan(fov / 2.0)
  perspektiv(
    fov: fov, 
    aspect_ratio: aspect, 
    near_z: camera_z / 10.0, 
    far_z: camera_z * 10.0
  )  
  rotate_x -PI / 6
  box 45
  translate 0, 0, -50
  box 30
end

def settings
  size 640, 360, P3D
end

def key_pressed
  case key
  when ' '
    @aspect = width * 0.5 / height 
  when 'n', 'N'
    @aspect = width.to_f / height 
  end
end
