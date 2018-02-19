# Example for an artificial glitch effect.
# Move the mouse from left to right to see different intensity
# or press the left mouse button to see the original image.
#
# Author: Nick 'Milchreis' Müller
# Translated to JRubyArt by Martin Prout

load_library :ImageProcessing
java_import 'milchreis.imageprocessing.Glitch'

attr_reader :my_image

def setup
  sketch_title 'Glitch'
  # Load image
  @my_image = load_image(data_path('example.jpg'))
end

def draw
  return image(my_image, 0, 0) if mouse_pressed?
  intensity = map1d(mouseX, 0..width, 0..4)
  image(Glitch.apply(my_image, intensity), 0, 0)
  # You can also use:
  # Glitch.apply(image)
  # Glitch.apply(image, intensity, scanlineHeight)
end

def settings
  size(550, 550)
end
