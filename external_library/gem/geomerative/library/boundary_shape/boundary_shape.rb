java_import 'geomerative.RPoint'
java_import 'geomerative.RShape'

# Shape Boundary Class
class Boundary < RShape
  def initialize(shp)
    super(shp)
  end

  def self.create_bounding_shape(shp)
    Boundary.new(shp)
  end

  def inside(shp)
    shp.get_points.each { |pt| return false unless contains(pt) }
    true
  end
end
