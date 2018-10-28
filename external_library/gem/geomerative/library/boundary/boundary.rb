java_import 'geomerative.RPoint'
java_import 'geomerative.RShape'

# Rectangle Boundary Class
class Boundary < RShape
  def initialize
    super
  end

  def self.create_bounding_rectangle(xpos, ypos, width, height)
    Boundary.new.tap do |rect|
      rect.add_move_to(xpos, ypos)
      rect.add_line_to(xpos + width, ypos)
      rect.add_line_to(xpos + width, ypos + height)
      rect.add_line_to(xpos, ypos + height)
      rect.add_line_to(xpos, ypos)
    end
  end

  def inside(shp)
    shp.get_points.each { |pt| return false unless contains(pt) }
    true
  end
end
