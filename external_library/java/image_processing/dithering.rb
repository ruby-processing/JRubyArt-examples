# Example for dithering an image to get a retro look.
#
# Use the mouse wheel to change the dithering algorithm
# and press spacebar to show it in gray scale for the perfect
# retro look.
#
# Author: Nick 'Milchreis' Müller
load_library :ImageProcessing
java_import 'milchreis.imageprocessing.Dithering'
java_import 'milchreis.imageprocessing.Grayscale'

attr_reader :my_image, :processed, :label, :index

def settings
  size(550, 550)
end

def setup
  sketch_title 'Dithering'
  @index = 0
  @my_image = load_image(data_path('example.jpg'))
end

def draw
  @processed = my_image
  @label = ''
  if key_pressed? && key == ' '
    @processed = Grayscale.apply(processed)
  end
  return image(my_image, 0, 0) if mouse_pressed?
  case index
  when -1
    @processed = Dithering.apply(processed)
    @label = 'BAYER_4x4 on default'
  when 0
    @processed = Dithering.apply(processed, Dithering::Algorithm::BAYER_2x2)
    @label = 'BAYER_2x2'
  when 1
    @processed = Dithering.apply(processed, Dithering::Algorithm::BAYER_4x4)
    @label = 'BAYER_4x4'
  when 2
    @processed = Dithering.apply(processed, Dithering::Algorithm::BAYER_8x8)
    @label = 'BAYER_8x8'
  end
  image(processed, 0, 0)
  fill(0)
  text(label, width / 2 - text_width(label) / 2, 30)
end

def mouseWheel(event)
  @index += event.get_count

  if index >= Dithering::Algorithm.values.length
    @index = -1
  end
end
