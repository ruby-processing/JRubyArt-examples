load_library :glvideo

include_package 'gohai.glvideo'
attr_reader :video

def settings
  size(320, 240, P2D)
end

def setup
  sketch_title 'Simple Capture'
  report_config
  #  this will use the first recognized camera by default
  @video = GLCapture.new(self)
  # you could be more specific also, e.g.
  # video = GLCapture.new(self, devices[0])
  # video = GLCapture.new(self, devices[0], 640, 480, 25)
  # video = GLCapture.new(self, devices[0], configs[0])
  video.play
end

def draw
  background 0
  video.read if video.available
  image(video, 0, 0, width, height)
end

def report_config
  devices = GLCapture.list
  puts('Devices:')
  devices.each { |dev| puts dev }
  if (0 < devices.length)
    configs = GLCapture.configs(devices[0]).to_a # ruby array
    puts('Configs:')
    configs.map { |cam| puts cam.strip }
  end
end
