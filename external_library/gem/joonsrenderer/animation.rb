require 'joonsrenderer'
include_package 'joons'

attr_reader :jr, :eye, :center, :up, :count, :radius, :file_name

def settings
  size(800, 600, P3D)
end

def setup
  sketch_title 'Animation'
  @file_name = 'Animation'
  @jr = JoonsRenderer.new(self)
  # Camera Setting.
  @eye = Vec3D.new(0, 0, 120)
  @center = Vec3D.new(0, 0, -1)
  @up = Vec3D.new(0, 1, 0)
  @count = 0
  @radius = 35
end

def draw
  jr.render # The draw loop that comes next is rendered
  jr.begin_record # Make sure to include things you want rendered.
  kamera(eye: eye, center: center, up: up)
  perspektiv(fov: PI / 4.0, aspect_ratio: 4 / 3.0, near_z: 5, far_z: 10_000)
  jr.background('cornell_box', 100, 100, 100) # Cornell Box: width, height, depth.
  jr.background('gi_ambient_occlusion') # Global illumination.
  # Sun.
  translate(0, -15, 0)
  jr.fill('light', 1, 60, 60)
  sphere(5)
  # Planet, revolving at +3 degrees per frame.
  translate(radius * DegLut.cos(count * 3), 0, radius * DegLut.sin(count * 3))
  jr.fill('mirror')
  sphere(5)
  jr.end_record # Make sure to end record.
  # Display rendered image if render is completed, and the argument is true.
  jr.display_rendered(true)
  save_frame(format("%s%s", file_name, "_###.png"))
  @count += 1
  no_loop if (count > 120)
end
