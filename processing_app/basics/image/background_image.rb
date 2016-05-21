# This example presents the fastest way to load a background image
# into Processing. To load an image as the background, it must be
# the same width and height as the program.

def setup
  sketch_title 'Background Image'
  frame_rate 30
  @a = 0
  # is 200 x 200 pixels.
  @background_image = load_image 'milan_rubbish.jpg'
end

def draw
  background @background_image
  @a = (@a + 1) % (width+32)
  stroke 266, 204, 0
  line 0, @a,   width, @a-26
  line 0, @a-6, width, @a-32
end

def settings
  size 200, 200
end
