# Texture Sphere by Gillian Ramsay
#
# Rewritten by Gillian Ramsay to better display the poles. Previous version
# by Mike 'Flux' Chang (and cleaned up by Aaron Koblin). Original based on
# code by Toxi. Translated to JRubyArt and transformed by Martin Prout
#
# A 3D textured sphere with ArcBall.


attr_reader :res_w, :res_h, :img, :points_width, :points_height, :points_total
attr_reader :coorX, :coorY, :coorZ, :multXZ

def setup
  sketch_title 'Textured Sphere'
  ArcBall.init(self)
  background(0)
  noStroke
  @img = loadImage(data_path('world32k.jpg'))
  @res_w = 30
  @res_h = 30
  # Parameters below are the number of vertices around the width and height
  initialize_sphere(res_w, res_h)
end

# Use arrow keys to change detail settings
def key_pressed
  case (keyCode)
  when ENTER
    save_frame
  when UP
    @res_h += 1
  when DOWN
    @res_h -= 1 unless res_h < 3
  when LEFT
    @res_w -= 1 unless res_w < 2
  when RIGHT
    @res_h += 1
  end
  # Parameters below are the number of vertices around the width and height
  initialize_sphere(res_w, res_h)
end

def draw
  background(0)
  texture_sphere(200, 200, 200, img)
end

def initialize_sphere(res_x, res_y)

  # The number of points around the width and height
  @points_width = res_x + 1
  @points_total = res_y # How many actual pts around the sphere (not just from top to bottom)
  @points_height = (points_total / 2.0).to_i + 1 # How many pts from top to bottom (abs(....) b/c of the possibility of an odd points_total)

  @coorX = Array.new(points_width) # All the x-coor in a horizontal circle radius 1
  @coorY = Array.new(points_height) # All the y-coor in a vertical circle radius 1
  @coorZ = Array.new(points_width) # All the z-coor in a horizontal circle radius 1
  @multXZ = Array.new(points_height) # The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  points_width.times do |i| # For all the points around the width
    thetaW = i * 2 * PI / (points_width - 1)
    coorX[i] = sin(thetaW)
    coorZ[i] = cos(thetaW)
  end

  points_height.times do |i| # For all points from top to bottom
    if points_total.odd? && i == points_height - 1  # If the points_total is odd and it is at the last pt
      thetaH = (i - 1) * 2 * PI / (points_total)
      coorY[i] = cos(PI + thetaH)
      multXZ[i] = 0
    else
      #The points_total and 2 below allows there to be a flat bottom if the points_height is odd
      thetaH = i * 2 * PI / (points_total)
      #PI+ below makes the top always the point instead of the bottom.
      coorY[i] = cos(PI + thetaH)
      multXZ[i] = sin(thetaH)
    end
  end
end

def texture_sphere(rx, ry, rz, image)
  # These are so we can map certain parts of the image on to the shape
  changeU = image.width / (points_width - 1).to_f
  changeV = image.height / (points_height - 1).to_f
  u = 0 # Width variable for the texture
  v = 0 # Height variable for the texture

  begin_shape(TRIANGLE_STRIP)
  texture(image)
  (0...points_height - 1).each do |i|  # For all the rings but top and bottom
    # Goes into the array here instead of loop to save time
    coory = coorY[i]
    cooryPlus = coorY[i + 1]

    multxz = multXZ[i]
    multxzPlus = multXZ[i + 1]

    (0...points_width).each do |j| # For all the pts in the ring
      normal(-coorX[j] * multxz, -coory, -coorZ[j] * multxz)
      vertex(coorX[j] * multxz * rx, coory * ry, coorZ[j] * multxz * rz, u, v)
      normal(-coorX[j] * multxzPlus, -cooryPlus, -coorZ[j] * multxzPlus)
      vertex(coorX[j] * multxzPlus * rx, cooryPlus * ry, coorZ[j] * multxzPlus * rz, u, v + changeV)
      u += changeU
    end
    v += changeV
    u = 0
  end
  end_shape
end

def settings
  size(640, 360, P3D)
end
