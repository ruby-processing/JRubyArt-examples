load_library :video, :video_event

include_package 'processing.video'

attr_reader :cam

def setup
  sketch_title 'Test Capture'
  cameras = Capture.list
  fail 'There are no cameras available for capture.' if (cameras.length == 0)
  p 'Matching cameras available:'
  size_pattern = Regexp.new(format('%dx%d', width, height))
  select = cameras.grep size_pattern # filter available cameras
  select.uniq.map { |cam| p cam.strip }
  fail 'There are no matching cameras.' if (select.length == 0)
  start_capture(select[0])
end

def start_capture(cam_string)
  # The camera can be initialized directly using an
  # element from the array returned by list:
  @cam = Capture.new(self, cam_string)
  p format('Using camera %s', cam_string)
  cam.start
end

def draw
  image(cam, 0, 0, width, height)
  # The following does the same, and is faster when just drawing the image
  # without any additional resizing, transformations, or tint.
  # set(0, 0, cam)
end

def captureEvent(c)
  c.read
end

def settings
  size 960, 544, P2D
end

