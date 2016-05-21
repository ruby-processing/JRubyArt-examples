
# Hold mouse click to disable the filter temporarily

# The videoclip is from NASA: http://youtu.be/CBwdZ1yloHA

load_library :video, :video_event
include_package 'processing.video'

attr_reader :movie, :my_shader

def setup
  sketch_title 'NTSC'
  # Load and play the video in a loop
  @movie = Movie.new(self, 'iss.mov')
  movie.loop
  # Load and configure the shader
  @my_shader = load_shader('shader.glsl')
  my_shader.set('sketchSize', width.to_f, height.to_f)
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

