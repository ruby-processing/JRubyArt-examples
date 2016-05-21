#
# ASCII Video
# by Ben Fry, translated to JRubyArt by Martin Prout.
#
#
# Text chars have been used to represent images since the earliest computers.
# This sketch is a simple homage that re-interprets live video as ASCII text.
# See the key_pressed function for more options, like changing the font size.
#
load_library :video, :video_event
include_package 'processing.video'

attr_reader :bright, :char, :cheat_screen, :font, :font_size, :letters, :video

# All ASCII characters, sorted according to their visual density
LETTER_STRING = %q{ .`-_':,;^=+/\"|)\\<>)iv%xclrs{*}I?!][1taeo7zjLunT#JCwfy325Fp6mqSghVd4EgXPGZbYkOA&8U$@KHDBWNMR0Q}
LETTER_ORDER = LETTER_STRING.scan(/./)

def setup
  sketch_title 'Ascii Capture'
  init_video
  @font_size = 1.5
  @font = load_font('UniversLTStd-Light-48.vlw')
  # for the 256 levels of brightness, distribute the letters across
  # the an array of 256 elements to use for the lookup
  @letters = (0...256).map do |i|
    LETTER_ORDER[map1d(i, (0...256), (0...LETTER_ORDER.length))]
  end
  # current brightness for each point
  @bright = Array.new(video.width * video.height, 128)
end

def init_video
  # This the default video input, see the test_capture
  # example if it creates an error
  @video = Capture.new(self, 160, 120)
  # Start capturing the images from the camera
  video.start
  @cheat_screen = false
end

def captureEvent(c)
  c.read
end

def draw
  background 0
  push_matrix
  hgap = width / video.width
  vgap = height / video.height
  scale([hgap, vgap].max * font_size)
  text_font(font, font_size)
  index = 0
  video.load_pixels
  (0...video.height).each do
    # Move down for next line
    translate(0,  1.0 / font_size)
    push_matrix
    (0...video.width).each do
      pixel_color = video.pixels[index]
      # Faster method of calculating r, g, b than red(), green(), blue()
      r = pixel_color >> 16 & 0xff
      g = pixel_color >> 8 & 0xff
      b = pixel_color & 0xff
      # Another option would be to properly calculate brightness as luminance:
      # luminance = 0.3*red + 0.59*green + 0.11*blue
      # Or you could instead red + green + blue, and make the the values[] array
      # 256*3 elements long instead of just 256.
      pixel_bright = [r, g, b].max
      # The 0.1 value is used to damp the changes so that letters flicker less
      diff = pixel_bright - bright[index]
      bright[index] += diff * 0.1
      fill(pixel_color)
      text(letters[bright[index]], 0, 0)
      # Move to the next pixel
      index += 1
      # Move over for next character
      translate(1.0 / font_size, 0)
    end
    pop_matrix
  end
  pop_matrix
  # image(video, 0, height - video.height)
  # set() is faster than image() when drawing untransformed images
  set(0, height - video.height, video) if cheat_screen
end

MESSAGE = <<-EOS
Controls are:
  g to save_frame, f & F to set font size
  c to toggle cheat screen display
EOS

#
# Handle key presses:
# 'c' toggles the cheat screen that shows the original image in the corner
# 'g' grabs an image and saves the frame to a tiff image
# 'f' and 'F' increase and decrease the font size
#
def key_pressed
  case key
  when 'g' then save_frame
  when 'c' then @cheat_screen = !cheat_screen
  when 'f' then @font_size *= 1.1
  when 'F' then @font_size *= 0.9
  else
    warn MESSAGE
  end
end

def settings
  size(960, 544, P2D)
end

