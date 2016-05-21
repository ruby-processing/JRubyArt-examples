# fibonacci_sphere.rb
# After a vanilla processing sketch by Jim Bumgardner
# http://www.openprocessing.org/sketch/41142
#
# Controls:
# 1. drag mouse to rotate sphere (uses builtin arcball library)
# 2. click mouse to toggle add boxes to sphere surface
# 3. press x, y, or z to constrain arcball rotation to that axis
#

PHI = (sqrt(5) + 1) / 2 - 1 # golden ratio
GA = PHI * TAU # golden angle
KMAX_POINTS = 100_000
MIN_POINTS = 2_000

attr_reader :pts, :rotation_x, :rotation_y, :nbr_points, :radius, :add_points
attr_reader :my_ball # for arcball rotation

def setup
  sketch_title 'Fibonacci Sphere'
  ArcBall.init(self, width / 2.0, height / 2.0)
  @rotation_x = 0
  @rotation_y = 0
  @nbr_points = MIN_POINTS
  @radius = 0.8 * height / 2
  @add_points = false
  @pts = init_sphere(nbr_points)
  background(0)
end

def draw
  if add_points
    @nbr_points += 1 unless nbr_points > KMAX_POINTS
    @pts = init_sphere(nbr_points)
  end
  background 0
  lights
  ambient(200, 10, 10)
  ambient_light(150, 150, 150)
  render_globe
end

###########################################
# For Fibonacci Sphere
##################################

def render_globe
  push_matrix
  pts.map do |pt|
    lat = pt.lat
    lon = pt.lon
    push_matrix
    rotate_y(lon)
    rotate_z(-lat)
    fill(200, 10, 10)
    translate(radius, 0, 0)
    box(4, 7, 7)
    pop_matrix
  end
  pop_matrix
end

def mouse_clicked
  @add_points = !add_points
  @nbr_points = MIN_POINTS
end

SpherePoint = Struct.new(:lat, :lon)

def init_sphere(num)
  Array.new(num) do |i|
    lon = GA * i
    lon /= TAU
    lon -= lon.floor
    lon *= TAU
    lon -= TAU if lon > PI
    # Convert dome height (which is proportional to surface area) to latitude
    # lat = asin(-1 + 2 * i / num.to_f)
    SpherePoint.new(asin(-1 + 2 * i / num.to_f), lon)
  end
end

def settings
  size(1024, 768, P3D)
end
