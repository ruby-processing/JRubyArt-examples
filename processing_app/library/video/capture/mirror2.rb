# Mirror Two
# by Daniel Shiffman.
#
# Each pixel from the video source is drawn as a rectangle with rotation
# based on brightness.

load_library :video
java_import 'processing.video.Capture'
attr_reader :video, :cols, :rows
# Size of each cell in the grid
CELL_SIZE = 15

def setup
  sketch_title 'mirror'
  frame_rate(30)
  @cols = width / CELL_SIZE
  @rows = height / CELL_SIZE
  colorMode(RGB, 255, 255, 255, 100)
  # Try test_capture to find name of your Camera
  @video = Capture.new(self, width, height, 'pipeline:autovideosrc')
  # Start capturing the images from the camera
  video.start
end

def draw
  return unless video.available # ruby guard clause

  background(0, 0, 255)
  video.read
  video.load_pixels
  grid(cols, rows) do |i, j|
    x = i * CELL_SIZE
    y = j * CELL_SIZE
    loc = (width - x - 1 + y * width)# Reversing x to mirror the image
    col = video.pixels[loc]
    # Code for drawing a single rect
    # Using translate in order for rotation to work properly
    # rectangle size is based on brightness
    sz = g.brightness(col) / 255 * CELL_SIZE
    rect_mode(CENTER)
    fill(255)
    no_stroke
    # Rects are larger than the cell for some overlap
    rect(x + CELL_SIZE / 2, y + CELL_SIZE / 2, sz, sz)
  end
end

def settings
  size(480, 360)
end
