#
# Graphing 2D Equations
# by Daniel Shiffman. 
# 
# Graphics the following equation: 
# sin(n*cos(r) + 5*theta) 
# where n is a function of horizontal mouse location.  
#
 
def setup
  sketch_title 'Graphing 2D Equation'
end

def draw
  load_pixels
  n = (mouse_x * 10.0) / width
  w = 16.0            # 2D space width
  h = 16.0            # 2D space height
  dx = w / width      # Increment x this amount per pixel
  dy = h / height     # Increment y this amount per pixel
  x = -w / 2          # Start x at -1 * width / 2
  width.times do |i|
    y = -h / 2        # Start y at -1 * height / 2
    height.times do |j|
      r = Math.sqrt((x * x) + (y * y))    # Convert cartesian to polar
      theta = Math.atan2(y, x)            # Convert cartesian to polar
      # Compute 2D polar coordinate function
      val = Math.sin(n * Math.cos(r) + 5 * theta)   # Results in a value between -1 and 1
      #val = Math.cos(r)                            # Another simple function
      #val = Math.sin(theta)                        # Another simple function
      # Map the resulting value to a grayscale value
      pixels[i + j * width] = color((val + 1.0) * 255 / 2.0)     # Scale to between 0 and 255
      y += dy                # Increment y
    end
    x += dx                  # Increment x
  end
  update_pixels
end

def settings
  size(640, 360)
end
