# Because this sketch uses a glsl shader it needs to run using
# jruby-complete (typically rp5 --nojruby sketch.rb)
# hold down mouse to see unfiltered output
load_libraries :video, :video_event
include_package 'processing.video'
attr_reader :cam, :my_shader

def setup
  sketch_title 'Steinberg'
  @my_shader = load_shader('steinberg.glsl')
  my_shader.set('sketchSize', width.to_java(Java::float), height.to_java(Java::float))
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

# using snake case to match java reflect method
def captureEvent(c)
  c.read
end

def settings
  size(640, 480, P2D)
end
