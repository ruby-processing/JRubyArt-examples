# Modified from code by Martin.
# Original 'Color Typewriter' concept by John Maeda.
#
# Click on the window to give it focus and press the letter keys to type
# colors. The keyboard function keyPressed() is called whenever a key is
# pressed.
MAX_HEIGHT = 40
MIN_HEIGHT = 20
NUM_CHARS = 26
attr_reader :colours, :letter_width, :letter_height, :x, :y
attr_reader :new_letter

def setup
  sketch_title 'Keyboard Functions'
  @letter_width = MAX_HEIGHT
  @letter_height = MIN_HEIGHT
  @x = -letter_width
  @y = 0
  @new_letter = false
  background(125)
  # changing hue with key value
  @colours = (0..NUM_CHARS).map{ |i| hsb_color(norm(i, 0, NUM_CHARS), 1.0, 1.0) }
end

def draw
  if new_letter
    if letter_height == MAX_HEIGHT
      rect(x, y, letter_width, letter_height)
    else
      rect(x, y + MIN_HEIGHT, letter_width, letter_height)
    end
    @new_letter = false
  end
end

def key_pressed
  if ('A'..'z').include? key
    key_index = key.ord - (key <= 'Z' ? 'A'.ord : 'a'.ord)
    fill colours[key_index]
    @letter_height = (key <= 'Z' ? MAX_HEIGHT : MIN_HEIGHT)
  else
    fill 0
    @letter_height = 10
  end
  @new_letter = true
  # update letter position
  @x += letter_width
  # wrap vertically
  if (x > width - letter_width)
    @x = 0
    @y += MAX_HEIGHT
  end
end

def settings
  size(640, 360)
end

