# For use with Boundary
class Circle
  attr_reader :centroid, :radius
  def initialize(center, radius)
    @centroid = center
    @radius = radius
  end

  def contains?(vec)
    centroid.dist(vec) < radius
  end
end
