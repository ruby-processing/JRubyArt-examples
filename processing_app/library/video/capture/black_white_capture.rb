# hold down mouse to see unfiltered output
load_libraries :video, :video_event

attr_reader :cam, :my_shader

def setup
  sketch_title 'Black & White Capture'
  @my_shader = load_shader(data_path('bwfrag.glsl'))
  start_capture
end

def start_capture
  @cam = Java::ProcessingVideo::Capture.new(self, "UVC Camera (046d:0825)")
  cam.start
end

def draw
  image(cam, 0, 0)
  return if mouse_pressed?
  filter(my_shader)
end

# using snake case to match java reflect method
def captureEvent(cam)
  cam.read
end

def settings
  size(480, 360, P2D)
end
