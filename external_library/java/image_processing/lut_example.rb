# Example for lookup tables (LUT).
# Use the mouse wheel to switch the different tables/styles
# and press the left mouse button to see the original image.
#
# Author: Nick 'Milchreis' Müller
# Translated to JRubyArt by Martin Prout

load_library :ImageProcessing
java_import 'milchreis.imageprocessing.LUT'

attr_reader :my_image, :lookuptables, :current_index, :enums

def settings
  size(550, 550)
end

def setup
  sketch_title 'LUT Example'
  @current_index = 0
  # Load image
  @my_image = load_image(data_path('example.jpg'))
  # Create an array with all lookup-tables
  # LUT Styles:
  # RETRO, CONTRAST, CONTRAST_STRONG, ANALOG1, WINTER, SPRING, SUMMER, AUTUMN
  @enums = LUT::STYLE.values
  @lookuptables = enums.map do |enum|
    LUT.load_lut(enum.java_object)
  end
  # Load one style:
  # LUT style = LUT.loadLut(LUT.STYLE.ANALOG1)
end

def draw
  return image(my_image, 0, 0) if mouse_pressed?
  image(LUT.apply(my_image, lookuptables[current_index]), 0, 0)
  fill(0)
  stylename = enums[current_index].name
  text(stylename, width / 2 - textWidth(stylename) / 2, 30)
end

def mouseWheel(event) # keep camelcase for poxy java reflection
  @current_index += 1
  @current_index = 0 if current_index >= lookuptables.length
end
