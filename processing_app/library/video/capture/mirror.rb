#
# Mirror
# by Daniel Shiffman.
#
# Each pixel from the video source is drawn as a rectangle with rotation
# based on brightness.

load_library :video
include_package 'processing.video'

# Size of each cell in the grid
CELL_SIZE = 20

# Variable for capture device
attr_reader :cols, :rows, :video

def setup
  sketch_title 'Mirror'
  frameRate(30)
  @cols = width / CELL_SIZE
  @rows = height / CELL_SIZE
  color_mode(RGB, 255, 255, 255, 100)
  @video = Java::ProcessingVideo::Capture.new(self, width, height)
  # Start capturing the images from the camera
  video.start
  background(0)
end

def draw
  video.load_pixels
  # Begin loop for columns
  cols.times do |i|
    # Begin loop for rows
    rows.times do |j|
      # Where are we, pixel-wise?
      x = i * CELL_SIZE
      y = j * CELL_SIZE
      # Reversing x to mirror the image
      loc = (video.width - x - 1) + y * video.width
      r = red(video.pixels[loc])
      g = green(video.pixels[loc])
      b = blue(video.pixels[loc])
      # Make a new color with an alpha component
      c = color(r, g, b, 75)
      # Code for drawing a single rect
      # Using translate in order for rotation to work properly
      push_matrix
      translate(x + CELL_SIZE / 2, y + CELL_SIZE / 2)
      # Rotation formula based on brightness
      rotate((2 * PI * brightness(c) / 255.0))
      rect_mode(CENTER)
      fill(c)
      no_stroke
      # Rects are larger than the cell for some overlap
      rect(0, 0, CELL_SIZE + 6, CELL_SIZE + 6)
      pop_matrix
    end
  end
end

# def captureEvent(c)
#   c.read
# end

def settings
  size(960, 544, P2D)
end

