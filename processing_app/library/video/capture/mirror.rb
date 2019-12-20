#
# Mirror
# by Daniel Shiffman.
#
# Each pixel from the video source is drawn as a rectangle with rotation
# based on brightness.

load_library :video
attr_reader :video, :cols, :rows
# Size of each cell in the grid
CELL_SIZE = 40
java_alias :color_float, :color, [Java::float, Java::float, Java::float, Java::float]

def setup
  sketch_title 'mirror'
  frame_rate(30)
  @cols = width / CELL_SIZE
  @rows = height / CELL_SIZE
  colorMode(RGB, 255, 255, 255, 100)
  # This the default video input, try test_capture to find name of your Camera
  @video = Java::ProcessingVideo::Capture.new(self, 960, 720, "UVC Camera (046d:0825)")
  # Start capturing the images from the camera
  video.start
  background(0)
end

def draw
  return unless video.available # ruby guard clause

  video.read
  video.loadPixels
  grid(width, height, cols, rows) do |x, y|
    loc = (video.width - x - 1) + y * video.width # Reversing x to mirror the image
    col = color_float(
      red(video.pixels[loc]),
      green(video.pixels[loc]),
      blue(video.pixels[loc]),
      75 # alpha
    )
    # Code for drawing a single rect
    # Using translate in order for rotation to work properly
    push_matrix
    translate(x + CELL_SIZE / 2, y + CELL_SIZE / 2)
    # Rotation formula based on brightness
    rotate((2 * PI * brightness(col) / 255.0))
    rect_mode(CENTER)
    fill(col)
    no_stroke
    # Rects are larger than the cell for some overlap
    rect(0, 0, CELL_SIZE + 6, CELL_SIZE + 6)
    pop_matrix
  end
end

def settings
  size(960, 720)
end
