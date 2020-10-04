load_library :video, :video_event
include_package 'processing.video'
attr_reader :cam, :my_filter, :origin

def settings
  size(1280, 960, P2D)
end

def setup
  sketch_title 'Droste'
  @origin = Time.now
  @my_filter = load_shader(data_path('droste.glsl'))
  my_filter.set('resolution', width.to_f, height.to_f)
  start_capture
end

def time
  (Time.now - origin)
end

def start_capture
  @cam = Java::ProcessingVideo::Capture.new(self, "UVC Camera (046d:0825)")
  cam.start
end

# using snake case to match java reflect method
def captureEvent(cam)
  cam.read
end

def draw
  background 0
  image(cam, 0, 0, width, height)
  my_filter.set('time', time)
  return if mouse_pressed?
  filter(my_filter)
end
