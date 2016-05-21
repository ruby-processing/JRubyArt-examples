#
# Animated Sprite (Shifty + Teddy)
# by James Paterson, rubified by Martin Prout.
#
# Hold down the mouse button to change animations.
# Demonstrates loading, displaying, and animating GIF images.
# It would be easy to write a program to display
# animated GIFs, but would not allow as much control over
# the display sequence and rate of display.
#

DRAG = 30.0
SHIFTY = 'PT_Shifty_%s.gif'
TEDDY = 'PT_Teddy_%s.gif'

attr_reader :xpos, :ypos, :animation1, :animation2

def setup
  sketch_title 'Animated Sprite'
  background(255, 204, 0)
  frame_rate(24)
  @animation1 = Animation.new(SHIFTY, 38)
  @animation2 = Animation.new(TEDDY, 60)
  @ypos = height * 0.25
  @xpos = 0
end

def draw
  dx = mouse_x - xpos
  @xpos = xpos + dx / DRAG
  # Display the sprite at the position xpos, ypos
  if mouse_pressed?
    background(153, 153, 0)
    animation1.display(xpos - animation1.image_width / 2, ypos)
  else
    background(255, 204, 0)
    animation2.display(xpos - animation2.image_width / 2, ypos)
  end
end

# the animation class
class Animation
  attr_reader :images, :fcount, :frame

  def initialize(image_format, count)
    @fcount = count
    @frame = 0
    @images = (0...count).map do |i|
      load_image(format(image_format, i.to_s.rjust(4, '0')))
    end
  end

  def display(xpos, ypos)
    @frame = (frame + 1) % fcount
    image(images[frame], xpos, ypos)
  end

  def image_width
    images[0].width
  end
end

def settings
  size(640, 360)
end
