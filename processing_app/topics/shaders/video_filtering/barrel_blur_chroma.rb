# Hold mouse click to disable the filter temporarily
# The videoclip is from NASA: http://youtu.be/CBwdZ1yloHA

load_library :video, :video_event
include_package 'processing.video'

attr_reader :movie, :my_shader

# How much barrel effect do we want?
# Values between 0.5 and 3.0 work best, but feel free to try other values
BARREL = 2.2

def setup
  sketch_title 'Barrel Blur Chroma'
  # Load and play the video in a loop
  @movie = Movie.new(self, 'iss.mov')
  movie.loop
  # Load and configure the shader
  @my_shader = load_shader('barrel_blur.glsl')
  my_shader.set('sketchSize', width.to_f, height.to_f)
  my_shader.set('barrelPower', BARREL)
end

def draw
  image(movie, 0, 0, width, height)
  return if mouse_pressed?
  filter(my_shader)
end

def movieEvent(m)
  m.read
end

def settings
  size(640, 360, P2D)
end
