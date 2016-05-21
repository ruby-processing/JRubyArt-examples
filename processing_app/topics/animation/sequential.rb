#
# Sequential
# by James Paterson.
#
# Displaying a sequence of images creates the illusion of motion.
# Twelve images are loaded and each is displayed individually in a loop.
#

NUM_FRAMES = 12  # The number of frames in the animation
attr_reader :frame, :images

IMGFORM = 'PT_anim%s.gif'

def setup
  sketch_title 'Sequential'
  frame_rate(24)
  @frame = 0
  @images = (0...NUM_FRAMES).map do |i|
    load_image(format(IMGFORM, i.to_s.rjust(4, '0')))
  end
end

def draw
  background(0)
  @frame = (frame + 1) % NUM_FRAMES  # Use % to cycle through frames
  offset = 0
  (-100...width).step(images[0].width) do |i|
    image(images[(frame + offset) % NUM_FRAMES], i, -20)
    offset += 2
    image(images[(frame + offset) % NUM_FRAMES], i, height / 2)
    offset += 2
  end
end

def settings
  size(800, 360)
end
