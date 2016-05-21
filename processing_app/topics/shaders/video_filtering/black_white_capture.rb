load_library :video, :video_event
include_package 'processing.video'
attr_reader :cam, :my_shader

def setup
  sketch_title 'Black White Capture'
  @my_shader = load_shader('bwfrag.glsl')
  start_capture(width, height)
end

def start_capture(w, h)
  @cam = Capture.new(self, w, h)
  cam.start
end

def draw
  image(cam, 0, 0)
  return if mouse_pressed?
  filter(my_shader)
end

def captureEvent(c)
  c.read
end

def settings
  size(640, 480, P2D)
end
