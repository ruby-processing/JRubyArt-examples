#
# Background Subtraction
# by Golan Levin.
# translated to JRubyArt by Martin Prout
# Detect the presence of people and objects in the frame using a simple
# background-subtraction technique. To initialize the background, press a key.
#

load_libraries :video, :video_event
include_package 'processing.video'

attr_reader :background_pixels, :number_of_pixels, :video

def setup
  sketch_title 'Background Subtraction'
  init_video
end

def init_video
  # This the default video input, see the test_capture
  # example if it creates an error
  @video = Capture.new(self, width, height)
  # Start capturing the images from the camera
  video.start
  # Create array to store the background image
  @number_of_pixels = video.width * video.height
  @background_pixels = Array.new(number_of_pixels, 0)
  # Make the pixels[] array available for direct manipulation
  load_pixels
end

def capture  # captureEvent does not work like vanilla processing
  @video.read
  background 0
end

def draw
  video.load_pixels # Make the pixels of video available
  # Difference between the current frame and the stored background
  # current_sum = 0
  number_of_pixels.times do |i| # For each pixel in the video frame...
    # Fetch the current color in that location, and also the color
    # of the background in that spot
    curr_color = video.pixels[i]
    bkgd_color = background_pixels[i]
    # Extract the red, green, and blue components of the current pixel's color
    curr_r = curr_color >> 16 & 0xff
    curr_g = curr_color >> 8 & 0xff
    curr_b = curr_color & 0xff
    # Extract the red, green, and blue of the background pixel's color
    bkgd_r = bkgd_color >> 16 & 0xff
    bkgd_g = bkgd_color >> 8 & 0xff
    bkgd_b = bkgd_color & 0xff
    # Compute the difference of the red, green, and blue values
    diff_r = (curr_r - bkgd_r).abs
    diff_g = (curr_g - bkgd_g).abs
    diff_b = (curr_b - bkgd_b).abs
    # Add these differences to the running tally
    # current_sum += diff_r + diff_g + diff_b
    # Render the difference image to the screen
    pixels[i] = (diff_r << 16) | (diff_g << 8) | diff_b
  end
  update_pixels # Notify that the pixels[] array has changed
  # p current_sum # Print out the total amount of movement
end

def captureEvent(c)
  c.read
end

def key_pressed
  video.load_pixels
  @background_pixels = video.pixels.clone
end

def settings
  size(960, 544, P2D)
end

