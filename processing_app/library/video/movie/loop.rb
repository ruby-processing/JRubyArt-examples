# Loop.
#
# Shows how to load and play a QuickTime movie file.
#
#

load_libraries :video, :video_event
include_package 'processing.video'

attr_reader :movie

def setup
  sketch_title 'Loop'
  background(0)
  # Load and play the video in a loop
  @movie = Movie.new(self, 'transit.mov')
  movie.loop
end

def draw
  image(movie, 0, 0, width, height)
end

# use camel case to match java reflect method
def movieEvent(m)
  m.read
end

def settings
  size 640, 360, FX2D
end

