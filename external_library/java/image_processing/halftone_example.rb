# Example for halftone an image to get a old school print look.
#
# The dot size can be changed by moving the mouse left and right.
# The spacing between the dots can be changed by moving the mouse up and down.
# If you press the mouse button the dots will be shown in a grid.
#
# Author: Nick 'Milchreis' Müller

load_library :ImageProcessing
java_import 'milchreis.imageprocessing.Halftone'
attr_reader :my_image

def settings
  size(550, 550)
end

def setup
  sketch_title 'Half Tone'
  # Load image
  @my_image = load_image(data_path('example.jpg'))
end

def draw
  # Simple usage:
  # image = Halftone.apply(image, dotsize)

  # dotsize by mouseX
  dotsize = map1d(mouseX, 0..width, 3..10)

  # dots in grid or honeycomb style by mousePressed
  inGrid = mouse_pressed?

  # Foreground color
  foreground = '#335764'

  # Space between dots by mouseY
  space = map1d(mouseY, 0..height, 1..3)

  # Draw image
  image(Halftone.apply(my_image, dotsize, color(foreground), 255, space, inGrid), 0, 0)
end
