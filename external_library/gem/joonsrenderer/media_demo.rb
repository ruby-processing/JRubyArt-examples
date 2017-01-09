require 'joonsrenderer'
include_package 'joons'

attr_reader :jr, :eye, :center, :up

def setup
  sketch_title 'Test'
  @jr = JoonsRenderer.new(self)
  jr.set_sampler('ipr') # Rendering mode, either 'ipr' or 'bucket'.
  jr.set_size_multiplier(2) # Set size of PNG file as a multiple of Processing sketch size.
  jr.setAA(-2, 0) # Set anti aliasing, (aaMin, aaMax, aaSamples). aaMin & aaMax = .. -2, -1, .. , 1, 2 .. aaMin < aaMax.
  jr.set_caustics(10) # Set caustics. 1, 5, 10 .., affects quality of light reflected & refracted through glass.
  # Camera Setting.
  @eye = Vec3D.new(0, 0, 120)
  @center = Vec3D.new(0, 0, -1)
  @up = Vec3D.new(0, 1, 0)
end

def draw
  jr.begin_record # Make sure to include things you want rendered.
  kamera(eye: eye, center: center, up: up)
  perspektiv(fov: PI / 4.0, aspect_ratio: 4 / 3.0, near_z: 5, far_z: 10_000)
  jr.background('gi_instant') # Global illumination.
  jr.background('cornell_box', 100, 100, 100) # Cornell box, width, height, depth.
  push_matrix
  translate(-40, 20, -20)
  push_matrix
  rotateY(-PI / 8)
  # jr.fill('light', r, g, b)
  jr.fill('light', 5, 5, 5)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('mirror', r, g, b)
  jr.fill('mirror', 255, 255, 255)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('diffuse', r, g, b)
  jr.fill('diffuse', 150, 255, 255)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('shiny', r, g, b, shininess)
  jr.fill('shiny', 150, 255, 255, 0.1)
  sphere(13)
  translate(27, 0, 0)
  pop_matrix
  rotateY(PI / 8)
  translate(-10, -27, 30)
  # jr.fill('ambient occlusion', bright r, g, b, dark r, g, b, maximum distance, int samples)
  jr.fill('ambient_occlusion', 150, 255, 255, 0, 0, 255, 50, 16)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('phong', r, g, b)
  jr.fill('phong', 150, 255, 255)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('glass', r, g, b)
  jr.fill('glass', 255, 255, 255)
  sphere(13)
  translate(27, 0, 0)
  # jr.fill('constant', r, g, b)
  jr.fill('constant', 150, 255, 255)
  sphere(13)
  pop_matrix
  jr.end_record # Make sure to end record.
  # Display rendered image if render is completed, and the argument is true.
  jr.display_rendered(true)
end

def key_pressed
  jr.render if (key == 'r' || key == 'R')  # Press 'r' key to start rendering.
end

def settings
  size(800, 600, P3D)
end
