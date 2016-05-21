#
# Mirror 2
# by Daniel Shiffman.
#
# Each pixel from the video source is drawn as a rectangle with size based
# on brightness.

load_library :video
include_package 'processing.video'

CELL_SIZE = 15

attr_reader :cols, :rows, :video

def setup
  sketch_title 'Mirror2'
  # Set up columns and rows
  @cols = width / CELL_SIZE
  @rows = height / CELL_SIZE
  color_mode(RGB, 255, 255, 255, 100)
  rect_mode(CENTER)
  # This the default video input, see the GettingStartedCapture
  # example if it creates an error
  @video = Capture.new(self, width, height)
  # Start capturing the images from the camera
  video.start
  background(0)
end

def draw
  return unless video.available
  video.read
  video.load_pixels
  background(0, 0, 255)
  # Begin loop for columns
  cols.times do |i|
    # Begin loop for rows
    rows.times do |j|
      # Where are we, pixel-wise?
      x = i * CELL_SIZE
      y = j * CELL_SIZE
      # Reversing x to mirror the image
      loc = (video.width - x - 1) + y * video.width
      # Each rect is colored white with a size determined by brightness
      c = video.pixels[loc]
      sz = (brightness(c) / 255.0) * CELL_SIZE
      fill(255)
      no_stroke
      rect(x + CELL_SIZE / 2, y + CELL_SIZE / 2, sz, sz)
    end
  end
end

def settings
  size(960, 544, P2D)
end

