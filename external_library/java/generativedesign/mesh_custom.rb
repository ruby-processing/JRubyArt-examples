load_library :generativedesign
java_import 'generativedesign.Mesh'
# part of the example files of the generativedesign library.
#
# shows how to use the mesh class, if you want to define your own forms.
A = 2/3.0
B = sqrt(2)
# mesh
attr_reader :my_mesh

def setup
  sketch_title 'Mesh Sketch'
  # setup drawing style
  color_mode(HSB, 360, 100, 100, 100)
  no_stroke
  # initialize mesh. class MyOwnMesh is defined below
  @my_mesh = MyOwnMesh.new(self)
  my_mesh.setUCount(100)
  my_mesh.setVCount(100)
  my_mesh.set_color_range(193, 193, 30, 30, 85, 85, 100)
  my_mesh.update
end

def draw
  background(255)
  # setup lights
  color_mode(RGB, 255, 255, 255, 100)
  light_specular(255, 255, 255)
  directional_light(255, 255, 255, 1, 1, -1)
  shininess(5.0)
  # setup view
  translate(width * 0.5, height * 0.5)
  scale(180)
  rotate_x(10.radians)
  rotate_y(-10.radians)
  # recalculate points and draw mesh
  my_mesh.draw
end

def settings
  size(1000,1000,P3D)
end

# define your own class that extends the Mesh class
class MyOwnMesh < Mesh

  def initialize(parent)
    super(parent)
  end
  # just override this function and put your own formulas inside
  def calculatePoints(u, v)
    x = A * (cos(u) * cos(2 * v) + B * sin(u) * cos(v)) * cos(u) / (B - sin(2 * u) * sin(3 * v))
    y = A * (cos(u) * sin(2 * v) - B * sin(u) * sin(v)) * cos(u) / (B - sin(2 * u) * sin(3 * v))
    z = B * cos(u) * cos(u) / (B - sin(2 * u) * sin(3 * v))
    Java::ProcessingCore::PVector.new(x, y, z)
  end
end
