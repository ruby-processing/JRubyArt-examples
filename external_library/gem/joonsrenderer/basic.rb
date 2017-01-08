require 'joonsrenderer'
include_package 'joons'


attr_reader :jr, :eye, :center, :up

def settings
  size 800, 600, P3D
end

def setup
  sketch_title 'My Sketch'
  @jr = JoonsRenderer.new(self)
  # Camera Setting.
  @eye = Vec3D.new(0, 0, 120)
  @center = Vec3D.new(0, 0, -1)
  @up = Vec3D.new(0, 1, 0)
end

def draw
  jr.begin_record # Make sure to include things you want rendered.
  kamera(eye: eye, center: center, up: up)
  perspektiv(fov: PI / 4.0, aspect_ratio: 4 / 3.0, near_z: 5, far_z: 10_000)
  jr.background('cornell_box', 100, 100, 100) # Cornell Box: width, height, depth.
  jr.background('gi_instant') # Global illumination.
  translate(0, 10, -10)
  rotate_y(-PI / 8)
  rotate_x(-PI / 8)
  jr.fill('diffuse', 255, 255, 255)
  box(20)
  jr.end_record # Make sure to end record.
  jr.display_rendered(true) # Display rendered image if render is completed, and the argument is true.
end

def key_pressed
  jr.render if (key == 'r' || key == 'R')  # Press 'r' key to start rendering.
end
