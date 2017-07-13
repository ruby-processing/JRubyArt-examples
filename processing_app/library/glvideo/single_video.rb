load_library :glvideo

include_package 'gohai.glvideo'

attr_reader :video

def setup
  sketch_title 'Single Video'
  @video = GLMovie.new(self, data_path('launch1.mp4'))
  video.loop
end

def draw
  background(0)
  video.read if video.available
  image(video, 0, 0, width, height)
end

def settings
  size(560, 406, P2D)
end
