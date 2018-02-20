# /* Example for stacking images.
#  * Generates an average face by 10 example faces.
#  * Normally the median pixel is selected.
#  * Use the mouse button to see the average mode.
#  *
#  * Author: Nick 'Milchreis' Müller
#  */
load_library :ImageProcessing
java_import 'milchreis.imageprocessing.Stacker'

# Dimensions for each face
GRID_WIDTH = 128
GRID_HEIGHT = 155
attr_reader :faces

def settings
  size(128, 155)
end

def setup
  sketch_title 'Stacker'
  # Load faces grid
  yale_faces = load_image(data_path('yaleBfaces.jpg'))
  @faces = []
  grid(yale_faces.width, yale_faces.height, GRID_WIDTH, GRID_HEIGHT) do |x, y|
    faces << yale_faces.get(x, y, GRID_WIDTH, GRID_HEIGHT)
  end
end

def draw
  faces_java = faces.to_java(Java::ProcessingCore::PImage)
  # Alternative algorithm is average
  return image(Stacker.apply(Stacker::ALGORITHM::AVERAGE, faces_java), 0, 0) if mouse_pressed?
  # Default algorithm is median
  image(Stacker.apply(faces_java), 0, 0)
  # The array is not essential. If you save your images in different variables use this:
  # Stacker.apply(image1, image2, image3) # works also
end
