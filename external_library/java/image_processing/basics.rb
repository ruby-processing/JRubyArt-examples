# Example for basic image processing algorithms.
# Use the mouse wheel to switch the different algorithms
# and press the left mouse button to see the original image.
#
# Author: Nick 'Milchreis' Müller

load_library :ImageProcessing

include_package 'milchreis.imageprocessing'

NUMBER_OF_ALGORITHMS = 11
attr_reader :current_algorithm, :processed_image, :my_image

def settings
  size(550, 550)
end

def setup
  sketch_title 'Image Processing'
  @my_image = loadImage(data_path('example.jpg'))
  @current_algorithm = 0
end

def draw
  return image(my_image, 0, 0) if mouse_pressed?

  # Grayscale converts the image in to 256 shades of gray
  case current_algorithm
  when 0
    @processed_image = Grayscale.apply(my_image)# if current_algorithm == 0

    # Threshold converts a pixel in bright or dark for a specific color value
  when 1
    # automatic
    # @processed_image = Threshold.apply(my_image)

    # by mouseX
    @processed_image = Threshold.apply(my_image, map1d(mouse_x, 0..width, 0..255))

    # Dilation expands the white regions by a radius
    # works best with threshold/binary images
  when 2, 3, 10
    quant = map1d(mouse_x, 0..width, 1..10)
    return @processed_image = Quantization.apply(
      my_image, quant
    ) if current_algorithm == 10
    @processed_image = Threshold.apply(my_image)
    if current_algorithm == 2
      @processed_image = Dilation.apply(processed_image, quant)
    else
      # Erosion expands the dark regions by a radius
      # works best with threshold/binary images
      @processed_image = Erosion.apply(processed_image, quant)
    end

    # Brightness correction
  when 4
    intensity = map1d(mouse_x, 0..width, -255..255)
    @processed_image = Brightness.apply(my_image, intensity)

    # AutoBalance for simple color correction
  when 5
    @processed_image = AutoBalance.apply(my_image)

    # Pixelation
  when 6
    pixelsize = map1d(mouse_x, 0..width, 0..100)
    @processed_image = Pixelation.apply(my_image, pixelsize)

    # Gaussian for blurred images
  when 7
    @processed_image = Gaussian.apply(my_image, 7, 0.84089642)

    # Edge detection with Canny's algorithm
  when 8
    @processed_image = CannyEdgeDetector.apply(my_image)

    # Edge detection with Sobel's algorithm
  when 9
    # SobelEdgeDetector.apply(image, false) creates a colored image
    @processed_image = SobelEdgeDetector.apply(my_image)
  end
  # show image
  image(processed_image, 0, 0)
end

def mouseWheel(event) # keep camelcase poxy reflection
  @current_algorithm += event.getCount
  @current_algorithm = 0 if current_algorithm >= NUMBER_OF_ALGORITHMS
  @current_algorithm = NUMBER_OF_ALGORITHMS - 1 if current_algorithm < 0
end
