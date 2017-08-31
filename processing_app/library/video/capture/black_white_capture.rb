# hold down mouse to see unfiltered output
load_libraries :video, :video_event

attr_reader :cam, :my_shader

def setup
  sketch_title 'Black & White Capture'
  @my_shader = load_shader(data_path('bwfrag.glsl'))
  start_capture(width, height)
end

def start_capture(w, h)
  @cam = Java::ProcessingVideo::Capture.new(self, w, h)
  cam.start
end

def draw
  image(cam, 0, 0)
  return if mouse_pressed?
  filter(my_shader)
end

# using snake case to match java reflect method
def captureEvent(c)
  c.read
end

def settings
  size(960, 544, P2D)
end
