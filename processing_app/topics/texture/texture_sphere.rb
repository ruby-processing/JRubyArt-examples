# Texture Sphere by Gillian Ramsay
#
# Rewritten by Gillian Ramsay to better display the poles. Previous version
# by Mike 'Flux' Chang (and cleaned up by Aaron Koblin). Original based on
# code by Toxi. Translated to JRubyArt and transformed by Martin Prout
#
# Textured sphere with ArcBall, zoom using mousewheel & rotate with mouse drag
attr_reader :res_w, :res_h, :img, :points_width, :points_height, :points_total
attr_reader :coor_x, :coor_y, :coor_z, :multXZ

def setup
  sketch_title 'Textured Sphere'
  ArcBall.init(self)
  background(0)
  noStroke
  @img = load_image(data_path('world32k.jpg'))
  @res_w = 30
  @res_h = 30
  # Parameters below are the number of vertices around the width and height
  initialize_sphere(res_w, res_h)
end

# Use arrow keys to change detail settings
def key_pressed
  case keyCode
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
  initialize_sphere res_w, res_h
end

def draw
  background 0
  texture_sphere 200, 200, 200, img
end

def initialize_sphere(res_x, res_y)
  # The number of points around the width and height
  @points_width = res_x + 1
  @points_total = res_y # How many actual pts around the sphere (not just from top to bottom)
  @points_height = (points_total / 2.0).to_i + 1 # How many pts from top to bottom (abs(....) b/c of the possibility of an odd points_total)
  @coor_x = Array.new(points_width) # All the x-coor in a horizontal circle radius 1
  @coor_y = Array.new(points_height) # All the y-coor in a vertical circle radius 1
  @coor_z = Array.new(points_width) # All the z-coor in a horizontal circle radius 1
  @multXZ = Array.new(points_height) # The radius of each horizontal circle (that you will multiply with coor_x and coor_z)
  points_width.times do |i| # For all the points around the width
    theta_w = i * TWO_PI / (points_width - 1)
    coor_x[i] = sin(theta_w)
    coor_z[i] = cos(theta_w)
  end
  points_height.times do |i| # For all points from top to bottom
    last_point_odd = points_total.odd? && i == points_height - 1
    numerator = last_point_odd ? (i - 1) * TWO_PI : i * TWO_PI
    theta_h = numerator / points_total
    multXZ[i] = last_point_odd ? 0 : sin(theta_h) # sin(0) == 0
    coor_y[i] = cos(PI + theta_h)
  end
end

def texture_sphere(rx, ry, rz, image)
  # These are so we can map certain parts of the image on to the shape
  delta_u = image.width / (points_width - 1).to_f
  delta_v = image.height / (points_height - 1).to_f
  u = 0 # Width variable for the texture
  v = 0 # Height variable for the texture
  begin_shape TRIANGLE_STRIP
  texture(image)
  (0...points_height - 1).each do |i|  # For all the rings but top and bottom
    # Goes into the array here instead of loop to save time
    coory = coor_y[i]
    coory_succ = coor_y[i.succ] # use succ (successor) rubyists should be happy
    multxz = multXZ[i]
    multxz_succ = multXZ[i.succ]
    (0...points_width).each do |j| # For all the pts in the ring
      normal(-coor_x[j] * multxz, -coory, -coor_z[j] * multxz)
      vertex(coor_x[j] * multxz * rx, coory * ry, coor_z[j] * multxz * rz, u, v)
      normal(-coor_x[j] * multxz_succ, -coory_succ, -coor_z[j] * multxz_succ)
      vertex(coor_x[j] * multxz_succ * rx, coory_succ * ry, coor_z[j] * multxz_succ * rz, u, v + delta_v)
      u += delta_u
    end
    v += delta_v
    u = 0
  end
  end_shape
end

def settings
  size(640, 360, P3D)
end
