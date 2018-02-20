# Example for sharpening an image to get a crunchy look.
# The intensity of this effect increases slowly.
# Press the left mouse button to see the original image.
#
# Author: Nick 'Milchreis' Müller
load_library :ImageProcessing
java_import 'milchreis.imageprocessing.Sharpen'

attr_reader :my_image, :sharp_intensity

def settings
  size(550, 550)
end

def setup
  sketch_title 'Sharpen'
  @sharp_intensity = 0
  @my_image = load_image(data_path('example.jpg'))
end

def draw
  return image(my_image, 0, 0) if mouse_pressed?
  image(Sharpen.apply(my_image, sharp_intensity), 0, 0)
  # Reset the intensity or increase it
  @sharp_intensity = (sharp_intensity > 6) ? 0 : sharp_intensity + 0.05
end
