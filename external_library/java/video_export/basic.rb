load_library :VideoExport
include_package 'com.hamoid'

# Press 'q' to finish saving the movie and exit.

# In some systems, if you close your sketch by pressing ESC,
# by closing the window, or by pressing STOP, the resulting
# movie might be corrupted. If that happens to you, use
# video_export.end_movie like you see in this example.

# In some systems pressing ESC produces correct movies
# and .end_movie is not necessary.
attr_reader :video_export

def settings
  size(600, 600)
end

def setup
  sketch_title 'Basic Example'
  @video_export = VideoExport.new(self)
  video_export.start_movie
end

def draw
  background(color('#224488'))
  rect(frame_count * frame_count % width, 0, 40, height)
  video_export.save_frame
end

def key_pressed
  return unless (key == 'q')
  video_export.end_movie
  exit
end
