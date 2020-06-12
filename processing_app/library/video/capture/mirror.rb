# Mirror 2
# by Daniel Shiffman.
#
# Each pixel from the video source is drawn as a rectangle with size based
# on brightness.
load_library :video
java_import 'processing.video.Capture'
attr_reader :video
# Size of each cell in the grid
CELL_SIZE = 15
OFFSET = CELL_SIZE / 2.0

def setup
  sketch_title 'mirror'
  colorMode(RGB, 255, 255, 255, 100)
  # Try test_capture to find the name of your Camera
  @video = Capture.new(self, width, height, 'UVC Camera (046d:0825)')
  video.start
end

def draw
  return unless video.available # ruby guard clause

  background(0, 0, 255)
  video.read
  video.load_pixels
  grid(width, height, CELL_SIZE, CELL_SIZE) do |x, y|
    loc = (width - x - 1 + y * width) # Reversing x to mirror the image
    sz = brightness(video.pixels[loc]) / 255 * CELL_SIZE
    rect_mode(CENTER)
    fill(255)
    no_stroke
    rect(x + OFFSET, y + OFFSET, sz, sz)
  end
end

def settings
  size(960, 544)
end
