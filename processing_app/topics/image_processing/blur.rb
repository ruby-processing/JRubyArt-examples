#
# Blur. 
# 
# A low-pass filter blurs an image. This program analyzes every
# pixel in an image and blends it with the neighboring pixels
# to blur the image. 
#
KERNEL = Array.new(3, Array.new(3, 1.0 / 9))
                 
attr_reader :img

def setup
  sketch_title 'Blur'
  @img = load_image(data_path('moon.jpg')) # Load the original image
  no_loop
end 

def draw
  image(img, 0, 0) # Displays the image from point (0,0) 
  img.load_pixels
  # Create an opaque image of the same size as the original
  edge_img = create_image(img.width, img.height, RGB)
  # Loop through every pixel in the image
  (1...img.height - 1).each do |y| 
    (1...img.width - 1).each do |x| 
      sum = 0 # Kernel sum for this pixel
      (-1..1).each do |ky| 
        (-1..1).each do |kx|
          # Calculate the adjacent pixel for this kernel point
          pos = (y + ky) * img.width + (x + kx)
          # Image is grayscale, red/green/blue are identical
          val = red(img.pixels[pos])
          # Multiply adjacent pixels based on the kernel values
          sum += KERNEL[ky + 1][kx + 1] * val
        end
      end
      # For this pixel in the new image, set the gray value
      # based on the sum from the kernel
      edge_img.pixels[y * img.width + x] = color(sum)
    end
  end
  # State that there are changes to edgeImg.pixels[]
  edge_img.updatePixels
  image(edge_img, width / 2, 0) # Draw the new image
end

def settings
  size(640, 360)
end

