load_library :glvideo
include_package 'gohai.glvideo'
attr_reader :cam, :my_filter, :origin

def settings
  size(1280, 960, P2D)
end

def setup
  sketch_title 'Droste'
  @origin = Time.now
  @my_filter = load_shader(data_path('droste.glsl'))
  my_filter.set('sketchSize', width.to_f, height.to_f)
  start_capture
end

def time
  (Time.now - origin) * 0.5
end

def start_capture
  @cam = GLCapture.new(self)
  cam.start
end

def draw
  background 0
  cam.read if cam.available
  image(cam, 0, 0, width, height)
  my_filter.set('globalTime', time)
  return if mouse_pressed?
  filter(my_filter)
end
